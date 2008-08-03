Return-Path: <linux-kernel-owner+w=401wt.eu-S1759945AbYHCWFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbYHCWFV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 18:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757306AbYHCWFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 18:05:08 -0400
Received: from submit-tmp.sysedata.no ([195.159.29.133]:65424 "EHLO
	submit-tmp.sysedata.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbYHCWFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 18:05:06 -0400
Message-ID: <48962B8A.8030307@db.org>
Date: Mon, 04 Aug 2008 00:04:58 +0200
From: "Alfred E. Heggestad" <aeh@db.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: driver for USB VoIP phones with CM109 chipset
 #2
References: <200806271424.50425.oliver@neukum.org> <20080725141420.GA29395@anvil.corenet.prv> <488B48F7.5060002@db.org> <200807262045.22722.oliver@neukum.org>
In-Reply-To: <200807262045.22722.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Samstag 26 Juli 2008 17:55:35 schrieb Alfred E. Heggestad:
>> Jul 26 17:32:33 io kernel: hald-addon-keyb[23629]: segfault at 6f6f6c5f ip b7e9855b sp bf9d89dc error 4 in libc-2.6.1.so[b7e28000+144000]
>> Jul 26 17:32:43 io kernel: cm109: cm109_urb_ctl_callback: usb_submit_urb (urb_irq) failed -22
>> Jul 26 17:33:21 io last message repeated 6 times
>> Jul 26 17:34:28 io last message repeated 17 times
> 
> This should not happen. Please provide more context. If possible
> recompile your kernel with CONFIG_USB_DEBUG.
> 

Hi Oliver

sorry for the delay, I was out travelling with no access to CM109 hardware..

I recompiled the latest kernel from input-branch with CONFIG_USB_DEBUG enabled,
the version reported is 2.6.27-rc1. Below you can see the syslog and the
context of events:



;;;
;;; Insert CM109 device here:
;;;

Aug  3 23:42:49 io kernel: usb usb1: usb resume
Aug  3 23:42:49 io kernel: usb usb1: wakeup_rh
Aug  3 23:42:49 io kernel: hub 1-0:1.0: hub_resume
Aug  3 23:42:49 io kernel: uhci_hcd 0000:00:1f.2: port 2 portsc 0093,00
Aug  3 23:42:49 io kernel: hub 1-0:1.0: port 2: status 0101 change 0001
Aug  3 23:42:49 io kernel: hub 1-0:1.0: state 7 ports 2 chg 0004 evt 0000
Aug  3 23:42:49 io kernel: hub 1-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
Aug  3 23:42:49 io kernel: usb 1-2: new full speed USB device using uhci_hcd and address 3
Aug  3 23:42:49 io kernel: usb 1-2: skipped 7 descriptors after interface
Aug  3 23:42:49 io kernel: usb 1-2: skipped 2 descriptors after interface
Aug  3 23:42:49 io kernel: usb 1-2: skipped 1 descriptor after endpoint
Aug  3 23:42:49 io kernel: usb 1-2: skipped 2 descriptors after interface
Aug  3 23:42:49 io kernel: usb 1-2: skipped 1 descriptor after endpoint
Aug  3 23:42:49 io kernel: usb 1-2: skipped 1 descriptor after interface
Aug  3 23:42:49 io kernel: usb 1-2: default language 0x0409
Aug  3 23:42:49 io kernel: usb 1-2: uevent
Aug  3 23:42:49 io kernel: usb 1-2: usb_probe_device
Aug  3 23:42:49 io kernel: usb 1-2: configuration #1 chosen from 1 choice
Aug  3 23:42:49 io kernel: usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Aug  3 23:42:49 io kernel: usb 1-2:1.0: uevent
Aug  3 23:42:49 io kernel: snd-usb-audio 1-2:1.0: usb_probe_interface
Aug  3 23:42:49 io kernel: snd-usb-audio 1-2:1.0: usb_probe_interface - got id
Aug  3 23:42:49 io kernel: usb 1-2: adding 1-2:1.1 (config #1, interface 1)
Aug  3 23:42:49 io kernel: usb 1-2:1.1: uevent
Aug  3 23:42:49 io kernel: usb 1-2: adding 1-2:1.2 (config #1, interface 2)
Aug  3 23:42:49 io kernel: usb 1-2:1.2: uevent
Aug  3 23:42:49 io kernel: usb 1-2: adding 1-2:1.3 (config #1, interface 3)
Aug  3 23:42:49 io kernel: usb 1-2:1.3: uevent
Aug  3 23:42:49 io kernel: cm109 1-2:1.3: usb_probe_interface
Aug  3 23:42:49 io kernel: cm109 1-2:1.3: usb_probe_interface - got id
Aug  3 23:42:49 io kernel: input: CM109 USB driver as /class/input/input9
Aug  3 23:42:49 io kernel: uhci_hcd 0000:00:1f.2: reserve dev 3 ep83-INT, period 32, phase 16, 14 us
Aug  3 23:42:49 io kernel: uhci_hcd 0000:00:1f.2: release dev 3 ep83-INT, period 32, phase 16, 14 us
Aug  3 23:42:49 io kernel: drivers/usb/core/inode.c: creating file '003'
Aug  3 23:42:49 io kernel: usb 1-2: New USB device found, idVendor=0d8c, idProduct=000e
Aug  3 23:42:49 io kernel: usb 1-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
Aug  3 23:42:49 io kernel: usb 1-2: Product: Generic USB Audio Device   
Aug  3 23:42:49 io kernel: uhci_hcd 0000:00:1f.2: reserve dev 3 ep83-INT, period 32, phase 16, 14 us

;;;
;;; Buzzer is actived here (twice):
;;;

Aug  3 23:42:54 io kernel: cm109: cm109_urb_ctl_callback: usb_submit_urb (urb_irq) failed -22
Aug  3 23:42:55 io kernel: cm109: cm109_urb_ctl_callback: usb_submit_urb (urb_irq) failed -22

;;;
;;; CM109 Device unplugged here:
;;;

Aug  3 23:43:14 io kernel: usb 1-2: uhci_result_common: failed with status 440000
Aug  3 23:43:14 io kernel: cm109: cm109_urb_irq_callback: urb status -84
Aug  3 23:43:14 io kernel: uhci_hcd 0000:00:1f.2: release dev 3 ep83-INT, period 32, phase 16, 14 us
Aug  3 23:43:14 io kernel: usb 1-2: uhci_result_common: failed with status 440000
Aug  3 23:43:14 io kernel: cm109: cm109_urb_ctl_callback: urb status -71
Aug  3 23:43:14 io kernel: uhci_hcd 0000:00:1f.2: reserve dev 3 ep83-INT, period 32, phase 16, 14 us
Aug  3 23:43:14 io kernel: usb 1-2: uhci_result_common: failed with status 440000
Aug  3 23:43:14 io kernel: cm109: cm109_urb_irq_callback: urb status -84
Aug  3 23:43:14 io kernel: uhci_hcd 0000:00:1f.2: release dev 3 ep83-INT, period 32, phase 16, 14 us
Aug  3 23:43:14 io kernel: usb 1-2: uhci_result_common: failed with status 440000
Aug  3 23:43:14 io kernel: cm109: cm109_urb_ctl_callback: urb status -71
Aug  3 23:43:14 io kernel: uhci_hcd 0000:00:1f.2: reserve dev 3 ep83-INT, period 32, phase 16, 14 us
Aug  3 23:43:14 io kernel: hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0004
Aug  3 23:43:14 io kernel: uhci_hcd 0000:00:1f.2: port 2 portsc 008a,00
Aug  3 23:43:14 io kernel: hub 1-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
Aug  3 23:43:14 io kernel: usb 1-2: uhci_result_common: failed with status 440000
Aug  3 23:43:14 io kernel: cm109: cm109_urb_irq_callback: urb status -84
Aug  3 23:43:14 io kernel: uhci_hcd 0000:00:1f.2: release dev 3 ep83-INT, period 32, phase 16, 14 us
Aug  3 23:43:14 io kernel: usb 1-2: uhci_result_common: failed with status 440000
Aug  3 23:43:14 io kernel: cm109: cm109_urb_ctl_callback: urb status -71
Aug  3 23:43:14 io kernel: uhci_hcd 0000:00:1f.2: reserve dev 3 ep83-INT, period 32, phase 16, 14 us
Aug  3 23:43:14 io kernel: hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
Aug  3 23:43:14 io kernel: usb 1-2: USB disconnect, address 3
Aug  3 23:43:14 io kernel: usb 1-2: unregistering device
Aug  3 23:43:14 io kernel: usb 1-2: usb_disable_device nuking all URBs
Aug  3 23:43:14 io kernel: uhci_hcd 0000:00:1f.2: shutdown urb ceeaff40 ep3in-intr
Aug  3 23:43:14 io kernel: uhci_hcd 0000:00:1f.2: release dev 3 ep83-INT, period 32, phase 16, 14 us
Aug  3 23:43:14 io kernel: usb 1-2: unregistering interface 1-2:1.0
Aug  3 23:43:14 io kernel: usb 1-2:1.0: uevent
Aug  3 23:43:14 io kernel: usb 1-2: unregistering interface 1-2:1.1
Aug  3 23:43:14 io kernel: usb 1-2:1.1: uevent
Aug  3 23:43:14 io kernel: usb 1-2: unregistering interface 1-2:1.2
Aug  3 23:43:14 io kernel: usb 1-2:1.2: uevent
Aug  3 23:43:14 io kernel: usb 1-2: unregistering interface 1-2:1.3
Aug  3 23:43:14 io kernel: cm109: cm109_toggle_buzzer_sync: usb_control_msg) failed -19
Aug  3 23:43:14 io kernel: usb 1-2:1.3: uevent
Aug  3 23:43:14 io kernel: usb 1-2: uevent
Aug  3 23:43:15 io kernel: usb usb1: suspend_rh (auto-stop)
Aug  3 23:43:16 io kernel: hub 1-0:1.0: hub_suspend
Aug  3 23:43:16 io kernel: usb usb1: bus auto-suspend
Aug  3 23:43:16 io kernel: usb usb1: suspend_rh




/alfred
