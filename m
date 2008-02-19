Return-Path: <linux-kernel-owner+w=401wt.eu-S1760301AbYBST0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301AbYBST0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756269AbYBST0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:26:31 -0500
Received: from qb-out-0506.google.com ([72.14.204.229]:56994 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026AbYBST0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:26:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=B7k9paIuBtCixtMtNZy0XHF09EEYBRgZC9k99VwctZ6YaloIx6r/Zu8gfl/9jwlmxWCN33jlIonw2wp2zIWUITK/wYaK+ZK7m7K+2Ms+rl5LK99OHff17dlD4mUMwUpPIFRncT68qF82UCDlXr2sxPOj3L9ap8bjHCwOrGagf6o=
Subject: [PATCH] ata: simplify clock divisor logic in pata_amd.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 11:26:36 -0800
Message-Id: <1203449196.10464.19.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code is essentially choosing between dividing by 1 or
dividing by two, make the conditions a little more obvious.

As a bonus, removes a sparse error:
drivers/ata/pata_amd.c:59:11: warning: symbol '__x' shadows an earlier one
drivers/ata/pata_amd.c:59:11: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Andrew, this is a replacement for:
pata_amd-replace-macro-with-static-inline-in-libatah.patch

It is the same patch, but with a corrected description.

 drivers/ata/pata_amd.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 4b8d9b5..7ef4847 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -56,7 +56,9 @@ static void timing_setup(struct ata_port *ap, struct ata_device *adev, int offse
 	u8 t;
 
 	T = 1000000000 / amd_clock;
-	UT = T / min_t(int, max_t(int, clock, 1), 2);
+	UT = T;
+	if (clock >= 2)
+		UT = T / 2;
 
 	if (ata_timing_compute(adev, speed, &at, T, UT) < 0) {
 		dev_printk(KERN_ERR, &pdev->dev, "unknown mode %d.\n", speed);
-- 
1.5.4.1.1278.gc75be



