Return-Path: <linux-kernel-owner+w=401wt.eu-S1763727AbYA1WTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763727AbYA1WTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762644AbYA1WMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:12:17 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:52353 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762641AbYA1WMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:12:15 -0500
Date: Tue, 29 Jan 2008 00:12:41 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Michael Krufky <mkrufky@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] dvb/frontends/tda18271-common.c: fix off-by-one
Message-ID: <20080128221241.GG8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an off-by-one error spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- linux-2.6/drivers/media/dvb/frontends/tda18271-common.c.old	2008-01-28 16:27:55.000000000 +0200
+++ linux-2.6/drivers/media/dvb/frontends/tda18271-common.c	2008-01-28 16:28:38.000000000 +0200
@@ -166,17 +166,17 @@ int tda18271_read_extended(struct dvb_fr
 	/* read all registers */
 	ret = i2c_transfer(priv->i2c_adap, msg, 2);
 
 	tda18271_i2c_gate_ctrl(fe, 0);
 
 	if (ret != 2)
 		tda_err("ERROR: i2c_transfer returned: %d\n", ret);
 
-	for (i = 0; i <= TDA18271_NUM_REGS; i++) {
+	for (i = 0; i < TDA18271_NUM_REGS; i++) {
 		/* don't update write-only registers */
 		if ((i != R_EB9)  &&
 		    (i != R_EB16) &&
 		    (i != R_EB17) &&
 		    (i != R_EB19) &&
 		    (i != R_EB20))
 		regs[i] = regdump[i];
 	}

