Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbYEJVw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbYEJVw7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 17:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbYEJVwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 17:52:50 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:16634 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbYEJVwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 17:52:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=E7iwgnLaJRvecC6onOdwEtSYflaHKftG/PyGBPg2U1WnANeDlm0tlPD8Od0SaMoE8Fq5N67jsT2zwC+tQqyBG04Naxh7ChTgEvZ2qE4gFYAvaXHgyCn4D0+32lR2KvZmR3BdCv7bSxESKoIxeBMXVApPCzsw6TkTE3qR4Bnhnv0=
Message-ID: <4826192E.1030409@gmail.com>
Date: Sat, 10 May 2008 16:52:46 -0500
From: "Dylan R. Semler" <dylan.semler@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: jkosina@suse.cz
CC: torvalds@linux-foundation.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] USB HID/HIDBP DRIVERS: Add iMON LCDs to HID blacklist
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dylan R Semler <dylan.semler@gmail.com>

The new iMON LCDs from SoundGraph need to be blacklisted from HID in 
order to be used by lirc.
This patch adds vendor and device IDs for iMON LCDs and adds them to the 
blacklist.

Signed-off-by: Dylan R Semler dylan.semler@gmail.com
---
--- vanilla-2.6.25/drivers/hid/usbhid/hid-quirks.c.orig 2008-05-10 
14:22:19.000000000 -0500
+++ vanilla-2.6.25/drivers/hid/usbhid/hid-quirks.c 2008-05-10 
14:20:37.000000000 -0500
@@ -374,6 +374,9 @@
#define USB_VENDOR_ID_SONY 0x054c
#define USB_DEVICE_ID_SONY_PS3_CONTROLLER 0x0268

+#define USB_VENDOR_ID_SOUNDGRAPH                0x15c2
+#define USB_DEVICE_ID_SOUNDGRAPH_IMON_LCD       0x0038
+
#define USB_VENDOR_ID_SUN 0x0430
#define USB_DEVICE_ID_RARITAN_KVM_DONGLE 0xcdab

@@ -570,6 +573,7 @@ static const struct hid_blacklist {
{ USB_VENDOR_ID_PANJIT, 0x0002, HID_QUIRK_IGNORE },
{ USB_VENDOR_ID_PANJIT, 0x0003, HID_QUIRK_IGNORE },
{ USB_VENDOR_ID_PANJIT, 0x0004, HID_QUIRK_IGNORE },
+ { USB_VENDOR_ID_SOUNDGRAPH, USB_DEVICE_ID_SOUNDGRAPH_IMON_LCD, 
HID_QUIRK_IGNORE },
{ USB_VENDOR_ID_VERNIER, USB_DEVICE_ID_VERNIER_LABPRO, HID_QUIRK_IGNORE },
{ USB_VENDOR_ID_VERNIER, USB_DEVICE_ID_VERNIER_GOTEMP, HID_QUIRK_IGNORE },
{ USB_VENDOR_ID_VERNIER, USB_DEVICE_ID_VERNIER_SKIP, HID_QUIRK_IGNORE },

