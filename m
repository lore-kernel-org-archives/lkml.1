Return-Path: <linux-kernel-owner+w=401wt.eu-S965373AbXCAQor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965373AbXCAQor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 11:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965369AbXCAQor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 11:44:47 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34879 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965366AbXCAQoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 11:44:46 -0500
Date: Thu, 1 Mar 2007 17:48:52 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com
Subject: [PATCH] pata_legacy: Fix missing methods and add cable types
Message-ID: <20070301174852.6bd60580@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Several method sets lacked freeze/resume methods. Fix this and while we
are at it force the cable to 40wire

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/pata_legacy.c linux-2.6.21-rc2/drivers/ata/pata_legacy.c
--- linux.vanilla-2.6.21-rc2/drivers/ata/pata_legacy.c	2007-03-01 13:36:03.000000000 +0000
+++ linux-2.6.21-rc2/drivers/ata/pata_legacy.c	2007-03-01 14:57:59.101098472 +0000
@@ -162,6 +162,7 @@
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
@@ -186,7 +187,11 @@
 	.exec_command	= ata_exec_command,
 	.dev_select 	= ata_std_dev_select,
 
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
@@ -298,7 +303,11 @@
 	.exec_command	= ata_exec_command,
 	.dev_select 	= ata_std_dev_select,
 
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
@@ -350,7 +359,11 @@
 	.exec_command	= ata_exec_command,
 	.dev_select 	= ata_std_dev_select,
 
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
@@ -413,7 +426,11 @@
 	.exec_command	= ata_exec_command,
 	.dev_select 	= ata_std_dev_select,
 
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
@@ -531,7 +548,11 @@
 	.exec_command	= ata_exec_command,
 	.dev_select 	= ata_std_dev_select,
 
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
@@ -661,7 +682,11 @@
 	.exec_command	= ata_exec_command,
 	.dev_select 	= ata_std_dev_select,
 
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= opti82c46x_qc_issue_prot,
