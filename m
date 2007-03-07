Return-Path: <linux-kernel-owner+w=401wt.eu-S1422831AbXCGRlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422831AbXCGRlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965589AbXCGRlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:41:04 -0500
Received: from cantor.suse.de ([195.135.220.2]:43905 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422823AbXCGRPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:15:39 -0500
Message-Id: <20070307171401.616499755@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 050/101] DVB: digitv: open nxt6000 i2c_gate for TDED4 tuner handling
Content-Disposition: inline; filename=dvb-digitv-open-nxt6000-i2c_gate-for-tded4-tuner-handling.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Krufky <mkrufky@linuxtv.org>

dvb-pll normally opens the i2c gate before attempting to communicate with
the pll, but the code for this device is not using dvb-pll.  This should
be cleaned up in the future, but for now, just open the i2c gate at the
appropriate place in order to fix this driver bug.

(cherry picked from commit 2fe22dcdc79b8dd34e61a3f1231caffd6180a626)

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/dvb-usb/digitv.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.20.1.orig/drivers/media/dvb/dvb-usb/digitv.c
+++ linux-2.6.20.1/drivers/media/dvb/dvb-usb/digitv.c
@@ -119,6 +119,8 @@ static int digitv_nxt6000_tuner_set_para
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
 	u8 b[5];
 	dvb_usb_tuner_calc_regs(fe,fep,b, 5);
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
 	return digitv_ctrl_msg(adap->dev, USB_WRITE_TUNER, 0, &b[1], 4, NULL, 0);
 }
 

--
