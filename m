Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbYHSJnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbYHSJnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbYHSJnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:43:35 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:49832 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751482AbYHSJne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:43:34 -0400
Date: Tue, 19 Aug 2008 11:43:32 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: linux-input@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/input/evdev.c: Fix printf() format for sizeof
Message-ID: <Pine.LNX.4.64.0808191137160.1565@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1223092856-1219139012=:1565"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1223092856-1219139012=:1565
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

commit f2afa7711f8585ffc088ba538b9a510e0d5dca12 ("Input: paper over a bug in
Synaptics X driver") introduced a compiler warning on 64-bit platforms, as
sizeof() returns a size_t, not an (unsigned) int:

| drivers/input/evdev.c: In function 'handle_eviocgbit':
| drivers/input/evdev.c:684: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'

Use the proper `z' modifier for size_t, and make the printf() formats for the
sizes unsigned while we're at it.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index a92d815..3524bef 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -677,8 +677,8 @@ static int handle_eviocgbit(struct input_dev *dev, unsigned int cmd, void __user
 		len = OLD_KEY_MAX;
 		if (printk_timed_ratelimit(&keymax_warn_time, 10 * 1000))
 			printk(KERN_WARNING
-				"evdev.c(EVIOCGBIT): Suspicious buffer size %d, "
-				"limiting output to %d bytes. See "
+				"evdev.c(EVIOCGBIT): Suspicious buffer size %u, "
+				"limiting output to %zu bytes. See "
 				"http://userweb.kernel.org/~dtor/eviocgbit-bug.html\n",
 				OLD_KEY_MAX,
 				BITS_TO_LONGS(OLD_KEY_MAX) * sizeof(long));

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
Fortis 293-0376800-10 GEBA-BE-BB
---584349381-1223092856-1219139012=:1565--
