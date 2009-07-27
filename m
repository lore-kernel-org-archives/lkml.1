Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbZG0WRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbZG0WRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbZG0WRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:17:20 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:47957 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300AbZG0WRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:17:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=L4A7dsY6kAnE+ZMxZbuKo8lIWBkHRayeNWeVUOMg5n1HXO/4ODhhADhJYlh4pUA9aj
         A7wcSxZFj/oFKa05UxZdKsO10DS7ks0pdi5Mt8y6ALGbMC7RSixaCH4TEHFNRdAD653d
         sEcA5CbX4lv62/xf/+G+B+PqyVyTj6vXYek5A=
MIME-Version: 1.0
Date: Mon, 27 Jul 2009 23:17:17 +0100
Message-ID: <6278d2220907271517u46894cbu69ae52148664e04e@mail.gmail.com>
Subject: [2.6.31-rc4] ftdi_usb maps memory from stack...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux USB <linux-usb-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With DMA debugging enabled, I see a warning when the FTDI USB-serial
driver loads [1] using a non-DMAable address.

I can get a disassembly of some of the stack frames to identify the
exact call-sites etc, if that helps anyone?

Thanks,
  Daniel

--- [1]

usbcore: registered new interface driver usbserial_generic

usbserial: USB Serial Driver core

USB Serial support registered for FTDI USB Serial Device

ftdi_sio 5-1:1.0: FTDI USB Serial Device converter detected

usb 5-1: Detected FT8U232AM

usb 5-1: Number of endpoints 2

usb 5-1: Endpoint 1 MaxPacketSize 64

usb 5-1: Endpoint 2 MaxPacketSize 64

usb 5-1: Setting MaxPacketSize 64

------------[ cut here ]------------

WARNING: at lib/dma-debug.c:856 check_for_stack+0x9a/0xc0()

Hardware name: OEM

uhci_hcd 0000:00:1d.0: DMA-API: device driver maps memory from stack
[addr=ffff88007f89b946]

Modules linked in:

Pid: 1, comm: swapper Not tainted 2.6.31-rc4-274sd #1

Call Trace:

 [<ffffffff8124796a>] ? check_for_stack+0x9a/0xc0

 [<ffffffff810490f8>] warn_slowpath_common+0x78/0xd0

 [<ffffffff810491d4>] warn_slowpath_fmt+0x64/0x70

 [<ffffffff81430379>] ? error_exit+0x29/0xb0

 [<ffffffff812afa61>] ? dev_driver_string+0x1/0x40

 [<ffffffff8124796a>] check_for_stack+0x9a/0xc0

 [<ffffffff812490ff>] debug_dma_map_page+0xef/0x160

 [<ffffffff81314e21>] usb_hcd_submit_urb+0x361/0xc90

 [<ffffffff8142f23d>] ? trace_hardirqs_off_thunk+0x3a/0x3c

 [<ffffffff81430379>] ? error_exit+0x29/0xb0

 [<ffffffff81315b65>] usb_submit_urb+0xd5/0x260

 [<ffffffff81317403>] usb_start_wait_urb+0x63/0xf0

 [<ffffffff81317720>] usb_control_msg+0x130/0x160

 [<ffffffff81339c2a>] ftdi_sio_port_probe+0x3ea/0x7f0

 [<ffffffff81336255>] usb_serial_device_probe+0x75/0x110

 [<ffffffff812b3ad5>] driver_probe_device+0x95/0x1a0

 [<ffffffff812b3c80>] ? __device_attach+0x0/0x50

 [<ffffffff812b3ccb>] __device_attach+0x4b/0x50

 [<ffffffff812b2ebb>] bus_for_each_drv+0x6b/0xa0

 [<ffffffff812b3d98>] device_attach+0x88/0x90

 [<ffffffff812b2c95>] bus_attach_device+0x55/0x80

 [<ffffffff812b126a>] device_add+0x42a/0x670

 [<ffffffff812b14c9>] device_register+0x19/0x20

 [<ffffffff813340f4>] usb_serial_probe+0x1274/0x1550

 [<ffffffff8102f992>] ? kmemcheck_fault+0x72/0x90

 [<ffffffff8142f23d>] ? trace_hardirqs_off_thunk+0x3a/0x3c

 [<ffffffff81430379>] ? error_exit+0x29/0xb0

 [<ffffffff8131a182>] usb_probe_interface+0xc2/0x1a0

 [<ffffffff812b3ad5>] driver_probe_device+0x95/0x1a0

 [<ffffffff812b3c73>] __driver_attach+0x93/0xa0

 [<ffffffff812b3be0>] ? __driver_attach+0x0/0xa0

 [<ffffffff812b325b>] bus_for_each_dev+0x6b/0xa0

 [<ffffffff812b392c>] driver_attach+0x1c/0x20

 [<ffffffff812b2ae8>] bus_add_driver+0x248/0x2b0

 [<ffffffff812b3f7c>] driver_register+0x7c/0x170

 [<ffffffff81319ede>] usb_register_driver+0xce/0x140

 [<ffffffff81676660>] ? ftdi_init+0x0/0xe2

 [<ffffffff8167671e>] ftdi_init+0xbe/0xe2

 [<ffffffff8100905b>] do_one_initcall+0x4b/0x1a0

 [<ffffffff81654525>] kernel_init+0x1b2/0x236

 [<ffffffff8100ce9a>] child_rip+0xa/0x20

 [<ffffffff8100c83c>] ? restore_args+0x0/0x30

 [<ffffffff81654373>] ? kernel_init+0x0/0x236

 [<ffffffff8100ce90>] ? child_rip+0x0/0x20

---[ end trace 8ecb5c2eb0ae54d6 ]---

usb 5-1: FTDI USB Serial Device converter now attached to ttyUSB0

usbcore: registered new interface driver ftdi_sio

ftdi_sio: v1.5.0:USB FTDI Serial Converters Driver

-- 
Daniel J Blueman
