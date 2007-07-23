Return-Path: <linux-kernel-owner+w=401wt.eu-S1761914AbXGWICs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761914AbXGWICs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761995AbXGWIBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:01:37 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41699 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761914AbXGWIBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:01:35 -0400
Date: Mon, 23 Jul 2007 10:01:01 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Luca Olivetti <luca@ventoso.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] dvb-usb/af9005-fe.c: error check fixes
Message-ID: <20070723080101.GB26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch:
- adds a missing error check and
- removes an error check that could never be true

Both spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/media/dvb/dvb-usb/af9005-fe.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- linux-2.6.22-rc6-mm1/drivers/media/dvb/dvb-usb/af9005-fe.c.old	2007-07-23 01:13:37.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/media/dvb/dvb-usb/af9005-fe.c	2007-07-23 01:20:58.000000000 +0200
@@ -345,8 +345,8 @@ static int af9005_reset_pre_viterbi(stru
 				       1 & 0xff);
 	if (ret)
 		return ret;
-	af9005_write_ofdm_register(state->d, xd_p_fec_super_frm_unit_15_8,
-				   1 >> 8);
+	ret = af9005_write_ofdm_register(state->d, xd_p_fec_super_frm_unit_15_8,
+					 1 >> 8);
 	if (ret)
 		return ret;
 	/* reset pre viterbi error count */
@@ -881,10 +881,8 @@ static int af9005_fe_init(struct dvb_fro
 	     af9005_write_register_bits(state->d, xd_I2C_reg_ofdm_rst,
 					reg_ofdm_rst_pos, reg_ofdm_rst_len, 1)))
 		return ret;
-	if ((ret =
-	     af9005_write_register_bits(state->d, xd_I2C_reg_ofdm_rst,
-					reg_ofdm_rst_pos, reg_ofdm_rst_len, 0)))
-		return ret;
+	ret = af9005_write_register_bits(state->d, xd_I2C_reg_ofdm_rst,
+					 reg_ofdm_rst_pos, reg_ofdm_rst_len, 0);
 
 	if (ret)
 		return ret;

