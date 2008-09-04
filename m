Return-Path: <linux-kernel-owner+w=401wt.eu-S1759706AbYIDUb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759706AbYIDUb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757420AbYIDU1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:27:12 -0400
Received: from mail.work.de ([212.12.32.20]:42149 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757061AbYIDU1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:27:10 -0400
Message-ID: <48C0449A.4000306@gmail.com>
Date: Fri, 05 Sep 2008 00:27:06 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
Subject: DVB Update [PATCH 25/31] enable gate in a symmetric way
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------020705070408000000010702"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020705070408000000010702
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 14e80f303046a7750a6cfb2210bd8fe561f21a3a Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:36:16 +0200
Subject: [PATCH] DVB Optimization: enable gate in a
symmetric/disciplined way,
 rather than implementing different ways leading to confusion.

This allows multiple gate_enable/disable's in the tuner read/write
functions, thereby lesser number of I/O operations throughout,
eventually leading to better results. As a side effect for the demods
that detect the STOP bit for auto closing, the auto closing of the
gate can be avoided, thereby a minimal gain in disabling the auto detect
feature as well. Improves readability on the device control.

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 dvb_frontend.c |    2 ++
 1 file changed, 2 insertions(+)


--------------020705070408000000010702
Content-Type: text/x-patch;
 name="25.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="25.patch"

>From 14e80f303046a7750a6cfb2210bd8fe561f21a3a Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:36:16 +0200
Subject: [PATCH] DVB Optimization: enable gate in a symmetric/disciplined way,
 rather than implementing different ways leading to confusion.

This allows multiple gate_enable/disable's in the tuner read/write
functions, thereby lesser number of I/O operations throughout,
eventually leading to better results. As a side effect for the demods
that detect the STOP bit for auto closing, the auto closing of the
gate can be avoided, thereby a minimal gain in disabling the auto detect
feature as well. Improves readability on the device control.

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index c54b12c..e2d929e 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -733,6 +733,8 @@ static void dvb_frontend_init(struct dvb_frontend *fe)
 	if (fe->ops.init)
 		fe->ops.init(fe);
 	if (fe->ops.tuner_ops.init) {
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 1);
 		fe->ops.tuner_ops.init(fe);
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);


--------------020705070408000000010702--
