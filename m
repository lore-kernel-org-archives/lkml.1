Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbZF2VPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbZF2VPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 17:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbZF2VPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 17:15:09 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:39529 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbZF2VPI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 17:15:08 -0400
MIME-Version: 1.0
Message-ID: <6639b922-4ed7-48fd-9a3d-c78a4f93355c@default>
Date: Mon, 29 Jun 2009 14:13:56 -0700 (PDT)
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
In-Reply-To: <20090629203619.GA6611@elf.ucw.cz>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.2  (306040) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt010.oracle.com [141.146.116.19]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4A492EA9.0221:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It is documented currently at:
> > 
> > http://oss.oracle.com/projects/tmem/documentation/api/
> > 
> > (just noticed I still haven't posted version 0.0.2 which
> > has a few minor changes).
> > 
> > I will add a briefer description of this API in Documentation/
> 
> Please do.

OK, will do.

> At least TMEM_NEW_POOL() looks quite ugly. Why uuid? Mixing flags into
> size argument is strange.

The uuid is only used for shared pools.  If two different
"tmem clients" (guests) agree on a 128-bit "shared secret",
they can share a tmem pool.  For ocfs2, the 128-bit uuid in
the on-disk superblock is used for this purpose to implement
shared precache.  (Pages evicted by one cluster node
can be used by another cluster node that co-resides on
the same physical system.)

The (page)size argument is always fixed (at PAGE_SIZE) for
any given kernel.  The underlying implementation can
be capable of supporting multiple pagesizes.

So for the basic precache and preswap uses, "new pool"
has a very simple interface.

> > It is in-kernel only because some of the operations have
> > a parameter that is a physical page frame number.
> 
> In-kernel API is probably better described as function prototypes.

Good idea.  I will do that.

Thanks,
Dan
