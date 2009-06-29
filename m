Return-Path: <linux-kernel-owner+w=401wt.eu-S1759736AbZF2OgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759736AbZF2OgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 10:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757372AbZF2OgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 10:36:05 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:20540 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbZF2OgE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 10:36:04 -0400
MIME-Version: 1.0
Message-ID: <0dbec206-c157-4482-8fd7-4ccf9c2bdc5a@default>
Date: Mon, 29 Jun 2009 07:34:34 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       npiggin@suse.de, chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, Avi Kivity <avi@redhat.com>, jeremy@goop.org,
       Rik van Riel <riel@redhat.com>, alan@lxorguk.ukuu.org.uk,
       Rusty Russell <rusty@rustcorp.com.au>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@osdl.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, tmem-devel@oss.oracle.com,
       sunil.mushran@oracle.com, linux-mm@kvack.org,
       Himanshu Raj <rhim@microsoft.com>
Subject: RE: [RFC] transcendent memory for Linux
In-Reply-To: <20090624150420.GH1784@ucw.cz>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.2  (306040) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt010.oracle.com [141.146.116.19]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.4A48D111.009C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel --

Thanks for the feedback!

> This description (whole mail) needs to go into 
> Documentation/, somewhere. 

Good idea.  I'll do that for the next time I post the patches.

> > Normal memory is directly addressable by the kernel,
> > of a known normally-fixed size, synchronously accessible,
> > and persistent (though not across a reboot).
> ...
> > Transcendent memory, or "tmem" for short, provides a
> > well-defined API to access this unusual class of memory.
> > The basic operations are page-copy-based and use a flexible
> > object-oriented addressing mechanism.  Tmem assumes
> 
> Should this API be documented, somewhere? Is it in-kernel API or does
> userland see it?

It is documented currently at:

http://oss.oracle.com/projects/tmem/documentation/api/

(just noticed I still haven't posted version 0.0.2 which
has a few minor changes).

I will add a briefer description of this API in Documentation/

It is in-kernel only because some of the operations have
a parameter that is a physical page frame number.

> > "Preswap" IS persistent, but for various reasons may not always
> > be available for use, again due to factors that may not be
> > visible to the kernel (but, briefly, if the kernel is being
> > "good" and has shared its resources nicely, then it will be
> > able to use preswap, else it will not).  Once a page is put,
> > a get on the page will always succeed.  So when the kernel
> > finds itself in a situation where it needs to swap out a page,
> > it first attempts to use preswap.  If the put works, a disk
> > write and (usually) a disk read are avoided.  If it doesn't,
> > the page is written to swap as usual.  Unlike precache, whether
> 
> Ok, how much slower this gets in the worst case? Single hypercall to
> find out that preswap is unavailable? I guess that compared to disk
> access that's lost in the noise?

Yes, the overhead of one hypercall per swap page is lost in
the noise.

Dan
