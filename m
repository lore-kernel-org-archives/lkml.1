Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbZIUTxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbZIUTxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 15:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbZIUTx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 15:53:29 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:60080 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbZIUTx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 15:53:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=dBkW+BhJ8hpEdLEPY8IACIcKrZqUvmsQ9WhnMGqAhACJJ3QIfL7JN3KdR0Cmxof/SC
         CRPxQvQQ3TIQ17dNkKPj72lXCKS4CqiwZC/06TCva4BqdqDE4DuQEHstn+aWsqTNU2XD
         mpkJYX2Wdq/EVRKCLDFLRVTVR5pQYLW1prL0Y=
Message-ID: <4AB7D9B8.6000501@gmail.com>
Date: Mon, 21 Sep 2009 21:53:28 +0200
From: Henk Martijn <h.h.martijn@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "H. Peter Anvin" <hpa@zytor.com>
Subject: 2.6.31-0.1-default-07068-g43c1266 lockdep warning and scheduling
 while atomic BUG
References: <1253560490.2934.42.camel@localhost>
In-Reply-To: <1253560490.2934.42.camel@localhost>
Content-Type: multipart/mixed;
 boundary="------------030406050401080909060709"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030406050401080909060709
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This is a i7 based DELL and current git throws the following warning and bug at me during boot:

config attached.

[   13.905024] PM: Adding info for No Bus:hidraw1
[   13.905118] generic-usb 0003:0D62:2106.0002: input,hidraw1: USB HID v1.10 Keyboard [USB Multimedia Keyboard] on usb-0000:00:1d.0-2/input0
[   13.942228] driver: '0003:0D62:2106.0002': driver_bound: bound to device 'generic-usb'
[   13.942233] bus: 'hid': really_probe: bound device 0003:0D62:2106.0002 to driver generic-usb
[   13.942301] driver: '4-2:1.0': driver_bound: bound to device 'usbhid'
[   13.942306] bus: 'usb': really_probe: bound device 4-2:1.0 to driver usbhid
[   13.942310] bus: 'usb': driver_probe_device: matched device 4-2:1.1 with driver usbhid
[   13.942312] bus: 'usb': really_probe: probing driver usbhid with device 4-2:1.1
[   13.942396] device: '0003:0D62:2106.0003': device_add
[   13.942422] bus: 'hid': add device 0003:0D62:2106.0003
[   13.942485] PM: Adding info for hid:0003:0D62:2106.0003
[   13.942546] bus: 'hid': driver_probe_device: matched device 0003:0D62:2106.0003 with driver generic-usb
[   13.942548] bus: 'hid': really_probe: probing driver generic-usb with device 0003:0D62:2106.0003
[   13.978016] ------------[ cut here ]------------
[   14.014518] WARNING: at kernel/lockdep.c:2457 lockdep_trace_alloc+0x96/0xc3()
[   14.051564] Hardware name: Studio XPS 435MT
[   14.088517] Modules linked in: usbhid(+) usb_libusual dcdbas ehci_hcd uhci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ata_generic ata_piix thermal processor
[   14.127811] Pid: 0, comm: swapper Not tainted 2.6.31-0.1-default-07068-g43c1266 #25
[   14.166977] Call Trace:
[   14.205599]  <IRQ>  [<ffffffff81063570>] ? lockdep_trace_alloc+0x96/0xc3
[   14.244469]  [<ffffffff8103e227>] warn_slowpath_common+0x77/0xa4
[   14.282978]  [<ffffffff8103e263>] warn_slowpath_null+0xf/0x11
[   14.320837]  [<ffffffff81063570>] lockdep_trace_alloc+0x96/0xc3
[   14.358269]  [<ffffffff810c9af3>] kmem_cache_alloc+0x31/0x12f
[   14.395248]  [<ffffffff81265e62>] ? hid_input_report+0x8e/0x2d4
[   14.431762]  [<ffffffff81265e62>] hid_input_report+0x8e/0x2d4
[   14.467764]  [<ffffffffa00f4fe6>] hid_ctrl+0xaa/0x180 [usbhid]
[   14.503265]  [<ffffffffa0087c83>] usb_hcd_giveback_urb+0x84/0xbb [usbcore]
[   14.538766]  [<ffffffffa00c28c8>] uhci_giveback_urb+0x114/0x257 [uhci_hcd]
[   14.573767]  [<ffffffff810c2904>] ? dma_pool_free+0x1ce/0x1da
[   14.608146]  [<ffffffffa00c32b5>] uhci_scan_schedule+0x5ad/0x868 [uhci_hcd]
[   14.642116]  [<ffffffffa00c5329>] uhci_irq+0x134/0x14e [uhci_hcd]
[   14.675410]  [<ffffffffa008764c>] usb_hcd_irq+0x38/0x93 [usbcore]
[   14.708595]  [<ffffffff81084832>] handle_IRQ_event+0x54/0x12d
[   14.741681]  [<ffffffff81086329>] handle_fasteoi_irq+0x8b/0xcb
[   14.774501]  [<ffffffff8100dacf>] handle_irq+0x89/0x92
[   14.806831]  [<ffffffff8100cc54>] do_IRQ+0x5a/0xba
[   14.838698]  [<ffffffff8100b993>] ret_from_intr+0x0/0xf
[   14.870502]  <EOI>  [<ffffffff811c7b0d>] ? acpi_hw_validate_io_request+0x71/0x153
[   14.902707]  [<ffffffffa00030ff>] ? acpi_idle_enter_simple+0x12d/0x15b [processor]
[   14.935371]  [<ffffffffa00030f5>] ? acpi_idle_enter_simple+0x123/0x15b [processor]
[   14.967892]  [<ffffffffa0002e0e>] ? acpi_idle_enter_bm+0xd3/0x297 [processor]
[   15.000367]  [<ffffffff81336afd>] ? __atomic_notifier_call_chain+0x78/0x87
[   15.032797]  [<ffffffff8126286f>] ? cpuidle_idle_call+0x93/0xf0
[   15.065101]  [<ffffffff8100a30c>] ? cpu_idle+0x89/0xca
[   15.097244]  [<ffffffff8132e13a>] ? start_secondary+0x290/0x2db
[   15.129253] ---[ end trace 427177f6fb7d2a3d ]---
[   15.161208] BUG: scheduling while atomic: swapper/0/0x10010000
[   15.193419] INFO: lockdep is turned off.
[   15.225415] Modules linked in: usbhid(+) usb_libusual dcdbas ehci_hcd uhci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ata_generic ata_piix thermal processor
[   15.259383] irq event stamp: 100508
[   15.292529] hardirqs last  enabled at (100507): [<ffffffffa00030f5>] acpi_idle_enter_simple+0x123/0x15b [processor]
[   15.326939] hardirqs last disabled at (100508): [<ffffffff8100ade7>] save_args+0x67/0x70
[   15.361106] softirqs last  enabled at (100496): [<ffffffff810440ce>] __do_softirq+0x1a3/0x1b5
[   15.395335] softirqs last disabled at (100481): [<ffffffff8100c17c>] call_softirq+0x1c/0x34
[   15.429297] CPU 3:
[   15.462587] Modules linked in: usbhid(+) usb_libusual dcdbas ehci_hcd uhci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ata_generic ata_piix thermal processor
[   15.497904] Pid: 0, comm: swapper Tainted: G        W  2.6.31-0.1-default-07068-g43c1266 #25 Studio XPS 435MT
[   15.533540] RIP: 0010:[<ffffffffa00030ff>]  [<ffffffffa00030ff>] acpi_idle_enter_simple+0x12d/0x15b [processor]
[   15.569867] RSP: 0018:ffff8800be6bde28  EFLAGS: 00000206
[   15.606233] RAX: ffff8800be6bdfd8 RBX: ffff8800be6bde68 RCX: 00000000000f4240
[   15.643177] RDX: ffff8800068c0000 RSI: 0000000000000004 RDI: ffff8800be6c8000
[   15.680292] RBP: ffffffff8100b98e R08: ffff8800b9ce2090 R09: 0000000000000000
[   15.717613] R10: ffffffff811c7b0d R11: ffff8800be6bde08 R12: ffffffff8152eed0
[   15.754834] R13: 0000000000000086 R14: 0000000000000046 R15: ffff8800be6bddb8
[   15.792046] FS:  0000000000000000(0000) GS:ffff8800068c0000(0000) knlGS:0000000000000000
[   15.828930] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   15.865108] CR2: 00000000023e2c78 CR3: 00000000b98bc000 CR4: 00000000000006e0
[   15.901501] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   15.937058] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   15.971439] Call Trace:
[   16.004630]  [<ffffffffa00030f5>] ? acpi_idle_enter_simple+0x123/0x15b [processor]
[   16.037876]  [<ffffffffa0002e0e>] ? acpi_idle_enter_bm+0xd3/0x297 [processor]
[   16.070344]  [<ffffffff81336afd>] ? __atomic_notifier_call_chain+0x78/0x87
[   16.102634]  [<ffffffff8126286f>] ? cpuidle_idle_call+0x93/0xf0
[   16.134673]  [<ffffffff8100a30c>] ? cpu_idle+0x89/0xca
[   16.165749]  [<ffffffff8132e13a>] ? start_secondary+0x290/0x2db

I can provide more information or test patches if needed,

Regards,

Henk

--------------030406050401080909060709
Content-Type: application/x-gzip;
 name="config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="config.gz"

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
--------------030406050401080909060709--
