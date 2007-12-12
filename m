Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbXLLSWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbXLLSWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbXLLSWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:22:09 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:2864 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbXLLSWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:22:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:from;
        b=ON5cNLZx0n6cmIQfqdGkJur//e9CwkHocW9CtHzAXwfRv4U+Hcra/HC121DAFzSaWfi/F4L8R2rcSB/PJiWPitwn93CW9a0X9bma769cpldfmj/8DRd5Nc54W0OMB4p2u10j3xRppx06mVlhOPOEiy23OC/NRTu+/n9yXWXUDno=
Date: Wed, 12 Dec 2007 19:22:07 +0100
To: Dmitry <dmitry.torokhov@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Cc: linux-input-list <linux-input@atrey.karlin.mff.cuni.cz>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: [HP6XX/FIX/PATCH] - Fix bad default keymap in HP Jornada 6xx
 keyboard driver
Message-Id: <20071212192207.196f18cc.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Wed__12_Dec_2007_19_22_07_+0100_lR6zEQYS_GBKPVM9"
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Wed__12_Dec_2007_19_22_07_+0100_lR6zEQYS_GBKPVM9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Greetings,

Dmitry, any chance of getting this into the RC since its really a bugfix?
Anyhow, compiled cleanly with patch applied.

shortlog:
* This patch fixes the HP Jornada 6xx keyboard default keymap which had some bad keymap values. This resulted in wrong
key being returned when pressed (example : key y returned 'r').
* Also, while we are at it lets arrange the include files in alphabetical order.

signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>

diff --git a/drivers/input/keyboard/jornada680_kbd.c b/drivers/input/keyboard/jornada680_kbd.c
index bec1cf4..a23633a 100644
--- a/drivers/input/keyboard/jornada680_kbd.c
+++ b/drivers/input/keyboard/jornada680_kbd.c
@@ -16,14 +16,14 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/input.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/init.h>
+#include <linux/input.h>
 #include <linux/input-polldev.h>
+#include <linux/interrupt.h>
 #include <linux/jiffies.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/interrupt.h>
 
 #include <asm/delay.h>
 #include <asm/io.h>
@@ -43,22 +43,22 @@
 #define PLDR 0xa4000134
 
 static const unsigned short jornada_scancodes[] = {
-/* PTD1 */	KEY_CAPSLOCK, KEY_MACRO, KEY_LEFTCTRL, 0, KEY_ESC, 0, 0, 0,	/*  1  -> 8   */
-		KEY_F1, KEY_F2, KEY_F3, KEY_F8, KEY_F7, KEY_F2, KEY_F4, KEY_F5,	/*  9  -> 16  */
-/* PTD5 */	KEY_SLASH, KEY_APOSTROPHE, KEY_ENTER, 0, KEY_Z, 0, 0, 0,	/*  17 -> 24  */
-		KEY_X, KEY_C, KEY_V, KEY_DOT, KEY_COMMA, KEY_M, KEY_B, KEY_N,	/*  25 -> 32  */
-/* PTD7 */	KEY_KP2, KEY_KP6, 0, 0, 0, 0, 0, 0,				/*  33 -> 40  */
-		0, 0, 0, KEY_KP4, 0, 0, KEY_LEFTALT, KEY_HANJA,			/*  41 -> 48  */
-/* PTE0 */	0, 0, 0, 0, KEY_FINANCE, 0, 0, 0,				/*  49 -> 56  */
-		KEY_LEFTCTRL, 0, KEY_SPACE, KEY_KPDOT, KEY_VOLUMEUP, 249, 0, 0, /*  57 -> 64  */
-/* PTE1 */	KEY_SEMICOLON, KEY_RIGHTBRACE, KEY_BACKSLASH, 0, KEY_A, 0, 0, 0,/*  65 -> 72  */
-		KEY_S, KEY_D, KEY_F, KEY_L, KEY_K, KEY_J, KEY_G, KEY_H,		/*  73 -> 80  */
-/* PTE3 */	KEY_KP8, KEY_LEFTMETA, KEY_RIGHTSHIFT, 0, KEY_TAB, 0, 0,0,	/*  81 -> 88  */
-		0, KEY_LEFTSHIFT, 0, 0, 0, 0, 0, 0,				/*  89 -> 96  */
-/* PTE6 */	KEY_P, KEY_LEFTBRACE, KEY_BACKSPACE, 0, KEY_Q, 0, 0, 0,		/*  97 -> 104 */
-		KEY_W, KEY_E, KEY_R, KEY_O, KEY_I, KEY_U, KEY_T, KEY_R,		/* 105 -> 112 */
-/* PTE7 */	KEY_0, KEY_MINUS, KEY_EQUAL, 0, KEY_1, 0, 0, 0,			/* 113 -> 120 */
-		KEY_2, KEY_3, KEY_4, KEY_9, KEY_8, KEY_7, KEY_5, KEY_6,		/* 121 -> 128 */
+/* PTD1 */	KEY_CAPSLOCK, KEY_MACRO, KEY_LEFTCTRL, 0, KEY_ESC, KEY_KP5, 0, 0,			/*  1  -> 8   */
+		KEY_F1, KEY_F2, KEY_F3, KEY_F8, KEY_F7, KEY_F6, KEY_F4, KEY_F5,				/*  9  -> 16  */
+/* PTD5 */	KEY_SLASH, KEY_APOSTROPHE, KEY_ENTER, 0, KEY_Z, 0, 0, 0,				/*  17 -> 24  */
+		KEY_X, KEY_C, KEY_V, KEY_DOT, KEY_COMMA, KEY_M, KEY_B, KEY_N,				/*  25 -> 32  */
+/* PTD7 */	KEY_KP2, KEY_KP6, KEY_KP3, 0, 0, 0, 0, 0,						/*  33 -> 40  */
+		KEY_F10, KEY_RO, KEY_F9, KEY_KP4, KEY_NUMLOCK, KEY_SCROLLLOCK, KEY_LEFTALT, KEY_HANJA,	/*  41 -> 48  */
+/* PTE0 */	KEY_KATAKANA, KEY_KP0, KEY_GRAVE, 0, KEY_FINANCE, 0, 0, 0,				/*  49 -> 56  */
+		KEY_KPMINUS, KEY_HIRAGANA, KEY_SPACE, KEY_KPDOT, KEY_VOLUMEUP, 249, 0, 0,		/*  57 -> 64  */
+/* PTE1 */	KEY_SEMICOLON, KEY_RIGHTBRACE, KEY_BACKSLASH, 0, KEY_A, 0, 0, 0,			/*  65 -> 72  */
+		KEY_S, KEY_D, KEY_F, KEY_L, KEY_K, KEY_J, KEY_G, KEY_H,					/*  73 -> 80  */
+/* PTE3 */	KEY_KP8, KEY_LEFTMETA, KEY_RIGHTSHIFT, 0, KEY_TAB, 0, 0, 0,				/*  81 -> 88  */
+		0, KEY_LEFTSHIFT, KEY_KP7, KEY_KP9, KEY_KP1, KEY_F11, KEY_KPPLUS, KEY_KPASTERISK,	/*  89 -> 96  */
+/* PTE6 */	KEY_P, KEY_LEFTBRACE, KEY_BACKSPACE, 0, KEY_Q, 0, 0, 0,					/*  97 -> 104 */
+		KEY_W, KEY_E, KEY_R, KEY_O, KEY_I, KEY_U, KEY_T, KEY_Y,					/* 105 -> 112 */
+/* PTE7 */	KEY_0, KEY_MINUS, KEY_EQUAL, 0, KEY_1, 0, 0, 0,						/* 113 -> 120 */
+		KEY_2, KEY_3, KEY_4, KEY_9, KEY_8, KEY_7, KEY_5, KEY_6,					/* 121 -> 128 */
 /* **** */	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 		0, 0, 0, 0, 0
 };

--Multipart=_Wed__12_Dec_2007_19_22_07_+0100_lR6zEQYS_GBKPVM9
Content-Type: application/octet-stream;
 name="hp6xx-keyboard-keymap-fix.patch"
Content-Disposition: attachment;
 filename="hp6xx-keyboard-keymap-fix.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5wdXQva2V5Ym9hcmQvam9ybmFkYTY4MF9rYmQuYyBiL2Ry
aXZlcnMvaW5wdXQva2V5Ym9hcmQvam9ybmFkYTY4MF9rYmQuYwppbmRleCBiZWMxY2Y0Li5hMjM2
MzNhIDEwMDY0NAotLS0gYS9kcml2ZXJzL2lucHV0L2tleWJvYXJkL2pvcm5hZGE2ODBfa2JkLmMK
KysrIGIvZHJpdmVycy9pbnB1dC9rZXlib2FyZC9qb3JuYWRhNjgwX2tiZC5jCkBAIC0xNiwxNCAr
MTYsMTQgQEAKICAqIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uLgog
ICovCiAKLSNpbmNsdWRlIDxsaW51eC9pbnB1dC5oPgotI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5o
PgotI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgogI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4KKyNp
bmNsdWRlIDxsaW51eC9pbnB1dC5oPgogI2luY2x1ZGUgPGxpbnV4L2lucHV0LXBvbGxkZXYuaD4K
KyNpbmNsdWRlIDxsaW51eC9pbnRlcnJ1cHQuaD4KICNpbmNsdWRlIDxsaW51eC9qaWZmaWVzLmg+
CisjaW5jbHVkZSA8bGludXgva2VybmVsLmg+CisjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+CiAj
aW5jbHVkZSA8bGludXgvcGxhdGZvcm1fZGV2aWNlLmg+Ci0jaW5jbHVkZSA8bGludXgvaW50ZXJy
dXB0Lmg+CiAKICNpbmNsdWRlIDxhc20vZGVsYXkuaD4KICNpbmNsdWRlIDxhc20vaW8uaD4KQEAg
LTQzLDIyICs0MywyMiBAQAogI2RlZmluZSBQTERSIDB4YTQwMDAxMzQKIAogc3RhdGljIGNvbnN0
IHVuc2lnbmVkIHNob3J0IGpvcm5hZGFfc2NhbmNvZGVzW10gPSB7Ci0vKiBQVEQxICovCUtFWV9D
QVBTTE9DSywgS0VZX01BQ1JPLCBLRVlfTEVGVENUUkwsIDAsIEtFWV9FU0MsIDAsIDAsIDAsCS8q
ICAxICAtPiA4ICAgKi8KLQkJS0VZX0YxLCBLRVlfRjIsIEtFWV9GMywgS0VZX0Y4LCBLRVlfRjcs
IEtFWV9GMiwgS0VZX0Y0LCBLRVlfRjUsCS8qICA5ICAtPiAxNiAgKi8KLS8qIFBURDUgKi8JS0VZ
X1NMQVNILCBLRVlfQVBPU1RST1BIRSwgS0VZX0VOVEVSLCAwLCBLRVlfWiwgMCwgMCwgMCwJLyog
IDE3IC0+IDI0ICAqLwotCQlLRVlfWCwgS0VZX0MsIEtFWV9WLCBLRVlfRE9ULCBLRVlfQ09NTUEs
IEtFWV9NLCBLRVlfQiwgS0VZX04sCS8qICAyNSAtPiAzMiAgKi8KLS8qIFBURDcgKi8JS0VZX0tQ
MiwgS0VZX0tQNiwgMCwgMCwgMCwgMCwgMCwgMCwJCQkJLyogIDMzIC0+IDQwICAqLwotCQkwLCAw
LCAwLCBLRVlfS1A0LCAwLCAwLCBLRVlfTEVGVEFMVCwgS0VZX0hBTkpBLAkJCS8qICA0MSAtPiA0
OCAgKi8KLS8qIFBURTAgKi8JMCwgMCwgMCwgMCwgS0VZX0ZJTkFOQ0UsIDAsIDAsIDAsCQkJCS8q
ICA0OSAtPiA1NiAgKi8KLQkJS0VZX0xFRlRDVFJMLCAwLCBLRVlfU1BBQ0UsIEtFWV9LUERPVCwg
S0VZX1ZPTFVNRVVQLCAyNDksIDAsIDAsIC8qICA1NyAtPiA2NCAgKi8KLS8qIFBURTEgKi8JS0VZ
X1NFTUlDT0xPTiwgS0VZX1JJR0hUQlJBQ0UsIEtFWV9CQUNLU0xBU0gsIDAsIEtFWV9BLCAwLCAw
LCAwLC8qICA2NSAtPiA3MiAgKi8KLQkJS0VZX1MsIEtFWV9ELCBLRVlfRiwgS0VZX0wsIEtFWV9L
LCBLRVlfSiwgS0VZX0csIEtFWV9ILAkJLyogIDczIC0+IDgwICAqLwotLyogUFRFMyAqLwlLRVlf
S1A4LCBLRVlfTEVGVE1FVEEsIEtFWV9SSUdIVFNISUZULCAwLCBLRVlfVEFCLCAwLCAwLDAsCS8q
ICA4MSAtPiA4OCAgKi8KLQkJMCwgS0VZX0xFRlRTSElGVCwgMCwgMCwgMCwgMCwgMCwgMCwJCQkJ
LyogIDg5IC0+IDk2ICAqLwotLyogUFRFNiAqLwlLRVlfUCwgS0VZX0xFRlRCUkFDRSwgS0VZX0JB
Q0tTUEFDRSwgMCwgS0VZX1EsIDAsIDAsIDAsCQkvKiAgOTcgLT4gMTA0ICovCi0JCUtFWV9XLCBL
RVlfRSwgS0VZX1IsIEtFWV9PLCBLRVlfSSwgS0VZX1UsIEtFWV9ULCBLRVlfUiwJCS8qIDEwNSAt
PiAxMTIgKi8KLS8qIFBURTcgKi8JS0VZXzAsIEtFWV9NSU5VUywgS0VZX0VRVUFMLCAwLCBLRVlf
MSwgMCwgMCwgMCwJCQkvKiAxMTMgLT4gMTIwICovCi0JCUtFWV8yLCBLRVlfMywgS0VZXzQsIEtF
WV85LCBLRVlfOCwgS0VZXzcsIEtFWV81LCBLRVlfNiwJCS8qIDEyMSAtPiAxMjggKi8KKy8qIFBU
RDEgKi8JS0VZX0NBUFNMT0NLLCBLRVlfTUFDUk8sIEtFWV9MRUZUQ1RSTCwgMCwgS0VZX0VTQywg
S0VZX0tQNSwgMCwgMCwJCQkvKiAgMSAgLT4gOCAgICovCisJCUtFWV9GMSwgS0VZX0YyLCBLRVlf
RjMsIEtFWV9GOCwgS0VZX0Y3LCBLRVlfRjYsIEtFWV9GNCwgS0VZX0Y1LAkJCQkvKiAgOSAgLT4g
MTYgICovCisvKiBQVEQ1ICovCUtFWV9TTEFTSCwgS0VZX0FQT1NUUk9QSEUsIEtFWV9FTlRFUiwg
MCwgS0VZX1osIDAsIDAsIDAsCQkJCS8qICAxNyAtPiAyNCAgKi8KKwkJS0VZX1gsIEtFWV9DLCBL
RVlfViwgS0VZX0RPVCwgS0VZX0NPTU1BLCBLRVlfTSwgS0VZX0IsIEtFWV9OLAkJCQkvKiAgMjUg
LT4gMzIgICovCisvKiBQVEQ3ICovCUtFWV9LUDIsIEtFWV9LUDYsIEtFWV9LUDMsIDAsIDAsIDAs
IDAsIDAsCQkJCQkJLyogIDMzIC0+IDQwICAqLworCQlLRVlfRjEwLCBLRVlfUk8sIEtFWV9GOSwg
S0VZX0tQNCwgS0VZX05VTUxPQ0ssIEtFWV9TQ1JPTExMT0NLLCBLRVlfTEVGVEFMVCwgS0VZX0hB
TkpBLAkvKiAgNDEgLT4gNDggICovCisvKiBQVEUwICovCUtFWV9LQVRBS0FOQSwgS0VZX0tQMCwg
S0VZX0dSQVZFLCAwLCBLRVlfRklOQU5DRSwgMCwgMCwgMCwJCQkJLyogIDQ5IC0+IDU2ICAqLwor
CQlLRVlfS1BNSU5VUywgS0VZX0hJUkFHQU5BLCBLRVlfU1BBQ0UsIEtFWV9LUERPVCwgS0VZX1ZP
TFVNRVVQLCAyNDksIDAsIDAsCQkvKiAgNTcgLT4gNjQgICovCisvKiBQVEUxICovCUtFWV9TRU1J
Q09MT04sIEtFWV9SSUdIVEJSQUNFLCBLRVlfQkFDS1NMQVNILCAwLCBLRVlfQSwgMCwgMCwgMCwJ
CQkvKiAgNjUgLT4gNzIgICovCisJCUtFWV9TLCBLRVlfRCwgS0VZX0YsIEtFWV9MLCBLRVlfSywg
S0VZX0osIEtFWV9HLCBLRVlfSCwJCQkJCS8qICA3MyAtPiA4MCAgKi8KKy8qIFBURTMgKi8JS0VZ
X0tQOCwgS0VZX0xFRlRNRVRBLCBLRVlfUklHSFRTSElGVCwgMCwgS0VZX1RBQiwgMCwgMCwgMCwJ
CQkJLyogIDgxIC0+IDg4ICAqLworCQkwLCBLRVlfTEVGVFNISUZULCBLRVlfS1A3LCBLRVlfS1A5
LCBLRVlfS1AxLCBLRVlfRjExLCBLRVlfS1BQTFVTLCBLRVlfS1BBU1RFUklTSywJLyogIDg5IC0+
IDk2ICAqLworLyogUFRFNiAqLwlLRVlfUCwgS0VZX0xFRlRCUkFDRSwgS0VZX0JBQ0tTUEFDRSwg
MCwgS0VZX1EsIDAsIDAsIDAsCQkJCQkvKiAgOTcgLT4gMTA0ICovCisJCUtFWV9XLCBLRVlfRSwg
S0VZX1IsIEtFWV9PLCBLRVlfSSwgS0VZX1UsIEtFWV9ULCBLRVlfWSwJCQkJCS8qIDEwNSAtPiAx
MTIgKi8KKy8qIFBURTcgKi8JS0VZXzAsIEtFWV9NSU5VUywgS0VZX0VRVUFMLCAwLCBLRVlfMSwg
MCwgMCwgMCwJCQkJCQkvKiAxMTMgLT4gMTIwICovCisJCUtFWV8yLCBLRVlfMywgS0VZXzQsIEtF
WV85LCBLRVlfOCwgS0VZXzcsIEtFWV81LCBLRVlfNiwJCQkJCS8qIDEyMSAtPiAxMjggKi8KIC8q
ICoqKiogKi8JMCwgMCwgMCwgMCwgMCwgMCwgMCwgMCwgMCwgMCwKIAkJMCwgMCwgMCwgMCwgMAog
fTsK

--Multipart=_Wed__12_Dec_2007_19_22_07_+0100_lR6zEQYS_GBKPVM9--
