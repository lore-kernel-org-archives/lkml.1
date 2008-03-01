Return-Path: <linux-kernel-owner+w=401wt.eu-S1762327AbYCAJDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762327AbYCAJDW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757221AbYCAI72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 03:59:28 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:64814 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635AbYCAI7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:59:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=wcB3WBPxXTEcuYDKDWn0U8nA8AQP4EbPZE8p4gvOH+GB8RT1QFuDy1w/AX49S/mfaGOIREQzgned9OS8gnUKmOWTPaJhn/0Pn+ReR/KFKm65uVQyuvcB4ecLJQkQ28qBGVg9IIqvGApcggT0t1IkS4rPJo006Jk+z/xmmBvBvbQ=
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 11/24] ide-tape: remove pipeline-specific code from idetape_blkdev_ioctl
Date: Sat,  1 Mar 2008 09:58:35 +0100
Message-Id: <1204361928-30229-12-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, strip struct idetape_config down to a single int due to unused/removed
members.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 447b7b4..0ebb745 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2384,26 +2384,19 @@ static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd,
 {
 	idetape_tape_t *tape = drive->driver_data;
 	void __user *argp = (void __user *)arg;
-
-	struct idetape_config {
-		int dsc_rw_frequency;
-		int dsc_media_access_frequency;
-		int nr_stages;
-	} config;
+	int dsc_rw_frequency;
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	switch (cmd) {
 	case 0x0340:
-		if (copy_from_user(&config, argp, sizeof(config)))
+		if (copy_from_user(&dsc_rw_frequency, argp, sizeof(int)))
 			return -EFAULT;
-		tape->best_dsc_rw_freq = config.dsc_rw_frequency;
-		tape->max_stages = config.nr_stages;
+		tape->best_dsc_rw_freq = dsc_rw_frequency;
 		break;
 	case 0x0350:
-		config.dsc_rw_frequency = (int) tape->best_dsc_rw_freq;
-		config.nr_stages = tape->max_stages;
-		if (copy_to_user(argp, &config, sizeof(config)))
+		dsc_rw_frequency = (int) tape->best_dsc_rw_freq;
+		if (copy_to_user(argp, &dsc_rw_frequency, sizeof(int)))
 			return -EFAULT;
 		break;
 	default:
-- 
1.5.4.1

