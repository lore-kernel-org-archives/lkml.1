Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbZCIUoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbZCIUoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 16:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbZCIUoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 16:44:04 -0400
Received: from smtp.tal.de ([81.92.1.5]:52224 "EHLO smtp.tal.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbZCIUoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 16:44:03 -0400
X-Greylist: delayed 2522 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Mar 2009 16:44:03 EDT
From: ib@wupperonline.de (Ingo Brueckl)
Date: Mon, 09 Mar 2009 20:06:00 +0100
Subject: [PATCH] unnecessary SCSI module
X-Mailer: blueMail 1.4 (SlipDoor 2.2)
Message-ID: <49b5689f@wupperonline.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When configuring MODULES with the kernel to be able to load external drivers
coming as modules, but not using anything as module in the kernel itself, one
would expect to end up in a module-free kernel. Currently, you don't if you
use SCSI. You'll get one unnecessary module.

Please consider the attached patch.

Signed-off-by: Ingo Brueckl <ib@wupperonline.de>

--- linux-2.6.28/drivers/scsi/Kconfig.orig	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28/drivers/scsi/Kconfig	2009-03-06 22:49:40.000000000 +0100
@@ -259,7 +259,7 @@ config SCSI_SCAN_ASYNC
 config SCSI_WAIT_SCAN
 	tristate
 	default m
-	depends on SCSI
+	depends on SCSI = m || SCSI_SCAN_ASYNC = y
 	depends on MODULES

 menu "SCSI Transports"
