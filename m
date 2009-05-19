Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbZESWQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbZESWQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 18:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbZESWQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 18:16:30 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:50327 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbZESWQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 18:16:29 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Mario Limonciello <mario_limonciello@dell.com>, linux-usb@vger.kernel.org
Subject: Re: [PATCH] Explicitly disable BT radio using rfkill interface on suspend
Date: Wed, 20 May 2009 00:16:48 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Marcel Holtmann <marcel@holtmann.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <4A11C126.1000704@dell.com> <200905192326.46274.oliver@neukum.org> <4A1328D6.5090404@dell.com>
In-Reply-To: <4A1328D6.5090404@dell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905200016.49110.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 19. Mai 2009 23:47:02 schrieb Mario Limonciello:
> Hi Oliver:

> Attached are both the lsusb listings.  As you can see, the missing
> device post-suspend is that Bluetooth radio device (which is why I
> proposed this patch in the first place).

This explains the error in your log.

> There is a udev removal event for this device, but as I said, there are
> no add/remove/change events for the keyboard or mouse devices.  I'm
> attaching udevadm monitor ran from right before the suspend to right after.

That is correct the devices have been successfully resumed and thus are
present. Generally the idea of suspened/resume is to have the same system
after resumption. It is correct to not generate events. Usbcore cannot know
that you use udev to switch the device from pure HID to HID + bluetooth.

> Sending the appropriate hid report to the mouse device will re-attach
> this Bluetooth radio device to the bus.

Yes, the question is whether it is the clean thing to do.

Marcel, are the HID devices usable after hid2hci has run? Should we
choose to not resume from power loss any hid device which hid2hci
operated on?

	Regards
		Oliver

