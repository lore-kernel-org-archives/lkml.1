Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbXLKW1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbXLKW1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbXLKWXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:23:54 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38550 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757306AbXLKWXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:23:53 -0500
Date: Tue, 11 Dec 2007 23:23:53 +0100
From: Adrian Bunk <bunk@kernel.org>
To: matthew@wil.cx, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/scsi/advansys.c section fix
Message-ID: <20071211222353.GZ14204@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch with CONFIG_HOTPLUG=n:

<--  snip  -->

...
WARNING: vmlinux.o(.exit.text+0xcf8a): Section mismatch: reference to .init.data:_asc_def_iop_base (between 'advansys_isa_remove' and 'exit_this_scsi_driver')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
e81cac11f9efe882a89708c298fa6268375b0221 
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 9dd3952..38a1ee2 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -13906,7 +13906,7 @@ static int advansys_release(struct Scsi_Host *shost)
 
 #define ASC_IOADR_TABLE_MAX_IX  11
 
-static PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] __devinitdata = {
+static PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] = {
 	0x100, 0x0110, 0x120, 0x0130, 0x140, 0x0150, 0x0190,
 	0x0210, 0x0230, 0x0250, 0x0330
 };

