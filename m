Return-Path: <linux-kernel-owner+w=401wt.eu-S1761356AbYB1A5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761356AbYB1A5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbYB1A4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:56:14 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:50062 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbYB1A4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:56:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wXANC9teP1uE3vk8Ri/Io1z5XxpdfQsjnBT/OmzT6TzHyiNP8/aGIZWhhcE+s9RxPBuvo/BZGAW4EKOQkFinKnC9AkfqTFAENgyzTcJPE54ViimUPTzSb5LMJXas4/HaWLcpNROYdZWD9HfNpfgkHRQy2C2H6kZ4cWBbCmY1DVs=
Subject: [PATCH 04/12] sound: fm801.c fix shadowed variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 16:56:05 -0800
Message-Id: <1204160165.20280.52.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

id was only used as a counter in a for loop, move the declaration
to where it is used and change it to i.
sound/pci/fm801.c:1288:6: warning: symbol 'id' shadows an earlier one
sound/pci/fm801.c:51:13: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/fm801.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/pci/fm801.c b/sound/pci/fm801.c
index 4c300e6..9fb74a6 100644
--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -1285,7 +1285,6 @@ static int wait_for_codec(struct fm801 *chip, unsigned int codec_id,
 
 static int snd_fm801_chip_init(struct fm801 *chip, int resume)
 {
-	int id;
 	unsigned short cmdw;
 
 	if (chip->tea575x_tuner & 0x0010)
@@ -1310,13 +1309,14 @@ static int snd_fm801_chip_init(struct fm801 *chip, int resume)
 		} else {
 			/* my card has the secondary codec */
 			/* at address #3, so the loop is inverted */
-			for (id = 3; id > 0; id--) {
-				if (! wait_for_codec(chip, id, AC97_VENDOR_ID1,
+			int i;
+			for (i = 3; i > 0; i--) {
+				if (! wait_for_codec(chip, i, AC97_VENDOR_ID1,
 						     msecs_to_jiffies(50))) {
 					cmdw = inw(FM801_REG(chip, AC97_DATA));
 					if (cmdw != 0xffff && cmdw != 0) {
 						chip->secondary = 1;
-						chip->secondary_addr = id;
+						chip->secondary_addr = i;
 						break;
 					}
 				}
-- 
1.5.4.3.342.g99e8


