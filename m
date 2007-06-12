Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbXFLRwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbXFLRwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 13:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbXFLRwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 13:52:00 -0400
Received: from smtp3.versatel.nl ([62.58.50.90]:35200 "EHLO smtp3.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280AbXFLRv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 13:51:59 -0400
Message-ID: <466EE06B.9030202@hhs.nl>
Date: Tue, 12 Jun 2007 20:05:31 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.0 (X11/20070414)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Vojtech Pavlik <vojtech@suse.cz>, sbrabec@suse.cz
Subject: PATCH: fix mismatch between usb-hid.c HUT find/search mapping and
 the HUT reference doc
Content-Type: multipart/mixed;
 boundary="------------010702030509030902060601"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010702030509030902060601
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

As some of you might know from my earlier post/thread about atkbd and softraw, 
I'm currently working on getting keyboards with internet/easy access keys to 
work painlessly / plug and play.

In order to be able to better test / develop this I've bought 2 cheap such 
keyboards today, one ps2 and one both usb and ps2 capable.

When comparing usb vs ps2 / testing the keycodes generated for the easy access
keys on my trust (microsoft compatible) keyboard. I noticed the search key
generated the linux/input keycode for find when connected through USB. This 
lead me to check the consumer page mappings in hid-input.c . And it turns out 
the the mapping for ID 0x221 deviates from the HUT standard document:
http://www.usb.org/developers/devclass_docs/Hut1_12.pdf

Currently it is incorrectly mapped to find, whereas it should be mapped to
search. I also added missing bindings for ID 0x21f, the real find and for
0x222, goto.

Regards,

Hans

--------------010702030509030902060601
Content-Type: text/x-patch;
 name="usb-hid-hut.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="usb-hid-hut.patch"

When comparing usb vs ps2 / testing the keycodes generated for the easy access
keys on my trust (microsoft compatible) keyboard. I noticed the search key
generated the keycode for find when connected through USB. This lead me to
check the consumer page mappings in hid-input.c . And it turns out the the
mapping for ID 0x221 deviates from the HUT standard document:
http://www.usb.org/developers/devclass_docs/Hut1_12.pdf

Currently it is incorrectly mapped to find, whereas it should be mapped to
search. I also added missing bindings for ID 0x21f, the real find and for
0x222, goto.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
--- linux-2.6.21.x86_64/drivers/hid/hid-input.c.hut	2007-06-12 19:26:58.000000000 +0200
+++ linux-2.6.21.x86_64/drivers/hid/hid-input.c	2007-06-12 19:33:32.000000000 +0200
@@ -598,7 +598,9 @@
 				case 0x21b: map_key_clear(KEY_COPY);		break;
 				case 0x21c: map_key_clear(KEY_CUT);		break;
 				case 0x21d: map_key_clear(KEY_PASTE);		break;
-				case 0x221: map_key_clear(KEY_FIND);		break;
+				case 0x21f: map_key_clear(KEY_FIND);		break;
+				case 0x221: map_key_clear(KEY_SEARCH);		break;
+				case 0x222: map_key_clear(KEY_GOTO);		break;
 				case 0x223: map_key_clear(KEY_HOMEPAGE);	break;
 				case 0x224: map_key_clear(KEY_BACK);		break;
 				case 0x225: map_key_clear(KEY_FORWARD);		break;

--------------010702030509030902060601--
