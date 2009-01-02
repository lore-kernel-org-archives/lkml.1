Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbZABIm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbZABIm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 03:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbZABImt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 03:42:49 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:55206 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbZABImr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 03:42:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=rKBhIEgkHF46dvJWIJYwrsCRUAO4AVFZU0wXRZwIpd0dmF8Ad+jPbLecgekqq9GNGI
         pVDBe8RDHsPJfMlONr1Oe6xie0dLPr7iR8qRgxx9+0nz43djnPbe5K9wvu9fzCceZMoN
         4ZeUyPCixtQc46Rq+1yXHcsVh2d3sIp1YHWdg=
Message-ID: <dd0bb5c00901020042w6b44e17fu3a4bb46cc4ff7b2e@mail.gmail.com>
Date: Fri, 2 Jan 2009 19:42:43 +1100
From: "Daryl Radivojevic" <daryl.rad@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: OOPS report
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is an OOPS report. This happens frequently. Mainly if I start
wvdial from xterm, and then quit X-Windows.

Hardware used: Basic Thinkpad T-400, Huawei E160G USB Mobile broadband key.

dmesg output:

>hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
usb usb8: usb auto-resume
usb usb8: wakeup_rh
hub 8-0:1.0: hub_resume
hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb7: usb auto-resume
usb usb7: wakeup_rh
hub 7-0:1.0: hub_resume
hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb6: usb auto-resume
usb usb6: wakeup_rh
hub 6-0:1.0: hub_resume
hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb5: usb auto-resume
usb usb5: wakeup_rh
hub 5-0:1.0: hub_resume
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb3: usb auto-resume
usb usb3: wakeup_rh
hub 3-0:1.0: hub_resume
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb4: usb auto-resume
usb usb4: wakeup_rh
hub 4-0:1.0: hub_resume
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb8: suspend_rh (auto-stop)
usb usb7: suspend_rh (auto-stop)
usb usb6: suspend_rh (auto-stop)
usb usb5: suspend_rh (auto-stop)
usb usb3: suspend_rh (auto-stop)
usb usb4: suspend_rh (auto-stop)
hub 2-0:1.0: hub_suspend
usb usb2: bus auto-suspend
ehci_hcd 0000:00:1d.7: suspend root hub
hub 8-0:1.0: hub_suspend
usb usb8: bus auto-suspend
usb usb8: suspend_rh
hub 7-0:1.0: hub_suspend
usb usb7: bus auto-suspend
usb usb7: suspend_rh
hub 6-0:1.0: hub_suspend
usb usb6: bus auto-suspend
usb usb6: suspend_rh
hub 5-0:1.0: hub_suspend
usb usb5: bus auto-suspend
usb usb5: suspend_rh
hub 3-0:1.0: hub_suspend
usb usb3: bus auto-suspend
usb usb3: suspend_rh
hub 4-0:1.0: hub_suspend
usb usb4: bus auto-suspend
usb usb4: suspend_rh
PPP BSD Compression module registered
PPP Deflate Compression module registered
mtrr: no MTRR for d0000000,10000000 found
------------[ cut here ]------------
WARNING: at drivers/usb/serial/usb-serial.c:326
serial_write_room+0x44/0x54 [usbserial]()
Modules linked in: ppp_deflate zlib_deflate zlib_inflate bsd_comp
ppp_async crc_ccitt uinput option usbserial sg pcspkr i2c_i801 sr_mod
pcmcia 8250_pci 8250 video serial_core output evdev
Pid: 0, comm: swapper Not tainted 2.6.28 #5
Call Trace:
 [<c01205f1>] warn_on_slowpath+0x40/0x61
 [<c028cce3>] ehci_urb_enqueue+0xe8/0xd3a
 [<c028cd31>] ehci_urb_enqueue+0x136/0xd3a
 [<f8b55455>] serial_write_room+0x44/0x54 [usbserial]
 [<c020ab2c>] tty_write_room+0x15/0x16
 [<c0208fde>] opost+0xf/0x1ae
 [<c020a67b>] n_tty_receive_buf+0x8cc/0xca6
 [<c027e9d1>] usb_hcd_submit_urb+0x7ca/0x84f
 [<c011a866>] enqueue_task_fair+0x131/0x17a
 [<c0116cdb>] activate_task+0x20/0x2f
 [<c011b09e>] try_to_wake_up+0x180/0x18a
 [<c020c2d4>] flush_to_ldisc+0xf7/0x193
 [<f8b74b26>] option_indat_callback+0x8e/0xe8 [option]
 [<c027d84f>] usb_hcd_giveback_urb+0x4b/0x76
 [<c028916c>] ehci_urb_done+0xcd/0xd9
 [<c0289b9a>] qh_completions+0xa8/0x464
 [<c0127a1a>] __mod_timer+0xba/0xc3
 [<c0289ff7>] ehci_work+0xa1/0x7c4
 [<c028f500>] ehci_irq+0x2bf/0x2e3
 [<c01321cd>] hrtimer_interrupt+0x13a/0x162
 [<c01365c9>] tick_do_broadcast+0x30/0x54
 [<c0136698>] tick_handle_oneshot_broadcast+0xab/0xdf
 [<c027d4c5>] usb_hcd_irq+0x24/0x59
 [<c013e672>] handle_IRQ_event+0x1a/0x3f
 [<c013f68f>] handle_fasteoi_irq+0x6a/0x9b
 [<c013f625>] handle_fasteoi_irq+0x0/0x9b
 <IRQ>  [<c010376b>] common_interrupt+0x23/0x28
 [<c013007b>] set_process_cpu_timer+0x81/0xa5
 [<c01fd12c>] acpi_idle_enter_bm+0x2d6/0x355
 [<c02a8eee>] cpuidle_idle_call+0x5d/0x8f
 [<c0101da8>] cpu_idle+0x68/0x84
---[ end trace 945550a66a3e3b5c ]---
------------[ cut here ]------------
WARNING: at drivers/usb/serial/usb-serial.c:313 serial_write+0x5e/0x7a
[usbserial]()
Modules linked in: ppp_deflate zlib_deflate zlib_inflate bsd_comp
ppp_async crc_ccitt uinput option usbserial sg pcspkr i2c_i801 sr_mod
pcmcia 8250_pci 8250 video serial_core output evdev
Pid: 0, comm: swapper Tainted: G        W  2.6.28 #5
Call Trace:
 [<c01205f1>] warn_on_slowpath+0x40/0x61
 [<c028cce3>] ehci_urb_enqueue+0xe8/0xd3a
 [<c028cd31>] ehci_urb_enqueue+0x136/0xd3a
 [<f8b554c3>] serial_write+0x5e/0x7a [usbserial]
 [<c02063e5>] tty_put_char+0x22/0x25
 [<c0209053>] opost+0x84/0x1ae
 [<c020a67b>] n_tty_receive_buf+0x8cc/0xca6
 [<c027e9d1>] usb_hcd_submit_urb+0x7ca/0x84f
 [<c011a866>] enqueue_task_fair+0x131/0x17a
 [<c0116cdb>] activate_task+0x20/0x2f
 [<c011b09e>] try_to_wake_up+0x180/0x18a
 [<c020c2d4>] flush_to_ldisc+0xf7/0x193
 [<f8b74b26>] option_indat_callback+0x8e/0xe8 [option]
 [<c027d84f>] usb_hcd_giveback_urb+0x4b/0x76
 [<c028916c>] ehci_urb_done+0xcd/0xd9
 [<c0289b9a>] qh_completions+0xa8/0x464
 [<c0127a1a>] __mod_timer+0xba/0xc3
 [<c0289ff7>] ehci_work+0xa1/0x7c4
 [<c028f500>] ehci_irq+0x2bf/0x2e3
 [<c01321cd>] hrtimer_interrupt+0x13a/0x162
 [<c01365c9>] tick_do_broadcast+0x30/0x54
 [<c0136698>] tick_handle_oneshot_broadcast+0xab/0xdf
 [<c027d4c5>] usb_hcd_irq+0x24/0x59
 [<c013e672>] handle_IRQ_event+0x1a/0x3f
 [<c013f68f>] handle_fasteoi_irq+0x6a/0x9b
 [<c013f625>] handle_fasteoi_irq+0x0/0x9b
 <IRQ>  [<c010376b>] common_interrupt+0x23/0x28
 [<c013007b>] set_process_cpu_timer+0x81/0xa5
 [<c01fd12c>] acpi_idle_enter_bm+0x2d6/0x355
 [<c02a8eee>] cpuidle_idle_call+0x5d/0x8f
 [<c0101da8>] cpu_idle+0x68/0x84
---[ end trace 945550a66a3e3b5c ]---
------------[ cut here ]------------
WARNING: at drivers/usb/serial/usb-serial.c:313 serial_write+0x5e/0x7a
[usbserial]()
Modules linked in: ppp_deflate zlib_deflate zlib_inflate bsd_comp
ppp_async crc_ccitt uinput option usbserial sg pcspkr i2c_i801 sr_mod
pcmcia 8250_pci 8250 video serial_core output evdev
Pid: 0, comm: swapper Tainted: G        W  2.6.28 #5
Call Trace:
 [<c01205f1>] warn_on_slowpath+0x40/0x61
 [<f8b744e9>] option_write+0x124/0x1ac [option]
 [<f8b554c3>] serial_write+0x5e/0x7a [usbserial]
 [<c02063e5>] tty_put_char+0x22/0x25
 [<c0209169>] opost+0x19a/0x1ae
 [<c020a67b>] n_tty_receive_buf+0x8cc/0xca6
 [<c027e9d1>] usb_hcd_submit_urb+0x7ca/0x84f
 [<c011a866>] enqueue_task_fair+0x131/0x17a
 [<c0116cdb>] activate_task+0x20/0x2f
 [<c011b09e>] try_to_wake_up+0x180/0x18a
 [<c020c2d4>] flush_to_ldisc+0xf7/0x193
 [<f8b74b26>] option_indat_callback+0x8e/0xe8 [option]
 [<c027d84f>] usb_hcd_giveback_urb+0x4b/0x76
 [<c028916c>] ehci_urb_done+0xcd/0xd9
 [<c0289b9a>] qh_completions+0xa8/0x464
 [<c0127a1a>] __mod_timer+0xba/0xc3
 [<c0289ff7>] ehci_work+0xa1/0x7c4
 [<c028f500>] ehci_irq+0x2bf/0x2e3
 [<c01321cd>] hrtimer_interrupt+0x13a/0x162
 [<c01365c9>] tick_do_broadcast+0x30/0x54
 [<c0136698>] tick_handle_oneshot_broadcast+0xab/0xdf
 [<c027d4c5>] usb_hcd_irq+0x24/0x59
 [<c013e672>] handle_IRQ_event+0x1a/0x3f
 [<c013f68f>] handle_fasteoi_irq+0x6a/0x9b
 [<c013f625>] handle_fasteoi_irq+0x0/0x9b
 <IRQ>  [<c010376b>] common_interrupt+0x23/0x28
 [<c013007b>] set_process_cpu_timer+0x81/0xa5
 [<c01fd12c>] acpi_idle_enter_bm+0x2d6/0x355
 [<c02a8eee>] cpuidle_idle_call+0x5d/0x8f
 [<c0101da8>] cpu_idle+0x68/0x84
---[ end trace 945550a66a3e3b5c ]---
------------[ cut here ]------------
WARNING: at drivers/usb/serial/usb-serial.c:326
serial_write_room+0x44/0x54 [usbserial]()
Modules linked in: ppp_deflate zlib_deflate zlib_inflate bsd_comp
ppp_async crc_ccitt uinput option usbserial sg pcspkr i2c_i801 sr_mod
pcmcia 8250_pci 8250 video serial_core output evdev
Pid: 0, comm: swapper Tainted: G        W  2.6.28 #5
Call Trace:
 [<c01205f1>] warn_on_slowpath+0x40/0x61
 [<f8b744e9>] option_write+0x124/0x1ac [option]
 [<f8b554d4>] serial_write+0x6f/0x7a [usbserial]
 [<f8b55455>] serial_write_room+0x44/0x54 [usbserial]
 [<c020ab2c>] tty_write_room+0x15/0x16
 [<c0208fde>] opost+0xf/0x1ae
 [<c020a67b>] n_tty_receive_buf+0x8cc/0xca6
 [<c027e9d1>] usb_hcd_submit_urb+0x7ca/0x84f
 [<c011a866>] enqueue_task_fair+0x131/0x17a
 [<c0116cdb>] activate_task+0x20/0x2f
 [<c011b09e>] try_to_wake_up+0x180/0x18a
 [<c020c2d4>] flush_to_ldisc+0xf7/0x193
 [<f8b74b26>] option_indat_callback+0x8e/0xe8 [option]
 [<c027d84f>] usb_hcd_giveback_urb+0x4b/0x76
 [<c028916c>] ehci_urb_done+0xcd/0xd9
 [<c0289b9a>] qh_completions+0xa8/0x464
 [<c0127a1a>] __mod_timer+0xba/0xc3
 [<c0289ff7>] ehci_work+0xa1/0x7c4
 [<c028f500>] ehci_irq+0x2bf/0x2e3
 [<c01321cd>] hrtimer_interrupt+0x13a/0x162
 [<c01365c9>] tick_do_broadcast+0x30/0x54
 [<c0136698>] tick_handle_oneshot_broadcast+0xab/0xdf
 [<c027d4c5>] usb_hcd_irq+0x24/0x59
 [<c013e672>] handle_IRQ_event+0x1a/0x3f
 [<c013f68f>] handle_fasteoi_irq+0x6a/0x9b
 [<c013f625>] handle_fasteoi_irq+0x0/0x9b
 <IRQ>  [<c010376b>] common_interrupt+0x23/0x28
 [<c013007b>] set_process_cpu_timer+0x81/0xa5
 [<c01fd12c>] acpi_idle_enter_bm+0x2d6/0x355
 [<c02a8eee>] cpuidle_idle_call+0x5d/0x8f
 [<c0101da8>] cpu_idle+0x68/0x84
---[ end trace 945550a66a3e3b5c ]---
------------[ cut here ]------------
WARNING: at drivers/usb/serial/usb-serial.c:326
serial_write_room+0x44/0x54 [usbserial]()
Modules linked in: ppp_deflate zlib_deflate zlib_inflate bsd_comp
ppp_async crc_ccitt uinput option usbserial sg pcspkr i2c_i801 sr_mod
pcmcia 8250_pci 8250 video serial_core output evdev
Pid: 0, comm: swapper Tainted: G        W  2.6.28 #5
Call Trace:
 [<c01205f1>] warn_on_slowpath+0x40/0x61
 [<f8b744e9>] option_write+0x124/0x1ac [option]
 [<f8b554d4>] serial_write+0x6f/0x7a [usbserial]
 [<f8b55455>] serial_write_room+0x44/0x54 [usbserial]
 [<c020ab2c>] tty_write_room+0x15/0x16
 [<c0208fde>] opost+0xf/0x1ae
 [<c020a087>] n_tty_receive_buf+0x2d8/0xca6
 [<c027e9d1>] usb_hcd_submit_urb+0x7ca/0x84f
 [<c011a866>] enqueue_task_fair+0x131/0x17a
 [<c0116cdb>] activate_task+0x20/0x2f
 [<c011b09e>] try_to_wake_up+0x180/0x18a
 [<c020c2d4>] flush_to_ldisc+0xf7/0x193
 [<f8b74b26>] option_indat_callback+0x8e/0xe8 [option]
 [<c027d84f>] usb_hcd_giveback_urb+0x4b/0x76
 [<c028916c>] ehci_urb_done+0xcd/0xd9
 [<c0289b9a>] qh_completions+0xa8/0x464
 [<c0127a1a>] __mod_timer+0xba/0xc3
 [<c0289ff7>] ehci_work+0xa1/0x7c4
 [<c028f500>] ehci_irq+0x2bf/0x2e3
 [<c01321cd>] hrtimer_interrupt+0x13a/0x162
 [<c01365c9>] tick_do_broadcast+0x30/0x54
 [<c0136698>] tick_handle_oneshot_broadcast+0xab/0xdf
 [<c027d4c5>] usb_hcd_irq+0x24/0x59
 [<c013e672>] handle_IRQ_event+0x1a/0x3f
 [<c013f68f>] handle_fasteoi_irq+0x6a/0x9b
 [<c013f625>] handle_fasteoi_irq+0x0/0x9b
 <IRQ>  [<c010376b>] common_interrupt+0x23/0x28
 [<c013007b>] set_process_cpu_timer+0x81/0xa5
 [<c01fd12c>] acpi_idle_enter_bm+0x2d6/0x355
 [<c02a8eee>] cpuidle_idle_call+0x5d/0x8f
 [<c0101da8>] cpu_idle+0x68/0x84
---[ end trace 945550a66a3e3b5c ]---
------------[ cut here ]------------
WARNING: at drivers/usb/serial/usb-serial.c:326
serial_write_room+0x44/0x54 [usbserial]()
Modules linked in: ppp_deflate zlib_deflate zlib_inflate bsd_comp
ppp_async crc_ccitt uinput option usbserial sg pcspkr i2c_i801 sr_mod
pcmcia 8250_pci 8250 video serial_core output evdev
Pid: 0, comm: swapper Tainted: G        W  2.6.28 #5
Call Trace:
 [<c01205f1>] warn_on_slowpath+0x40/0x61
 [<f8b744e9>] option_write+0x124/0x1ac [option]
 [<f8b554d4>] serial_write+0x6f/0x7a [usbserial]
 [<f8b55455>] serial_write_room+0x44/0x54 [usbserial]
 [<c020ab2c>] tty_write_room+0x15/0x16
 [<c0208fde>] opost+0xf/0x1ae
 [<c020a087>] n_tty_receive_buf+0x2d8/0xca6
 [<c027e9d1>] usb_hcd_submit_urb+0x7ca/0x84f
 [<c011a866>] enqueue_task_fair+0x131/0x17a
 [<c0116cdb>] activate_task+0x20/0x2f
 [<c011b09e>] try_to_wake_up+0x180/0x18a
 [<c020c2d4>] flush_to_ldisc+0xf7/0x193
 [<f8b74b26>] option_indat_callback+0x8e/0xe8 [option]
 [<c027d84f>] usb_hcd_giveback_urb+0x4b/0x76
 [<c028916c>] ehci_urb_done+0xcd/0xd9
 [<c0289b9a>] qh_completions+0xa8/0x464
 [<c0127a1a>] __mod_timer+0xba/0xc3
 [<c0289ff7>] ehci_work+0xa1/0x7c4
 [<c028f500>] ehci_irq+0x2bf/0x2e3
 [<c01321cd>] hrtimer_interrupt+0x13a/0x162
 [<c01365c9>] tick_do_broadcast+0x30/0x54
 [<c0136698>] tick_handle_oneshot_broadcast+0xab/0xdf
 [<c027d4c5>] usb_hcd_irq+0x24/0x59
 [<c013e672>] handle_IRQ_event+0x1a/0x3f
 [<c013f68f>] handle_fasteoi_irq+0x6a/0x9b
 [<c013f625>] handle_fasteoi_irq+0x0/0x9b
 <IRQ>  [<c010376b>] common_interrupt+0x23/0x28
 [<c013007b>] set_process_cpu_timer+0x81/0xa5
 [<c01fd12c>] acpi_idle_enter_bm+0x2d6/0x355
 [<c02a8eee>] cpuidle_idle_call+0x5d/0x8f
 [<c0101da8>] cpu_idle+0x68/0x84
---[ end trace 945550a66a3e3b5c ]---
------------[ cut here ]------------
WARNING: at drivers/usb/serial/usb-serial.c:326
serial_write_room+0x44/0x54 [usbserial]()
Modules linked in: ppp_deflate zlib_deflate zlib_inflate bsd_comp
ppp_async crc_ccitt uinput option usbserial sg pcspkr i2c_i801 sr_mod
pcmcia 8250_pci 8250 video serial_core output evdev
Pid: 0, comm: swapper Tainted: G        W  2.6.28 #5
Call Trace:
 [<c01205f1>] warn_on_slowpath+0x40/0x61
 [<f8b744e9>] option_write+0x124/0x1ac [option]
 [<f8b554d4>] serial_write+0x6f/0x7a [usbserial]
 [<f8b55455>] serial_write_room+0x44/0x54 [usbserial]
 [<c020ab2c>] tty_write_room+0x15/0x16
 [<c0208fde>] opost+0xf/0x1ae
 [<c020a67b>] n_tty_receive_buf+0x8cc/0xca6
 [<c027e9d1>] usb_hcd_submit_urb+0x7ca/0x84f
 [<c011a866>] enqueue_task_fair+0x131/0x17a
 [<c0116cdb>] activate_task+0x20/0x2f
 [<c011b09e>] try_to_wake_up+0x180/0x18a
 [<c020c2d4>] flush_to_ldisc+0xf7/0x193
 [<f8b74b26>] option_indat_callback+0x8e/0xe8 [option]
 [<c027d84f>] usb_hcd_giveback_urb+0x4b/0x76
 [<c028916c>] ehci_urb_done+0xcd/0xd9
 [<c0289b9a>] qh_completions+0xa8/0x464
 [<c0127a1a>] __mod_timer+0xba/0xc3
 [<c0289ff7>] ehci_work+0xa1/0x7c4
 [<c028f500>] ehci_irq+0x2bf/0x2e3
 [<c01321cd>] hrtimer_interrupt+0x13a/0x162
 [<c01365c9>] tick_do_broadcast+0x30/0x54
 [<c0136698>] tick_handle_oneshot_broadcast+0xab/0xdf
 [<c027d4c5>] usb_hcd_irq+0x24/0x59
 [<c013e672>] handle_IRQ_event+0x1a/0x3f
 [<c013f68f>] handle_fasteoi_irq+0x6a/0x9b
 [<c013f625>] handle_fasteoi_irq+0x0/0x9b
 <IRQ>  [<c010376b>] common_interrupt+0x23/0x28
 [<c013007b>] set_process_cpu_timer+0x81/0xa5
 [<c01fd12c>] acpi_idle_enter_bm+0x2d6/0x355
 [<c02a8eee>] cpuidle_idle_call+0x5d/0x8f
 [<c0101da8>] cpu_idle+0x68/0x84
---[ end trace 945550a66a3e3b5c ]---
------------[ cut here ]------------
WARNING: at drivers/usb/serial/usb-serial.c:326
serial_write_room+0x44/0x54 [usbserial]()
Modules linked in: ppp_deflate zlib_deflate zlib_inflate bsd_comp
ppp_async crc_ccitt uinput option usbserial sg pcspkr i2c_i801 sr_mod
pcmcia 8250_pci 8250 video serial_core output evdev
Pid: 0, comm: swapper Tainted: G        W  2.6.28 #5
Call Trace:
 [<c01205f1>] warn_on_slowpath+0x40/0x61
 [<f8b744e9>] option_write+0x124/0x1ac [option]
 [<f8b554d4>] serial_write+0x6f/0x7a [usbserial]
 [<f8b55455>] serial_write_room+0x44/0x54 [usbserial]
 [<c020ab2c>] tty_write_room+0x15/0x16
 [<c0208fde>] opost+0xf/0x1ae
 [<c020a67b>] n_tty_receive_buf+0x8cc/0xca6
 [<c027e9d1>] usb_hcd_submit_urb+0x7ca/0x84f
 [<c011a866>] enqueue_task_fair+0x131/0x17a
 [<c0116cdb>] activate_task+0x20/0x2f
 [<c011b09e>] try_to_wake_up+0x180/0x18a
 [<c020c2d4>] flush_to_ldisc+0xf7/0x193
 [<f8b74b26>] option_indat_callback+0x8e/0xe8 [option]
 [<c027d84f>] usb_hcd_giveback_urb+0x4b/0x76
 [<c028916c>] ehci_urb_done+0xcd/0xd9
 [<c0289b9a>] qh_completions+0xa8/0x464
 [<c0127a1a>] __mod_timer+0xba/0xc3
 [<c0289ff7>] ehci_work+0xa1/0x7c4
 [<c028f500>] ehci_irq+0x2bf/0x2e3
 [<c01321cd>] hrtimer_interrupt+0x13a/0x162
 [<c01365c9>] tick_do_broadcast+0x30/0x54
 [<c0136698>] tick_handle_oneshot_broadcast+0xab/0xdf
 [<c027d4c5>] usb_hcd_irq+0x24/0x59
 [<c013e672>] handle_IRQ_event+0x1a/0x3f
 [<c013f68f>] handle_fasteoi_irq+0x6a/0x9b
 [<c013f625>] handle_fasteoi_irq+0x0/0x9b
 <IRQ>  [<c010376b>] common_interrupt+0x23/0x28
 [<c013007b>] set_process_cpu_timer+0x81/0xa5
 [<c01fd12c>] acpi_idle_enter_bm+0x2d6/0x355
 [<c02a8eee>] cpuidle_idle_call+0x5d/0x8f
 [<c0101da8>] cpu_idle+0x68/0x84
---[ end trace 945550a66a3e3b5c ]---

Daryl Radivojevic
