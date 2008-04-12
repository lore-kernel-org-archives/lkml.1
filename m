Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbYDLQTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbYDLQTc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 12:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbYDLQTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 12:19:18 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:54627 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755608AbYDLQTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 12:19:17 -0400
Subject: [PATCH] make alsa use corect patch for Realtek ALC889A
From: Kasper Sandberg <lkml@metanurb.dk>
To: LKML Mailinglist <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 12 Apr 2008 18:17:23 +0200
Message-Id: <1208017043.1514.50.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello..
I have a gigabyte X48-DQ6 motherboard, specification url:
http://www.gigabyte.com.tw/Products/Motherboard/Products_Spec.aspx?ClassValue=Motherboard&ProductID=2763&ProductName=GA-X48-DQ6
they clearly state it uses a realtek alc 889a.

google around, it seems lots of people which has this chip gets it
detected as alc885, including me.

now, audio works (atleast analog out, havent tested the rest), allthough
i couldnt get the supposed feature of separate channel to front panel to
work(doesent matter much to me though)

interrested in fixing this just for the sake of fixing, i ventured into
patch_realtek.c, and found the structure that defined patches for hda
audio.

i inspected my /proc/asound/card0/codec#2 file (only one except the id
file), and found the following information:
Codec: Realtek ALC885
Address: 2
Vendor Id: 0x10ec0885
Subsystem Id: 0x1458a002
Revision Id: 0x100103

i then modified patch_realtek.c to detect mine as ALC889A, and assign
the correct patch to it (well, the one used for 889).

After rebuilding, it now uses patch 883 instead of 882 as it did before.
i dont appear to have recieved any separate front panel channel,
however, it still seems more correct now, and is probably wise to keep
for when 883 is improved to support the hardware fully.

the only thing i notice has changed, is the message i get from the
kernel, before i changed, it said:
hda_codec: Unknown model for ALC882, trying auto-probe from BIOS...
now it says:
hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
but i guess if it has to spew out such a line, it now spews out the
correct one.

analog audio works, so thats fine..

the patch(i apologize if my mailer messes up whitespace, but its so
simple that it doesent matter):
--- /usr/src/linux/sound/pci/hda/patch_realtek.c        2008-04-06
02:31:52.840247789 +0200
+++ /chroot/kernelgentoo/usr/src/linux-2.6.24/sound/pci/hda/patch_realtek.c     2008-04-12 17:09:58.308101686 +0200
@@ -13759,6 +13759,7 @@
        { .id = 0x10ec0662, .rev = 0x100101, .name = "ALC662 rev1",
          .patch = patch_alc662 },
        { .id = 0x10ec0880, .name = "ALC880", .patch = patch_alc880 },
+       { .id = 0x10ec0885, .rev = 0x100103, .name = "ALC889A", .patch =
patch_alc883 },
        { .id = 0x10ec0882, .name = "ALC882", .patch = patch_alc882 },
        { .id = 0x10ec0883, .name = "ALC883", .patch = patch_alc883 },
        { .id = 0x10ec0885, .name = "ALC885", .patch = patch_alc882 },



i guess some alsa people should be cc'ed, i couldnt find the relevant
list though, is it alsa-devel@alsa-project.org ?


mvh / regards
Kasper Sandberg

