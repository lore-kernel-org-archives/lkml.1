Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbYJNOnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbYJNOnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 10:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYJNOmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 10:42:53 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:41995 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751261AbYJNOmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 10:42:53 -0400
Date: Tue, 14 Oct 2008 16:42:48 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Steven Toth <stoth@linuxtv.org>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>, video4linux-list@redhat.com,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] dvb: Input data pointer of cx24116_writeregN() should be
 const
Message-ID: <Pine.LNX.4.64.0810141640380.19843@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1705537250-1223995368=:19843"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1705537250-1223995368=:19843
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

| drivers/media/dvb/frontends/cx24116.c:573: warning: passing argument 3 of 'cx24116_writeregN' discards qualifiers from pointer target type

Make the `data' input pointer parameter of cx24116_writeregN() const to kill
the warning.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

diff --git a/drivers/media/dvb/frontends/cx24116.c b/drivers/media/dvb/frontends/cx24116.c
index deb36f4..aff88b9 100644
--- a/drivers/media/dvb/frontends/cx24116.c
+++ b/drivers/media/dvb/frontends/cx24116.c
@@ -200,7 +200,8 @@ static int cx24116_writereg(struct cx24116_state* state, int reg, int data)
 }
 
 /* Bulk byte writes to a single I2C address, for 32k firmware load */
-static int cx24116_writeregN(struct cx24116_state* state, int reg, u8 *data, u16 len)
+static int cx24116_writeregN(struct cx24116_state* state, int reg,
+			     const u8 *data, u16 len)
 {
 	int ret = -EREMOTEIO;
 	struct i2c_msg msg;

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-1705537250-1223995368=:19843--
