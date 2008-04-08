Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYDHLYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYDHLYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbYDHLTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:30 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:42087 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbYDHLT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:26 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 21/29] parisc: use non-racy method for /proc/pcxl_dma creation
Date: Tue,  8 Apr 2008 15:19:28 +0400
Message-Id: <1207653576-12640-21-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create() to make sure that ->proc_fops be setup before gluing PDE
to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: Kyle McMartin <kyle@parisc-linux.org>
CC: Matthew Wilcox <matthew@wil.cx>
CC: Grant Grundler <grundler@parisc-linux.org>
CC: linux-parisc@vger.kernel.org
---
 arch/parisc/kernel/pci-dma.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/parisc/kernel/pci-dma.c b/arch/parisc/kernel/pci-dma.c
index 9448d4e..ccd61b9 100644
--- a/arch/parisc/kernel/pci-dma.c
+++ b/arch/parisc/kernel/pci-dma.c
@@ -397,10 +397,9 @@ pcxl_dma_init(void)
 			"pcxl_dma_init: Unable to create gsc /proc dir entry\n");
 	else {
 		struct proc_dir_entry* ent;
-		ent = create_proc_entry("pcxl_dma", 0, proc_gsc_root);
-		if (ent)
-			ent->proc_fops = &proc_pcxl_dma_ops;
-		else
+		ent = proc_create("pcxl_dma", 0, proc_gsc_root,
+				  &proc_pcxl_dma_ops);
+		if (!ent)
 			printk(KERN_WARNING
 				"pci-dma.c: Unable to create pcxl_dma /proc entry.\n");
 	}
-- 
1.5.3.rc5

