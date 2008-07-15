Return-Path: <linux-kernel-owner+w=401wt.eu-S1763859AbYGOWgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763859AbYGOWgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763676AbYGOWcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:32:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763671AbYGOWct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:32:49 -0400
Date: Tue, 15 Jul 2008 18:32:37 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@devserv.devel.redhat.com
To: David Miller <davem@davemloft.net>
cc: andi@firstfloor.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
In-Reply-To: <20080714.183116.121978835.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0807151830290.22181@devserv.devel.redhat.com>
References: <Pine.LNX.4.64.0807141000340.24718@devserv.devel.redhat.com>
 <20080714.143751.266098047.davem@davemloft.net>
 <Pine.LNX.4.64.0807141903001.2825@devserv.devel.redhat.com>
 <20080714.183116.121978835.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008, David Miller wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> Date: Mon, 14 Jul 2008 19:16:17 -0400 (EDT)
> 
> > So the question is: to reduce number of requests by 12% on an outdated 
> > SCSI card, it is sensible to maintain complicated merge accounting logic 
> > in the core block layer? To me, it doesn't seem sensible.
> 
> Rip out the code if you like, then.  I really don't have time to
> work on this myself.  So if you do, by all means do whatever
> you think is appropriate.

So add signed-off line and forward it to Linus.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 include/asm-sparc64/io.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6.26-fast/include/asm-sparc64/io.h
===================================================================
--- linux-2.6.26-fast.orig/include/asm-sparc64/io.h	2008-07-15 23:29:39.000000000 +0200
+++ linux-2.6.26-fast/include/asm-sparc64/io.h	2008-07-15 23:33:41.000000000 +0200
@@ -16,7 +16,10 @@
 /* BIO layer definitions. */
 extern unsigned long kern_base, kern_size;
 #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
-#define BIO_VMERGE_BOUNDARY	8192
+
+/* Don't declare that we are virtual-merge capable because Sparc64 IOMMU code
+   doesn't guarantee that the merge is always possible */
+#define BIO_VMERGE_BOUNDARY	0
 
 static inline u8 _inb(unsigned long addr)
 {
