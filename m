Return-Path: <linux-kernel-owner+w=401wt.eu-S1752312AbZETCSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbZETCSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 22:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbZETCR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 22:17:59 -0400
Received: from netrider.rowland.org ([192.131.102.5]:45130 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750879AbZETCR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 22:17:58 -0400
Date: Tue, 19 May 2009 22:17:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Mario Limonciello <mario_limonciello@dell.com>,
       <linux-usb@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Marcel Holtmann <marcel@holtmann.org>, <linux-acpi@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Explicitly disable BT radio using rfkill interface on
 suspend
In-Reply-To: <200905200016.49110.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0905192212560.7309-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 May 2009, Oliver Neukum wrote:

> Am Dienstag, 19. Mai 2009 23:47:02 schrieb Mario Limonciello:
> > Hi Oliver:
> 
> > Attached are both the lsusb listings.  As you can see, the missing
> > device post-suspend is that Bluetooth radio device (which is why I
> > proposed this patch in the first place).
> 
> This explains the error in your log.
> 
> > There is a udev removal event for this device, but as I said, there are
> > no add/remove/change events for the keyboard or mouse devices.  I'm
> > attaching udevadm monitor ran from right before the suspend to right after.
> 
> That is correct the devices have been successfully resumed and thus are
> present. Generally the idea of suspened/resume is to have the same system
> after resumption. It is correct to not generate events. Usbcore cannot know
> that you use udev to switch the device from pure HID to HID + bluetooth.
> 
> > Sending the appropriate hid report to the mouse device will re-attach
> > this Bluetooth radio device to the bus.
> 
> Yes, the question is whether it is the clean thing to do.
> 
> Marcel, are the HID devices usable after hid2hci has run? Should we
> choose to not resume from power loss any hid device which hid2hci
> operated on?

I'd like to know why the device switches back from HID+bluetooth to
pure HID during a suspend-resume sequence.  Does it undergo a
reset-resume?

Here's another question: Since there is a udev removal event for the 
radio device, why not add a udev rule to switch back to HID+bluetooth 
mode every time that event occurs?

Alan Stern

