Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbYHQPwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbYHQPwG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 11:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbYHQPvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 11:51:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:8838 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbYHQPvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 11:51:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fopcm7P9M/Sebxve1xrV8gdQPHFMJYhPfWf9hbbvd52O6IfC1L6cr29w588HVb8jwX
         pJc+5HZmvO+VRDGPNagntCnnLQ14Sn+NSFVxCAgNgtFACzb+RRZplAN0v4WDVsaxHpzn
         Dg+AWKvM/K8euy3XkgRScdqtyE6fQXJSm+aEw=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Chandru Siddalingappa <chandru@in.ibm.com>
Subject: [PATCH] x86,calgary: fix section mismatch warning - get_tce_space_from_tar
Date: Sun, 17 Aug 2008 17:50:52 +0200
Message-Id: <1218988252-17932-3-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218988252-17932-1-git-send-email-marcin.slusarz@gmail.com>
References: <1218988252-17932-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.text+0x27032): Section mismatch in reference from the function get_tce_space_from_tar() to the function .init.text:calgary_bus_has_devices()
The function get_tce_space_from_tar() references
the function __init calgary_bus_has_devices().
This is often because get_tce_space_from_tar lacks a __init
annotation or the annotation of calgary_bus_has_devices is wrong.

get_tce_space_from_tar is called only from __init function (calgary_init)
and calls __init function (calgary_bus_has_devices).
So annotate it properly.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Chandru Siddalingappa <chandru@in.ibm.com>
---
 arch/x86/kernel/pci-calgary_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 02d1932..218d783 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1350,7 +1350,7 @@ static void calgary_init_bitmap_from_tce_table(struct iommu_table *tbl)
  * Function for kdump case. Get the tce tables from first kernel
  * by reading the contents of the base adress register of calgary iommu
  */
-static void get_tce_space_from_tar(void)
+static void __init get_tce_space_from_tar(void)
 {
 	int bus;
 	void __iomem *target;
-- 
1.5.4.5

