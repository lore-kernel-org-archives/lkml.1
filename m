Return-Path: <linux-kernel-owner+w=401wt.eu-S1760724AbYCGJqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724AbYCGJqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:46:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYCGJpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:45:47 -0500
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:18790 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753063AbYCGJpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:45:46 -0500
Date: Fri, 07 Mar 2008 18:45:38 +0900 (JST)
Message-Id: <20080307.184538.00937695.nemoto@toshiba-tops.co.jp>
To: linux-kernel@vger.kernel.org
Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <avictor.za@gmail.com>
Subject: [PATCH] at73c213: Fix error checking for clk API.
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clk_round_rate() and clk_set_rate() will return int, so not store
thier return value to unsigned long variable.  This bug hides real
error on these API.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/sound/spi/at73c213.c b/sound/spi/at73c213.c
index 89d6e9c..d130552 100644
--- a/sound/spi/at73c213.c
+++ b/sound/spi/at73c213.c
@@ -133,7 +133,8 @@ static struct snd_pcm_hardware snd_at73c213_playback_hw = {
 static int snd_at73c213_set_bitrate(struct snd_at73c213 *chip)
 {
 	unsigned long ssc_rate = clk_get_rate(chip->ssc->clk);
-	unsigned long dac_rate_new, ssc_div, status;
+	unsigned long dac_rate_new, ssc_div;
+	int status;
 	unsigned long ssc_div_max, ssc_div_min;
 	int max_tries;
 
