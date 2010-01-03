Return-Path: <linux-kernel-owner+w=401wt.eu-S1752926Ab0ACQyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab0ACQyB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 11:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269Ab0ACQyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 11:54:00 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:15665 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab0ACQx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 11:53:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=R/IxuF5qkAgD6rgGSri2U1hksTZyFnyfAdcM4lMCs0JZtirSOc25bZ4ADUZBlVl08Q
         NhI7wOjv5ykX44rntlJ0aBGz8jo/EwDrjPaa3nv0QHGP9+Au4uJCvZh4DIblla63g3na
         W0RoxyoIm28/sASb6dx69hIWGf2OHE+6FKx3k=
Message-ID: <4B40CC74.1060508@gmail.com>
Date: Sun, 03 Jan 2010 17:57:24 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Bluetooth: Wrong variable tested
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return of the function sdio_readb() was not tested.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/bluetooth/btmrvl_sdio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index f36defa..cac5b5e 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -348,7 +348,7 @@ static int btmrvl_sdio_download_fw_w_helper(struct btmrvl_sdio_card *card)
 		for (tries = 0; tries < MAX_POLL_TRIES; tries++) {
 			base0 = sdio_readb(card->func,
 					SQ_READ_BASE_ADDRESS_A0_REG, &ret);
-			if (ret) {
+			if (base0) {
 				BT_ERR("BASE0 register read failed:"
 					" base0 = 0x%04X(%d)."
 					" Terminating download",
@@ -358,7 +358,7 @@ static int btmrvl_sdio_download_fw_w_helper(struct btmrvl_sdio_card *card)
 			}
 			base1 = sdio_readb(card->func,
 					SQ_READ_BASE_ADDRESS_A1_REG, &ret);
-			if (ret) {
+			if (base1) {
 				BT_ERR("BASE1 register read failed:"
 					" base1 = 0x%04X(%d)."
 					" Terminating download",
