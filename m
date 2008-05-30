Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbYE3AwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbYE3AwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 20:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYE3AwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 20:52:00 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:42859 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbYE3AwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 20:52:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iGgzm1fNFYj9zeoKihdgUHO1nRfZ3NaZG//SYzemm6ZjRWpu4VoMDMpID064N30XSyiueS3e9xrGT49bvoYwsojXa4CR9hzAR/9NBLNcG+6XLGICuKy1hArkrDiGjO2samRJnBXtnJWbv8AhxvjMoqz0oOds0dYO4GKjT5jdtpY=
Subject: [PATCH] acpi: fix sparse const errors
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Thu, 29 May 2008 17:51:57 -0700
Message-Id: <1212108717.28403.165.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this case we want a constant pointer to constant chars:
drivers/misc/thinkpad_acpi.c:3824:19: error: Just how const do you want this type to be?

Like the error says.
drivers/misc/thinkpad_acpi.c:3863:19: error: Just how const do you want this type to be?
drivers/misc/thinkpad_acpi.c:3864:19: error: Just how const do you want this type to be?
drivers/misc/thinkpad_acpi.c:3865:19: error: Just how const do you want this type to be?
drivers/misc/thinkpad_acpi.c:3866:19: error: Just how const do you want this type to be?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/misc/thinkpad_acpi.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
index 3f28f6e..a0ce0b2 100644
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -3821,7 +3821,7 @@ TPACPI_HANDLE(led, ec, "SLED",	/* 570 */
 #define TPACPI_LED_NUMLEDS 8
 static struct tpacpi_led_classdev *tpacpi_leds;
 static enum led_status_t tpacpi_led_state_cache[TPACPI_LED_NUMLEDS];
-static const char const *tpacpi_led_names[TPACPI_LED_NUMLEDS] = {
+static const char * const tpacpi_led_names[TPACPI_LED_NUMLEDS] = {
 	/* there's a limit of 19 chars + NULL before 2.6.26 */
 	"tpacpi::power",
 	"tpacpi:orange:batt",
@@ -3860,10 +3860,10 @@ static int led_get_status(unsigned int led)
 static int led_set_status(unsigned int led, enum led_status_t ledstatus)
 {
 	/* off, on, blink. Index is led_status_t */
-	static const int const led_sled_arg1[] = { 0, 1, 3 };
-	static const int const led_exp_hlbl[] = { 0, 0, 1 };	/* led# * */
-	static const int const led_exp_hlcl[] = { 0, 1, 1 };	/* led# * */
-	static const int const led_led_arg1[] = { 0, 0x80, 0xc0 };
+	static const int led_sled_arg1[] = { 0, 1, 3 };
+	static const int led_exp_hlbl[] = { 0, 0, 1 };	/* led# * */
+	static const int led_exp_hlcl[] = { 0, 1, 1 };	/* led# * */
+	static const int led_led_arg1[] = { 0, 0x80, 0xc0 };
 
 	int rc = 0;
 
-- 
1.5.6.rc0.277.g804cf



