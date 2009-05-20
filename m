Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbZETM26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbZETM26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 08:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755789AbZETM2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 08:28:48 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:48788 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbZETM2r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 08:28:47 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Explicitly disable BT radio using rfkill interface on suspend
Date: Wed, 20 May 2009 14:29:04 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Mario Limonciello <mario_limonciello@dell.com>, linux-usb@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Marcel Holtmann <marcel@holtmann.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0905192212560.7309-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0905192212560.7309-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905201429.06113.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 20. Mai 2009 04:17:59 schrieb Alan Stern:
> On Wed, 20 May 2009, Oliver Neukum wrote:

> > Marcel, are the HID devices usable after hid2hci has run? Should we
> > choose to not resume from power loss any hid device which hid2hci
> > operated on?
>
> I'd like to know why the device switches back from HID+bluetooth to
> pure HID during a suspend-resume sequence.  Does it undergo a
> reset-resume?

Yes.

[  111.356035] usb 2-3: reset high speed USB device using ehci_hcd and address 2
[  111.668045] usb 3-4: reset full speed USB device using ohci_hcd and address 2
[  112.177152] usb 3-4.1: reset full speed USB device using ohci_hcd and address 3
[  112.361151] usb 3-4.2: reset full speed USB device using ohci_hcd and address 4
[  112.471157] pm_op(): usb_dev_resume+0x0/0x10 returns -19
[  112.471160] PM: Device 3-4.3 failed to resume: error -19
[  112.471373] PM: resume devices took 3.256 seconds
[  112.471980] PM: Finishing wakeup.
[  112.471982] Restarting tasks ... <6>usb 3-4.3: USB disconnect, address 5
[  112.504314] btusb_send_frame: hci0 urb f4520700 submission failed
>
> Here's another question: Since there is a udev removal event for the
> radio device, why not add a udev rule to switch back to HID+bluetooth
> mode every time that event occurs?

1. You'd have two rules doing the same thing (resume & addition)
2. It is unclean, as the removal event doesn't tell you which device to run
hid2hci on
3. The device might really be physically removed
4. You can intentionally run hid2hci to switch back to HID

	Regards
		Oliver

PS: Why, oh why don't people use configurations as they were designed?

