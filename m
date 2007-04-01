Return-Path: <linux-kernel-owner+w=401wt.eu-S1751529AbXDAC4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbXDAC4b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 22:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbXDAC4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 22:56:31 -0400
Received: from rwcrmhc11.comcast.net ([204.127.192.81]:55153 "EHLO
	rwcrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbXDAC4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 22:56:30 -0400
Subject: [PATCH] hid: add two led codes to hid input mapping
From: Dan Engel <dan@sourceharvest.com>
To: jkosina@suse.cz
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 31 Mar 2007 22:56:28 -0400
Message-Id: <1175396188.7857.15.camel@monica.engel.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel P. Engel <dengel@sourceharvest.com>

Add the "Off-hook" and "Speaker" LED codes 0xb and 0xc to the hid-input configuration,
mapping them to the 0x17 and 0x1e usages in the HID usage table.

Signed-off-by: Daniel P. Engel <dengel@sourceharvest.com>
---
This patch is really being offered because it's what's needed to make the operation
of the Belkin Flip USB KVM switch avaiable to user-space programs through the HID input
event interface. The Belkin Flip KVM overloads LED usages to give software control
over the device, providing options to flip either audio, video or both. However,
without an input mapping to the Off-hook and Speaker LED usages, this functionality
isn't available.

It's a minor patch, adding two led codes to the EV_LED type, and mapping them to
corresponding HID usages.

This patch was created against kernel version 2.6.20.4.

diff -uprN -X linux-2.6.20.4-vanilla/Documentation/dontdiff linux-2.6.20.4-vanilla/drivers/hid/hid-input.c linux-2.6/drivers/hid/hid-input.c
--- linux-2.6.20.4-vanilla/drivers/hid/hid-input.c	2007-03-23 15:52:51.000000000 -0400
+++ linux-2.6/drivers/hid/hid-input.c	2007-03-31 13:43:46.000000000 -0400
@@ -381,6 +381,8 @@ static void hidinput_configure_usage(str
 				case 0x4b:  map_led (LED_MISC);     break;    /*   "Generic Indicator"        */
 				case 0x19:  map_led (LED_MAIL);     break;    /*   "Message Waiting"          */
 				case 0x4d:  map_led (LED_CHARGING); break;    /*   "External Power Connected" */
+				case 0x17:  map_led (LED_OFFHOOK);  break;    /*   "Off Hook"                 */
+				case 0x1e:  map_led (LED_SPEAKER);  break;    /*   "Speaker"                  */
 
 				default: goto ignore;
 			}
diff -uprN -X linux-2.6.20.4-vanilla/Documentation/dontdiff linux-2.6.20.4-vanilla/include/linux/input.h linux-2.6/include/linux/input.h
--- linux-2.6.20.4-vanilla/include/linux/input.h	2007-03-23 15:52:51.000000000 -0400
+++ linux-2.6/include/linux/input.h	2007-03-31 13:42:22.000000000 -0400
@@ -630,6 +630,8 @@ struct input_absinfo {
 #define LED_MISC		0x08
 #define LED_MAIL		0x09
 #define LED_CHARGING		0x0a
+#define LED_OFFHOOK		0x0b
+#define LED_SPEAKER		0x0c
 #define LED_MAX			0x0f
 
 /*


