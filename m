Return-Path: <linux-kernel-owner+w=401wt.eu-S1752434AbYKLJLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbYKLJLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 04:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYKLJL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 04:11:28 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:49367 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbYKLJL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 04:11:26 -0500
Date: Wed, 12 Nov 2008 14:41:02 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: rusty@rustcorp.com.au
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       sfr@canb.auug.org.au, lguest@ozlabs.org
Subject: linux-next: Tree for November 12 - lguest build failure
Message-ID: <20081112091102.GA8063@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20081112182818.6e259488.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081112182818.6e259488.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

 lguest build fails with next-20081112 kernel,

drivers/lguest/lguest_device.c: In function ‘lg_find_vq’:
drivers/lguest/lguest_device.c:252: error: too many arguments to function ‘vring_size’
make[2]: *** [drivers/lguest/lguest_device.o] Error 1

removing the extra argument passed to vring_size function.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
--- linux-2.6/drivers/lguest/lguest_device.c	2008-09-22 15:32:33.000000000 +0530
+++ linux-2.6/drivers/lguest/~lguest_device.c	2008-11-12 14:16:17.000000000 +0530
@@ -249,8 +249,7 @@ static struct virtqueue *lg_find_vq(stru
 	       (unsigned long)lvq->config.pfn << PAGE_SHIFT);
 	/* Figure out how many pages the ring will take, and map that memory */
 	lvq->pages = lguest_map((unsigned long)lvq->config.pfn << PAGE_SHIFT,
-				DIV_ROUND_UP(vring_size(lvq->config.num,
-							PAGE_SIZE),
+				DIV_ROUND_UP(vring_size(lvq->config.num),
 					     PAGE_SIZE));
 	if (!lvq->pages) {
 		err = -ENOMEM;
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
