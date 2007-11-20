Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbXKTOtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbXKTOtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 09:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbXKTOs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 09:48:57 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:60220 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753344AbXKTOs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 09:48:56 -0500
Date: Tue, 20 Nov 2007 20:18:52 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, apw@shadowen.org,
       balbir@linux.vnet.ibm.com
Subject: [PATCH] mm snapshot broken-out-2007-11-20-01-45 Build Failure arch/x86/kernel/pci-gart_64.c
Message-ID: <20071120144852.GC4438@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The kernel build fails, with foloowing message,

  CC      arch/x86/kernel/pci-gart_64.o
arch/x86/kernel/pci-gart_64.c: In function ‘gart_map_sg’:
arch/x86/kernel/pci-gart_64.c:421: error: redeclaration of ‘s’ with no linkage
arch/x86/kernel/pci-gart_64.c:416: error: previous declaration of ‘s’was here
arch/x86/kernel/pci-gart_64.c:421: error: redeclaration of ‘ps’ with no linkage
arch/x86/kernel/pci-gart_64.c:416: error: previous declaration of ‘ps’ was here
arch/x86/kernel/pci-gart_64.c:421: error: redeclaration of ‘start_sg’with no linkage
arch/x86/kernel/pci-gart_64.c:416: error: previous declaration of ‘start_sg’ was here
arch/x86/kernel/pci-gart_64.c:421: error: redeclaration of ‘sgmap’ with no linkage
arch/x86/kernel/pci-gart_64.c:416: error: previous declaration of ‘sgmap’ was here
make[1]: *** [arch/x86/kernel/pci-gart_64.o] Error 1
make: *** [arch/x86/kernel] Error 2

This is caused by the git-x86-fixup.patch.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--

--- linux-2.6.24-rc3/arch/x86/kernel/pci-gart_64.c	2007-11-21 00:16:23.000000000 +0530
+++ linux-2.6.24-rc3/arch/x86/kernel/~pci-gart_64.c	2007-11-21 04:02:12.000000000 +0530
@@ -418,7 +418,6 @@ gart_map_sg(struct device *dev, struct s
 	unsigned long pages = 0;
 	unsigned int seg_size;
 	unsigned int max_seg_size;
-	struct scatterlist *s, *ps, *start_sg, *sgmap;
 
 	if (nents == 0)
 		return 0;


