Return-Path: <linux-kernel-owner+w=401wt.eu-S1761000AbYENBAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761000AbYENBAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 21:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757455AbYENBA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 21:00:28 -0400
Received: from sedna.astro.columbia.edu ([128.59.168.57]:59479 "EHLO
	sedna.astro.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757436AbYENBA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 21:00:27 -0400
X-Greylist: delayed 1326 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 May 2008 21:00:27 EDT
Message-ID: <482A347B.7020203@astro.columbia.edu>
Date: Tue, 13 May 2008 19:38:19 -0500
From: "Dylan R. Semler" <dsemler@astro.columbia.edu>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] USB HID/HIDBP DRIVERS: Add iMON LCDs to HID blacklist
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 5:27 AM, Jiri Kosina <jkosina@suse.cz> wrote:
 > On Sat, 10 May 2008, Dylan R. Semler wrote:
 >
 >  > From: Dylan R Semler <dylan.semler@gmail.com>
 >
 >  > The new iMON LCDs from SoundGraph need to be blacklisted from HID in
 >  > order to be used by lirc. This patch adds vendor and device IDs for iMON
 >  > LCDs and adds them to the blacklist.
 >
 >  Hi Dylan,
 >
 >  the patch is whitespace damaged and line wrapped, could you please resend
 >  properly?
 >
 >  Thanks,

Sorry guys.  I tried to keep gmail from word-wrapping my patch by going through
Thunderbird, but looks like the SMTP server still took care of that (or
something).  Trying with a different server now...


From: Dylan R Semler <dylan.semler@gmail.com>

The new iMON LCDs from SoundGraph need to be blacklisted from HID in order to be
used by lirc. This patch adds vendor and device IDs for iMON LCDs and adds them
to the blacklist.

Signed-off-by: Dylan R Semler dylan.semler@gmail.com
---
--- vanilla-2.6.25/drivers/hid/usbhid/hid-quirks.c.orig 2008-05-10 14:22:19.000000000 -0500
+++ vanilla-2.6.25/drivers/hid/usbhid/hid-quirks.c 2008-05-10 14:20:37.000000000 -0500
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
+ { USB_VENDOR_ID_SOUNDGRAPH, USB_DEVICE_ID_SOUNDGRAPH_IMON_LCD, HID_QUIRK_IGNORE },
{ USB_VENDOR_ID_VERNIER, USB_DEVICE_ID_VERNIER_LABPRO, HID_QUIRK_IGNORE },
{ USB_VENDOR_ID_VERNIER, USB_DEVICE_ID_VERNIER_GOTEMP, HID_QUIRK_IGNORE },
{ USB_VENDOR_ID_VERNIER, USB_DEVICE_ID_VERNIER_SKIP, HID_QUIRK_IGNORE },

