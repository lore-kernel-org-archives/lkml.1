Return-Path: <linux-kernel-owner+w=401wt.eu-S1161450AbXDLBmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161450AbXDLBmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 21:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161453AbXDLBmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 21:42:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:54038 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161450AbXDLBmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 21:42:07 -0400
Subject: [PATCH] fix bogon in /dev/mem mmap'ing on nommu
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@osdl.org>
Cc: David Howells <dhowells@redhat.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 12 Apr 2007 11:41:54 +1000
Message-Id: <1176342114.8061.116.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While digging through my MAP_FIXED changes, I found that rather obvious
bug in /dev/mem mmap implementation for nommu archs. get_unmapped_area()
is expected to return an address, not a pfn.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

I suppose that can go in anytime, and probably in stable too, Dave ?

Index: linux-cell/drivers/char/mem.c
===================================================================
--- linux-cell.orig/drivers/char/mem.c	2007-02-12 10:36:14.000000000 +1100
+++ linux-cell/drivers/char/mem.c	2007-04-12 11:38:44.000000000 +1000
@@ -248,7 +248,7 @@ static unsigned long get_unmapped_area_m
 {
 	if (!valid_mmap_phys_addr_range(pgoff, len))
 		return (unsigned long) -EINVAL;
-	return pgoff;
+	return pgoff << PAGE_SHIFT;
 }
 
 /* can't do an in-place private mapping if there's no MMU */


