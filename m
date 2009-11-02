Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbZKBQw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbZKBQw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:52:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbZKBQw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:52:27 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:48008 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755937AbZKBQw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:52:26 -0500
Subject: tps65010: Allow the board to choose any GPIO base.
Message-Id: <20091102165220.310450538@fluff.org.uk>
User-Agent: quilt/0.46-1
From: Ben Dooks <ben@simtec.co.uk>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
       dbrownell@users.sourceforge.net
Cc: Simtec Liunx Team <linux@simtec.co.uk>
Content-Disposition: inline; filename=tps65010-allow-any-gpio.patch
Date: Mon, 02 Nov 2009 16:52:20 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the board does not care where the TPS turns up, then specifiying the
value -1 to get gpiolib to dynamically allocate the base for the chip
is valid.

Change the test to look for != 0, so that any boards specifying zero
will not end up with gpio that they didn't want.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Signed-off-by: Simtec Liunx Team <linux@simtec.co.uk>

---
 drivers/mfd/tps65010.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/mfd/tps65010.c
===================================================================
--- a/drivers/mfd/tps65010.c	2009-10-21 19:09:28.000000000 +0100
+++ b/drivers/mfd/tps65010.c	2009-10-21 19:09:39.000000000 +0100
@@ -637,7 +637,7 @@ static int tps65010_probe(struct i2c_cli
 				tps, DEBUG_FOPS);
 
 	/* optionally register GPIOs */
-	if (board && board->base > 0) {
+	if (board && board->base != 0) {
 		tps->outmask = board->outmask;
 
 		tps->chip.label = client->name;

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
