Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbZKENqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbZKENqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 08:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbZKENqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 08:46:47 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:51222 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbZKENqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 08:46:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OhApVekJLedhA/p75TTF7ax9NhAjcY8ESz9SvzJ2rpu6J0/3aDghA9CWsA2vqNjo7q
         kzobFddVIg2ZHFrYxm9wDSpLPh+nPY0cCi8LnjV1mvPq84lZ7SQXxYRl0BkE4Qq8GJG9
         RtRHJh0KMb45hkyjkp7YS++IX8cygOzbW0XUg=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thiago Farina <tfransosi@gmail.com>
Subject: [PATCH] drivers/serial: remove BAUD_TABLE_SIZE macro.
Date: Thu,  5 Nov 2009 08:46:34 -0500
Message-Id: <1257428794-9203-1-git-send-email-tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.5.2.150.g1b52a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro is a duplicated of ARRAY_SIZE defined in kernel api,
so just use it instead.

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/serial/68328serial.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
index d935b2d..d761109 100644
--- a/drivers/serial/68328serial.c
+++ b/drivers/serial/68328serial.c
@@ -153,8 +153,6 @@ static int baud_table[] = {
 	0, 50, 75, 110, 134, 150, 200, 300, 600, 1200, 1800, 2400, 4800,
 	9600, 19200, 38400, 57600, 115200, 0 };
 
-#define BAUD_TABLE_SIZE (sizeof(baud_table)/sizeof(baud_table[0]))
-
 /* Sets or clears DTR/RTS on the requested line */
 static inline void m68k_rtsdtr(struct m68k_serial *ss, int set)
 {
@@ -1406,15 +1404,15 @@ static void m68328_set_baud(void)
 	USTCNT = ustcnt & ~USTCNT_TXEN;
 
 again:
-	for (i = 0; i < sizeof(baud_table) / sizeof(baud_table[0]); i++)
+	for (i = 0; i < ARRAY_SIZE(baud_table); i++)
 		if (baud_table[i] == m68328_console_baud)
 			break;
-	if (i >= sizeof(baud_table) / sizeof(baud_table[0])) {
+	if (i >= ARRAY_SIZE(baud_table)) {
 		m68328_console_baud = 9600;
 		goto again;
 	}
 
-	UBAUD = PUT_FIELD(UBAUD_DIVIDE,    hw_baud_table[i].divisor) | 
+	UBAUD = PUT_FIELD(UBAUD_DIVIDE,    hw_baud_table[i].divisor) |
 		PUT_FIELD(UBAUD_PRESCALER, hw_baud_table[i].prescale);
 	ustcnt &= ~(USTCNT_PARITYEN | USTCNT_ODD_EVEN | USTCNT_STOP | USTCNT_8_7);
 	ustcnt |= USTCNT_8_7;
@@ -1435,7 +1433,7 @@ int m68328_console_setup(struct console *cp, char *arg)
 	if (arg)
 		n = simple_strtoul(arg,NULL,0);
 
-	for (i = 0; i < BAUD_TABLE_SIZE; i++)
+	for (i = 0; i < ARRAY_SIZE(baud_table); i++)
 		if (baud_table[i] == n)
 			break;
 	if (i < BAUD_TABLE_SIZE) {
-- 
1.6.5.1.61.ge79999

