Return-Path: <linux-kernel-owner+w=401wt.eu-S1758305AbYDPCGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305AbYDPCGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 22:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbYDPCGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 22:06:22 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:33407 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbYDPCGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 22:06:21 -0400
Message-ID: <48055F1A.9020706@tiscali.nl>
Date: Wed, 16 Apr 2008 04:06:18 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: bzolnier@gmail.com
CC: linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] IDE: ide-cd: fix test unsigned var < 0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this the right fix in this case?
---
valid is unsigned and cannot be below 0.,
    
Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index c8d0e87..a60f5df 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -182,8 +182,6 @@ void cdrom_analyze_sense_data(ide_drive_t *drive,
 			sector &= ~(bio_sectors -1);
 			valid = (sector - failed_command->sector) << 9;
 
-			if (valid < 0)
-				valid = 0;
 			if (sector < get_capacity(info->disk) &&
 				drive->probed_capacity - sector < 4 * 75) {
 				set_capacity(info->disk, sector);

