Return-Path: <linux-kernel-owner+w=401wt.eu-S1031082AbXDQEb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031082AbXDQEb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 00:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031083AbXDQEb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 00:31:58 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:60290 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031082AbXDQEb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 00:31:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:to:cc:subject:date:x-mailer:from:message-id;
        b=tXKGux2KSQNIHIYFUrMTv9xdR/XEPh0RT5ArK3o5NPQ4BHZ5bg8UdQasnw09ohdPcKMIYr6OAb3n8+Y5Rk5H6Q4yw5gYNOjNAJgq2K2SyZLhjTAmN9Ij5ZiTSr/ZPklTxPTeh3EqQSy5k4AH2Kbzka4U4eMtRwEw0i7q/T9vtLY=
To: perex@suse.cz, linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Cc: Abhijit Bhopatkar <bainonline@gmail.com>
Subject: [PATCH] [ALSA] Add first generation macbook subsystem ID
Date: Tue, 17 Apr 2007 10:01:47 +0530
X-Mailer: git-send-email 1.4.4.2
From: bainonline@gmail.com
Message-ID: <46244dbb.7672bd23.37b9.00c5@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijit Bhopatkar <bainonline@gmail.com>

First generation MacBooks were getting ignored by sigmatel drivers
and wrongly being identified as MACMINI. This patch makes them
identify as MACBOOK.

Signed-off-by: Abhijit Bhopatkar <bainonline@gmail.com>
---
 sound/pci/hda/patch_sigmatel.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index c94291b..cb99df5 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1905,6 +1905,9 @@ static int patch_stac922x(struct hda_codec *codec)
 		 */
 		printk(KERN_INFO "hda_codec: STAC922x, Apple subsys_id=%x\n", codec->subsystem_id);
 		switch (codec->subsystem_id) {
+		case 0x106b0a00: /* MacBook First generatoin */
+			spec->board_config = STAC_MACBOOK;
+			break;
 		case 0x106b0200: /* MacBook Pro first generation */
 			spec->board_config = STAC_MACBOOK_PRO_V1;
 			break;
-- 
1.4.4.2

