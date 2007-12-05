Return-Path: <linux-kernel-owner+w=401wt.eu-S1754325AbXLEUTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbXLEUTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 15:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbXLEUTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 15:19:23 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:54447 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbXLEUTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 15:19:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:from;
        b=FqA97SO+TtykUVR/ltuN61+AVLxv5jWDnYoEqy8uHBo8imXsH8XjKRblbqq9ZGJw7I+ZZMafuZ6yPQrITk0uz+Hr4pmxcK8J2g+88AL74WNu6NQcymApgRIvvughqfks+PABxnGLB/sAWpt+4ofTPVuiCZPlOAUWbEodHilYOe4=
Date: Wed, 5 Dec 2007 21:19:26 +0100
To: Dmitry <dmitry.torokhov@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Russell King <linux@arm.linux.org.uk>
Cc: linux-main <linux-kernel@vger.kernel.org>
Subject: [PATCH/HP6xx/HP7xx] Cleanup drivers/input/keyboard|touchscreen
 Kconfigs
Message-Id: <20071205211926.5a9e261b.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Wed__5_Dec_2007_21_19_26_+0100_25NwVH/T+Kuq0SN5"
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Wed__5_Dec_2007_21_19_26_+0100_25NwVH/T+Kuq0SN5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Greetings,

Oki, here is a more standard Kconfig setting for both platforms. Nothing major really.
Note that touchscreen for hp6xx was called TOUCHSCREEN_HP600 and I've changed it to HP6XX to get it inline with everything else.

This should be pushed through dmitry I assume. Its against linux-2.6.git.

shortlog:
This patch cleans up the drivers/input/keyboard|touchscreen Kconfigs for platforms hp6xx and hp7xx. It unifies the naming and descriptions.

signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index dfa6592..7421b91 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -209,22 +209,22 @@ config KEYBOARD_HIL
 	  to your machine, so normally you should say Y here.
 
 config KEYBOARD_HP6XX
-	tristate "HP Jornada 6XX Keyboard support"
+	tristate "HP Jornada 6xx keyboard"
 	depends on SH_HP6XX
 	select INPUT_POLLDEV
 	help
-	  This adds support for the onboard keyboard found on
-	  HP Jornada 620/660/680/690.
+	  Say Y here if you have a HP Jornada 620/660/680/690 and want to
+	  support the built-in keyboard.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called jornada680_kbd.
 
 config KEYBOARD_HP7XX
-	tristate "HP Jornada 7XX Keyboard Driver"
+	tristate "HP Jornada 7xx keyboard"
 	depends on SA1100_JORNADA720_SSP && SA1100_SSP
 	help
-	  Say Y here to add support for the HP Jornada 7xx (710/720/728)
-	  onboard keyboard.
+	  Say Y here if you have a HP Jornada 710/720/728 and want to 
+	  support the built-in keyboard.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called jornada720_kbd.
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index fa8442b..3271dd3 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -114,20 +114,18 @@ config TOUCHSCREEN_MK712
 	  To compile this driver as a module, choose M here: the
 	  module will be called mk712.
 
-config TOUCHSCREEN_HP600
-	tristate "HP Jornada 680/690 touchscreen"
+config TOUCHSCREEN_HP6XX
+	tristate "HP Jornada 6xx touchscreen"
 	depends on SH_HP6XX && SH_ADC
 	help
-	  Say Y here if you have a HP Jornada 680 or 690 and want to
+	  Say Y here if you have a HP Jornada 620/660/680/690 and want to
           support the built-in touchscreen.
 
-	  If unsure, say N.
-
 	  To compile this driver as a module, choose M here: the
 	  module will be called hp680_ts_input.
 
 config TOUCHSCREEN_HP7XX
-	tristate "HP Jornada 710/720/728 touchscreen"
+	tristate "HP Jornada 7xx touchscreen"
 	depends on SA1100_JORNADA720_SSP
 	help
 	  Say Y here if you have a HP Jornada 710/720/728 and want
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 35d4097..75c2fe8 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -12,7 +12,7 @@ obj-$(CONFIG_TOUCHSCREEN_ELO)		+= elo.o
 obj-$(CONFIG_TOUCHSCREEN_FUJITSU)	+= fujitsu_ts.o
 obj-$(CONFIG_TOUCHSCREEN_MTOUCH)	+= mtouch.o
 obj-$(CONFIG_TOUCHSCREEN_MK712)		+= mk712.o
-obj-$(CONFIG_TOUCHSCREEN_HP600)		+= hp680_ts_input.o
+obj-$(CONFIG_TOUCHSCREEN_HP6XX)		+= hp680_ts_input.o
 obj-$(CONFIG_TOUCHSCREEN_HP7XX)		+= jornada720_ts.o
 obj-$(CONFIG_TOUCHSCREEN_USB_COMPOSITE)	+= usbtouchscreen.o
 obj-$(CONFIG_TOUCHSCREEN_PENMOUNT)	+= penmount.o

--Multipart=_Wed__5_Dec_2007_21_19_26_+0100_25NwVH/T+Kuq0SN5
Content-Type: application/octet-stream;
 name="hp6xx-drivers-Kconfig-cleanup.patch"
Content-Disposition: attachment;
 filename="hp6xx-drivers-Kconfig-cleanup.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5wdXQva2V5Ym9hcmQvS2NvbmZpZyBiL2RyaXZlcnMvaW5w
dXQva2V5Ym9hcmQvS2NvbmZpZwppbmRleCBkZmE2NTkyLi43NDIxYjkxIDEwMDY0NAotLS0gYS9k
cml2ZXJzL2lucHV0L2tleWJvYXJkL0tjb25maWcKKysrIGIvZHJpdmVycy9pbnB1dC9rZXlib2Fy
ZC9LY29uZmlnCkBAIC0yMDksMjIgKzIwOSwyMiBAQCBjb25maWcgS0VZQk9BUkRfSElMCiAJICB0
byB5b3VyIG1hY2hpbmUsIHNvIG5vcm1hbGx5IHlvdSBzaG91bGQgc2F5IFkgaGVyZS4KIAogY29u
ZmlnIEtFWUJPQVJEX0hQNlhYCi0JdHJpc3RhdGUgIkhQIEpvcm5hZGEgNlhYIEtleWJvYXJkIHN1
cHBvcnQiCisJdHJpc3RhdGUgIkhQIEpvcm5hZGEgNnh4IGtleWJvYXJkIgogCWRlcGVuZHMgb24g
U0hfSFA2WFgKIAlzZWxlY3QgSU5QVVRfUE9MTERFVgogCWhlbHAKLQkgIFRoaXMgYWRkcyBzdXBw
b3J0IGZvciB0aGUgb25ib2FyZCBrZXlib2FyZCBmb3VuZCBvbgotCSAgSFAgSm9ybmFkYSA2MjAv
NjYwLzY4MC82OTAuCisJICBTYXkgWSBoZXJlIGlmIHlvdSBoYXZlIGEgSFAgSm9ybmFkYSA2MjAv
NjYwLzY4MC82OTAgYW5kIHdhbnQgdG8KKwkgIHN1cHBvcnQgdGhlIGJ1aWx0LWluIGtleWJvYXJk
LgogCiAJICBUbyBjb21waWxlIHRoaXMgZHJpdmVyIGFzIGEgbW9kdWxlLCBjaG9vc2UgTSBoZXJl
OiB0aGUKIAkgIG1vZHVsZSB3aWxsIGJlIGNhbGxlZCBqb3JuYWRhNjgwX2tiZC4KIAogY29uZmln
IEtFWUJPQVJEX0hQN1hYCi0JdHJpc3RhdGUgIkhQIEpvcm5hZGEgN1hYIEtleWJvYXJkIERyaXZl
ciIKKwl0cmlzdGF0ZSAiSFAgSm9ybmFkYSA3eHgga2V5Ym9hcmQiCiAJZGVwZW5kcyBvbiBTQTEx
MDBfSk9STkFEQTcyMF9TU1AgJiYgU0ExMTAwX1NTUAogCWhlbHAKLQkgIFNheSBZIGhlcmUgdG8g
YWRkIHN1cHBvcnQgZm9yIHRoZSBIUCBKb3JuYWRhIDd4eCAoNzEwLzcyMC83MjgpCi0JICBvbmJv
YXJkIGtleWJvYXJkLgorCSAgU2F5IFkgaGVyZSBpZiB5b3UgaGF2ZSBhIEhQIEpvcm5hZGEgNzEw
LzcyMC83MjggYW5kIHdhbnQgdG8gCisJICBzdXBwb3J0IHRoZSBidWlsdC1pbiBrZXlib2FyZC4K
IAogCSAgVG8gY29tcGlsZSB0aGlzIGRyaXZlciBhcyBhIG1vZHVsZSwgY2hvb3NlIE0gaGVyZTog
dGhlCiAJICBtb2R1bGUgd2lsbCBiZSBjYWxsZWQgam9ybmFkYTcyMF9rYmQuCmRpZmYgLS1naXQg
YS9kcml2ZXJzL2lucHV0L3RvdWNoc2NyZWVuL0tjb25maWcgYi9kcml2ZXJzL2lucHV0L3RvdWNo
c2NyZWVuL0tjb25maWcKaW5kZXggZmE4NDQyYi4uMzI3MWRkMyAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9pbnB1dC90b3VjaHNjcmVlbi9LY29uZmlnCisrKyBiL2RyaXZlcnMvaW5wdXQvdG91Y2hzY3Jl
ZW4vS2NvbmZpZwpAQCAtMTE0LDIwICsxMTQsMTggQEAgY29uZmlnIFRPVUNIU0NSRUVOX01LNzEy
CiAJICBUbyBjb21waWxlIHRoaXMgZHJpdmVyIGFzIGEgbW9kdWxlLCBjaG9vc2UgTSBoZXJlOiB0
aGUKIAkgIG1vZHVsZSB3aWxsIGJlIGNhbGxlZCBtazcxMi4KIAotY29uZmlnIFRPVUNIU0NSRUVO
X0hQNjAwCi0JdHJpc3RhdGUgIkhQIEpvcm5hZGEgNjgwLzY5MCB0b3VjaHNjcmVlbiIKK2NvbmZp
ZyBUT1VDSFNDUkVFTl9IUDZYWAorCXRyaXN0YXRlICJIUCBKb3JuYWRhIDZ4eCB0b3VjaHNjcmVl
biIKIAlkZXBlbmRzIG9uIFNIX0hQNlhYICYmIFNIX0FEQwogCWhlbHAKLQkgIFNheSBZIGhlcmUg
aWYgeW91IGhhdmUgYSBIUCBKb3JuYWRhIDY4MCBvciA2OTAgYW5kIHdhbnQgdG8KKwkgIFNheSBZ
IGhlcmUgaWYgeW91IGhhdmUgYSBIUCBKb3JuYWRhIDYyMC82NjAvNjgwLzY5MCBhbmQgd2FudCB0
bwogICAgICAgICAgIHN1cHBvcnQgdGhlIGJ1aWx0LWluIHRvdWNoc2NyZWVuLgogCi0JICBJZiB1
bnN1cmUsIHNheSBOLgotCiAJICBUbyBjb21waWxlIHRoaXMgZHJpdmVyIGFzIGEgbW9kdWxlLCBj
aG9vc2UgTSBoZXJlOiB0aGUKIAkgIG1vZHVsZSB3aWxsIGJlIGNhbGxlZCBocDY4MF90c19pbnB1
dC4KIAogY29uZmlnIFRPVUNIU0NSRUVOX0hQN1hYCi0JdHJpc3RhdGUgIkhQIEpvcm5hZGEgNzEw
LzcyMC83MjggdG91Y2hzY3JlZW4iCisJdHJpc3RhdGUgIkhQIEpvcm5hZGEgN3h4IHRvdWNoc2Ny
ZWVuIgogCWRlcGVuZHMgb24gU0ExMTAwX0pPUk5BREE3MjBfU1NQCiAJaGVscAogCSAgU2F5IFkg
aGVyZSBpZiB5b3UgaGF2ZSBhIEhQIEpvcm5hZGEgNzEwLzcyMC83MjggYW5kIHdhbnQKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvaW5wdXQvdG91Y2hzY3JlZW4vTWFrZWZpbGUgYi9kcml2ZXJzL2lucHV0
L3RvdWNoc2NyZWVuL01ha2VmaWxlCmluZGV4IDM1ZDQwOTcuLjc1YzJmZTggMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvaW5wdXQvdG91Y2hzY3JlZW4vTWFrZWZpbGUKKysrIGIvZHJpdmVycy9pbnB1dC90
b3VjaHNjcmVlbi9NYWtlZmlsZQpAQCAtMTIsNyArMTIsNyBAQCBvYmotJChDT05GSUdfVE9VQ0hT
Q1JFRU5fRUxPKQkJKz0gZWxvLm8KIG9iai0kKENPTkZJR19UT1VDSFNDUkVFTl9GVUpJVFNVKQkr
PSBmdWppdHN1X3RzLm8KIG9iai0kKENPTkZJR19UT1VDSFNDUkVFTl9NVE9VQ0gpCSs9IG10b3Vj
aC5vCiBvYmotJChDT05GSUdfVE9VQ0hTQ1JFRU5fTUs3MTIpCQkrPSBtazcxMi5vCi1vYmotJChD
T05GSUdfVE9VQ0hTQ1JFRU5fSFA2MDApCQkrPSBocDY4MF90c19pbnB1dC5vCitvYmotJChDT05G
SUdfVE9VQ0hTQ1JFRU5fSFA2WFgpCQkrPSBocDY4MF90c19pbnB1dC5vCiBvYmotJChDT05GSUdf
VE9VQ0hTQ1JFRU5fSFA3WFgpCQkrPSBqb3JuYWRhNzIwX3RzLm8KIG9iai0kKENPTkZJR19UT1VD
SFNDUkVFTl9VU0JfQ09NUE9TSVRFKQkrPSB1c2J0b3VjaHNjcmVlbi5vCiBvYmotJChDT05GSUdf
VE9VQ0hTQ1JFRU5fUEVOTU9VTlQpCSs9IHBlbm1vdW50Lm8K

--Multipart=_Wed__5_Dec_2007_21_19_26_+0100_25NwVH/T+Kuq0SN5--
