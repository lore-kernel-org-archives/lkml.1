Return-Path: <linux-kernel-owner+w=401wt.eu-S1760887AbYHUVU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887AbYHUVU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760246AbYHUVUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:20:45 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49977 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751923AbYHUVUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:20:44 -0400
Date: Thu, 21 Aug 2008 17:20:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: amruth <amruth_pv@yahoo.com>
cc: Oliver Neukum <oliver@neukum.org>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: USB Serial device disconnect causes IRQ disable details captured
In-Reply-To: <318135.65419.qm@web45201.mail.sp1.yahoo.com>
Message-ID: <Pine.LNX.4.44L0.0808211712530.17334-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2008, amruth wrote:

> Hi
> Oliver
> I got the same issue once again. I have captured detail log and lusb -t with interrupts.
> cat /proc/interrupts:

> dmesg:
> sb 1-5: Magtek 75/Excella USB card reader converter now attached to ttyUSB1
> drivers/usb/core/inode.c: creating file '012'
> usb 1-5: New USB device found, idVendor=0801, idProduct=2231
> usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 1-5: Product: STX
> usb 1-5: Manufacturer: MagTek
> usb 1-5: SerialNumber: STX001
> usb 2-2: uhci_result_common: failed with status 440000
> /home/amr/linux-2.6.26/drivers/usb/serial/magtek.c: magtek_read_int_callback - p
> ort 0
> uhci_hcd 0000:00:1d.0: release dev 6 ep81-INT, period 8, phase 4, 61 us
> hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
> uhci_hcd 0000:00:1d.0: port 2 portsc 008a,00
> hub 2-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
> usb 2-2: USB disconnect, address 6
> usb 2-2: unregistering device
> usb 2-2: usb_disable_device nuking all URBs
> usb 2-2: unregistering interface 2-2:1.0
> /home/amr/linux-2.6.26/drivers/usb/serial/magtek.c: magtek_shutdown
> magtek ttyUSB0: Magtek 75/Excella USB card reader converter now disconnected from ttyUSB0
> magtek 2-2:1.0: device disconnected
> usb 2-2:1.0: uevent
> usb 2-2: uevent
> hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
> usb usb2: suspend_rh (auto-stop)
> ehci_hcd 0000:00:1d.7: devpath 5 ep2in 3strikes
> /home/amr/linux-2.6.26/drivers/usb/serial/magtek.c: magtek_read_int_callback - port 1
> usb 1-5: unlink qh0-00ff/dec56380 start 0 [1/0 us]
> usb 1-5: link qh0-00ff/dec56380 start 0 [1/0 us]
> usb 1-5: unlink qh0-00ff/dec56380 start 0 [1/0 us]
> ehci_hcd 0000:00:1d.7: HC died; cleaning up

You should try using the patch in this message:

	http://marc.info/?l=linux-usb&m=121848784300960&w=2

If that doesn't help, can you test this on another computer to see if
the same thing happens?

For future testing, it would help if you enable CONFIG_PRINTK_TIME.

Alan Stern

