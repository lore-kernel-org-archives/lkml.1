Return-Path: <linux-kernel-owner+w=401wt.eu-S1760097AbYHNTK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760097AbYHNTK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 15:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbYHNTKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 15:10:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbYHNTKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 15:10:49 -0400
Date: Thu, 14 Aug 2008 15:07:03 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org
Subject: silence mmconfig printk.
Message-ID: <20080814190703.GA16862@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's so much broken mmconfig hardware/bios'es out there,
that classing this as an error seems a little extreme.
Lower its priority to KERN_INFO so that it isn't so noisy
when booting with 'quiet'

Signed-off-by: Dave Jones <davej@redhat.com>

diff -up linux-2.6.26.noarch/arch/x86/pci/mmconfig-shared.c.jx linux-2.6.26.noarch/arch/x86/pci/mmconfig-shared.c
--- linux-2.6.26.noarch/arch/x86/pci/mmconfig-shared.c.jx	2008-08-12 14:03:38.000000000 -0400
+++ linux-2.6.26.noarch/arch/x86/pci/mmconfig-shared.c	2008-08-12 14:09:43.000000000 -0400
@@ -365,7 +365,7 @@ static void __init pci_mmcfg_reject_brok
 	return;
 
 reject:
-	printk(KERN_ERR "PCI: Not using MMCONFIG.\n");
+	printk(KERN_INFO "PCI: Not using MMCONFIG.\n");
 	pci_mmcfg_arch_free();
 	kfree(pci_mmcfg_config);
 	pci_mmcfg_config = NULL;

-- 
http://www.codemonkey.org.uk
