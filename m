Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbZBTMPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbZBTMPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 07:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbZBTMPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 07:15:07 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:43514 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbZBTMPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 07:15:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=clmG1chasDKNQibN2uUml+nQ+OBxY+ecoPzNepc5aQqgIpgUKcVPScpp8+D4yUVpg7
         6nsmGizXfI/8kOqjHOvDFqhdSONfEwcMHJnypnJmkumlTa+HmPVMfEmx8aKKpCmDn3jH
         Vsr5Vh6xRhfuQ6CSf/iohFsfLw7zlxHTyDABE=
MIME-Version: 1.0
Date: Fri, 20 Feb 2009 17:45:04 +0530
Message-ID: <cf70f0210902200415k5326f593nae55b53b83802797@mail.gmail.com>
Subject: Kernel Warning/crash using usb-serial device
From: Shivdas Gujare <shivdas.tech@gmail.com>
To: beagleboard@googlegroups.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Currently I am testing USB serial device with BeagleBoard(omap3) which
uses musb host controller. But I gets following Warnings every time
if I tries to open the /dev/ttyUSB0 using simple application which I
have written to open/read and write.

FYI, I currently tested with 2.6.29-rc5 and also 2.6.29-rc2, with no success.

What could be the possible reason? Is there any way, I can avoid this warning?
Thanks for your valuable help.

Regards,
Shivdas


------------[ cut here ]------------
WARNING: at kernel/mutex.c:135 __mutex_lock_slowpath+0x6c/0x234()
Modules linked in: usbserial
[<c029d188>] (dump_stack+0x0/0x14) from [<c00516b4>] (warn_slowpath+0x68/0x9c)
[<c005164c>] (warn_slowpath+0x0/0x9c) from [<c029e0d0>]
(__mutex_lock_slowpath+0x6c/0x234)
 r3:c039437c r2:00000000
 r7:c787e9c0 r6:c7bc6c00 r5:c7bc6fb4 r4:c7bc6c00
[<c029e064>] (__mutex_lock_slowpath+0x0/0x234) from [<c029e2a8>]
(mutex_lock+0x10/0x14)
[<c029e298>] (mutex_lock+0x0/0x14) from [<c01a0d10>]
(echo_set_canon_col+0x1c/0x40)
[<c01a0cf4>] (echo_set_canon_col+0x0/0x40) from [<c01a2bcc>]
(n_tty_receive_buf+0xbdc/0x1074)
 r5:00000000 r4:000000fe
[<c01a1ff0>] (n_tty_receive_buf+0x0/0x1074) from [<c01a513c>]
(flush_to_ldisc+0xf0/0x184)
[<c01a504c>] (flush_to_ldisc+0x0/0x184) from [<c01a520c>]
(tty_flip_buffer_push+0x3c/0x4c)
[<c01a51d0>] (tty_flip_buffer_push+0x0/0x4c) from [<bf0028b8>]
(usb_serial_generic_read_bulk_callback+0x12c/0x170 [usbserial])
[<bf00278c>] (usb_serial_generic_read_bulk_callback+0x0/0x170
[usbserial]) from [<c01e60b8>] (usb_hcd_giveback_urb+0xb0/0xfc)
 r8:c78d88d8 r7:00000000 r6:c78d8800 r5:00000000 r4:c7851440
[<c01e6008>] (usb_hcd_giveback_urb+0x0/0xfc) from [<c01f8148>]
(__musb_giveback+0xf4/0x110)
 r6:00000080 r5:c795c760 r4:c78d8800
[<c01f8054>] (__musb_giveback+0x0/0x110) from [<c01f825c>]
(musb_giveback+0xf8/0x1e0)
[<c01f8164>] (musb_giveback+0x0/0x1e0) from [<c01f8388>]
(musb_advance_schedule+0x44/0xcc)
[<c01f8344>] (musb_advance_schedule+0x0/0xcc) from [<c01f9814>]
(musb_host_rx+0x890/0x8fc)
 r7:00000001 r6:00000001 r5:0000a203 r4:00000000
[<c01f8f84>] (musb_host_rx+0x0/0x8fc) from [<c01f5f3c>]
(musb_dma_completion+0x54/0x58)
[<c01f5ee8>] (musb_dma_completion+0x0/0x58) from [<c01fa2b8>]
(dma_controller_irq+0x158/0x1a4)
[<c01fa160>] (dma_controller_irq+0x0/0x1a4) from [<c0077a64>]
(handle_IRQ_event+0x3c/0x74)
[<c0077a28>] (handle_IRQ_event+0x0/0x74) from [<c0078e78>]
(handle_level_irq+0x94/0xec)
 r7:0000005c r6:00000000 r5:0000005d r4:c036ceb0
[<c0078de4>] (handle_level_irq+0x0/0xec) from [<c002c058>]
(__exception_text_start+0x58/0x70)
 r5:c7973e20 r4:0000005d
[<c002c000>] (__exception_text_start+0x0/0x70) from [<c002ca30>]
(__irq_svc+0x30/0x80)
Exception stack(0xc7973d70 to 0xc7973db8)
3d60:                                     00000001 00000000 0000021c 00000000
3d80: 40000113 00000000 00000000 0000005c 40069000 c7058000 00000200 c7973dcc
3da0: 00000214 c7973db8 c01fa140 c01f67e8 60000113 ffffffff
 r5:d8200000 r4:ffffffff
[<c01f6780>] (generic_interrupt+0x0/0xa4) from [<c0077a64>]
(handle_IRQ_event+0x3c/0x74)
 r4:c7925de0
[<c0077a28>] (handle_IRQ_event+0x0/0x74) from [<c0078e78>]
(handle_level_irq+0x94/0xec)
 r7:c7055968 r6:c787e9c0 r5:0000005c r4:c036ce74
[<c0078de4>] (handle_level_irq+0x0/0xec) from [<c002c058>]
(__exception_text_start+0x58/0x70)
 r5:00000000 r4:0000005c
[<c002c000>] (__exception_text_start+0x0/0x70) from [<c002ca30>]
(__irq_svc+0x30/0x80)
Exception stack(0xc7973e20 to 0xc7973e68)
3e20: c7959ae0 000001a4 c70f1800 c0371978 00000069 00000000 c787e9c0 c7055968
3e40: 40069000 c7058000 00000200 c7973ebc c7059000 c7973e68 c0032d24 c008e01c
3e60: 60000113 ffffffff
 r5:d8200000 r4:ffffffff
[<c008df50>] (handle_mm_fault+0x0/0x5c4) from [<c0032d24>]
(do_page_fault+0xe8/0x24c)
[<c0032c3c>] (do_page_fault+0x0/0x24c) from [<c0032f2c>]
(do_translation_fault+0x18/0x7c)
[<c0032f14>] (do_translation_fault+0x0/0x7c) from [<c002c1b4>]
(do_PrefetchAbort+0x18/0x1c)
 r7:00000000 r6:00000000 r5:00000000 r4:ffffffff
[<c002c19c>] (do_PrefetchAbort+0x0/0x1c) from [<c002cd80>]
(ret_from_exception+0x0/0x10)
Exception stack(0xc7973fb0 to 0xc7973ff8)
3fa0:                                     0000983c bea0df20 00000003 0000983c
3fc0: 40023e08 00000000 00000000 00000000 00000000 00000000 40024000 bea0dcd4
3fe0: 40069518 bea0dbb0 000093e0 40069518 60000010 ffffffff
---[ end trace b3b574d010a6d594 ]---
Connected to /dev/ttyUSB0
Serial speed set to 115200.
