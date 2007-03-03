Return-Path: <linux-kernel-owner+w=401wt.eu-S1030308AbXCCOhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030308AbXCCOhe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 09:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030291AbXCCOhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 09:37:34 -0500
Received: from thing.hostingexpert.com ([67.15.235.34]:47375 "EHLO
	thing.hostingexpert.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030295AbXCCOhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 09:37:08 -0500
Message-ID: <45E987D9.9000808@linuxtv.org>
Date: Sat, 03 Mar 2007 09:36:09 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: stable@kernel.org
CC: v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [2.6.20.y PATCH 5/7] DVB: digitv: open nxt6000 i2c_gate for TDED4
 tuner handling
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - thing.hostingexpert.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - linuxtv.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Krufky <mkrufky@linuxtv.org>
Date: Wed, 21 Feb 2007 21:47:15 -0300
Subject: [PATCH] DVB: digitv: open nxt6000 i2c_gate for TDED4 tuner handling

dvb-pll normally opens the i2c gate before attempting to communicate with
the pll, but the code for this device is not using dvb-pll.  This should
be cleaned up in the future, but for now, just open the i2c gate at the
appropriate place in order to fix this driver bug.

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
(cherry picked from commit 2fe22dcdc79b8dd34e61a3f1231caffd6180a626)
---
 drivers/media/dvb/dvb-usb/digitv.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/digitv.c b/drivers/media/dvb/dvb-usb/digitv.c
index 4a198d4..b5acb11 100644
--- a/drivers/media/dvb/dvb-usb/digitv.c
+++ b/drivers/media/dvb/dvb-usb/digitv.c
@@ -119,6 +119,8 @@ static int digitv_nxt6000_tuner_set_params(struct dvb_frontend *fe, struct dvb_f
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
 	u8 b[5];
 	dvb_usb_tuner_calc_regs(fe,fep,b, 5);
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
 	return digitv_ctrl_msg(adap->dev, USB_WRITE_TUNER, 0, &b[1], 4, NULL, 0);
 }
 
