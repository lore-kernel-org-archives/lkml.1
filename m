Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbYKLUh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbYKLUh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 15:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYKLUht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 15:37:49 -0500
Received: from gv-out-0910.google.com ([216.239.58.185]:26972 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbYKLUhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 15:37:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=wrzvvDtKecb8dTl4xRf+Ay8lHge69B1KmX61rcE9kaIgqKKZgaF+nHxVf69dSLjNQ/
         BYFYobKzqtWBk1sU/KSnhJOeSqd+/2Kx2IoBBCS5HDtWvaThOb26+k/1G2Dz0rIRcNNl
         G2bqITF01MCAYGO6vXG3I7rXv/EGUK1UavsnQ=
Message-ID: <491B3E90.5020307@gmail.com>
Date: Wed, 12 Nov 2008 21:37:36 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Alexey Klimov <klimov.linux@gmail.com>
CC: Tobias Lorenz <tobias.lorenz@gmx.net>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: next: 6a13378a5 (Don't allow KWorld radio...) is broken
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

The commit below is apparently wrong. Maybe you CCed HID maintainer, however
linux-input didn't get the message, or at least I can't find it anywhere.

There is a difference between hid_blacklist and hid_ignore_list. One forbids
generic hid driver to bind the device, while the other forces usbhid to release
the device and move hands away from it.

You picked up the former, which is wrong. I wonder if you were so lucky that you
didn't hit it. Care to send a fixup with proper CCs?

Thanks.

commit 6a13378a56ce06afca9db75f3d4e663fba5f0992
Author: Alexey Klimov <klimov.linux@gmail.com>
Date:   Sun Oct 19 20:10:13 2008 -0300

    V4L/DVB (9337a): HID: Don't allow KWorld radio fm700 be handled by usb hid d
rivers

    This device is already handled by radio-si470x driver, and we
    therefore want usbhid to ignore it.

    Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
    Acked-by: Tobias Lorenz <tobias.lorenz@gmx.net>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 1903e75..d3671b4 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1265,6 +1265,7 @@ static const struct hid_device_id hid_blacklist[] = {
        { HID_USB_DEVICE(USB_VENDOR_ID_EZKEY, USB_DEVICE_ID_BTC_8193) },
        { HID_USB_DEVICE(USB_VENDOR_ID_GENERIC_13BA, USB_DEVICE_ID_GENERIC_13BA_
KBD_MOUSE) },
        { HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE)
},
+       { HID_USB_DEVICE(USB_VENDOR_ID_KWORLD, USB_DEVICE_ID_KWORLD_RADIO_FM700)
 },
        { HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE_2
) },
        { HID_USB_DEVICE(USB_VENDOR_ID_LABTEC, USB_DEVICE_ID_LABTEC_WIRELESS_KEY
BOARD) },
        { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER)
},

