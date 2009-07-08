Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbZGHXdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbZGHXdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 19:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbZGHXdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 19:33:21 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:47965 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756942AbZGHXdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 19:33:12 -0400
MIME-Version: 1.0
Message-ID: <ac5dec0d-e593-4a82-8c9d-8aa374e8c6ed@default>
Date: Wed, 8 Jul 2009 16:31:29 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: npiggin@suse.de, akpm@osdl.org, jeremy@goop.org,
       xen-devel@lists.xensource.com, tmem-devel@oss.oracle.com,
       kurt.hackel@oracle.com, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, dave.mccracken@oracle.com,
       linux-mm@kvack.org, chris.mason@oracle.com, sunil.mushran@oracle.com,
       Avi Kivity <avi@redhat.com>, Schwidefsky <schwidefsky@de.ibm.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, alan@lxorguk.ukuu.org.uk,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: RE: [Xen-devel] Re: [RFC PATCH 0/4] (Take 2): transcendent memory
 ("tmem") for Linux
In-Reply-To: <4A55243B.8090001@codemonkey.ws>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.2  (306040) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4A552C83.0026:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anthony --

Thanks for the comments.

> I have trouble mapping this to a VMM capable of overcommit 
> without just coming back to CMM2.
> 
> In CMM2 parlance, ephemeral tmem pools is just normal kernel memory 
> marked in the volatile state, no?

They are similar in concept, but a volatile-marked kernel page
is still a kernel page, can be changed by a kernel (or user)
store instruction, and counts as part of the memory used
by the VM.  An ephemeral tmem page cannot be directly written
by a kernel (or user) store, can only be read via a "get" (which
may or may not succeed), and doesn't count against the memory
used by the VM (even though it likely contains -- for awhile --
data useful to the VM).

> It seems to me that an architecture built around hinting 
> would be more 
> robust than having to use separate memory pools for this type 
> of memory 
> (especially since you are requiring a copy to/from the pool).

Depends on what you mean by robust, I suppose.  Once you
understand the basics of tmem, it is very simple and this
is borne out in the low invasiveness of the Linux patch.
Simplicity is another form of robustness.

> For instance, you can mark data DMA'd from disk (perhaps by 
> read-ahead) 
> as volatile without ever bringing it into the CPU cache.  
> With tmem, if 
> you wanted to use a tmem pool for all of the page cache, you'd likely 
> suffer significant overhead due to copying.

The copy may be expensive on an older machine, but on newer
machines copying a page is relatively inexpensive.  On a reasonable
multi-VM-kernbench-like benchmark I'll be presenting at Linux
Symposium next week, the overhead is on the order of 0.01%
for a fairly significant savings in IOs.
