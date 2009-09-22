Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbZIVDr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbZIVDr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 23:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbZIVDrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 23:47:55 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:37046 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbZIVDry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 23:47:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Tttgg7F+0Z2fL+nJQRien3A1C1CYWVttqctBuVwhG3LrZdM6z68QO6omwqciKv9HS+
         kw+CaIJbzrE8EfF9Sb52TRTv/FEWiXXwiquIOQad75CaQwcnAIdTfgHVjSDIigBNZzWh
         PQ5+TZ9F5mrSJxv/Ee+3ZmPH6GYX7g6kbX7fs=
MIME-Version: 1.0
Date: Mon, 21 Sep 2009 20:47:57 -0700
Message-ID: <dd18b0c30909212047m46b7c85aybb113517423fc7ac@mail.gmail.com>
Subject: [ 14.123127] BUG: spinlock bad magic on CPU#0, swapper/0
From: Justin Mattock <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm just trying to get the dam* bluetooth mighty mouse to
work. anyways the system barfed up this:
(FWIW:  had bluez installed at-least an hour without this
showing up, as soon as I installed libusb
this showed up)

[   13.607016] type=1400 audit(1253565686.600:3): avc:  denied  {
execmem } for  pid=1759 comm="python"
scontext=system_u:system_r:kernel_t
tcontext=system_u:system_r:kernel_t tclass=process
[   14.123127] BUG: spinlock bad magic on CPU#0, swapper/0
[   14.123322]  lock: ffff88002ad28430, .magic: 00000000, .owner:
<none>/-1, .owner_cpu: 0
[   14.123598] Pid: 0, comm: swapper Not tainted 2.6.31-05767-gdf58bee #4
[   14.123784] Call Trace:
[   14.123965]  <IRQ>  [<ffffffff811cfd1e>] spin_bug+0x9c/0xa3
[   14.124256]  [<ffffffff811cfdd9>] _raw_spin_lock+0x29/0x13c
[   14.124446]  [<ffffffff813bad6c>] _spin_lock_irqsave+0x1f/0x26
[   14.124637]  [<ffffffff812f99f5>] skb_dequeue+0x1c/0x6b
[   14.124839]  [<ffffffffa0092c5e>] ? uhci_urb_enqueue+0x83a/0x853 [uhci_hcd]
[   14.125029]  [<ffffffff812fa571>] skb_queue_purge+0x1e/0x28
[   14.125224]  [<ffffffffa004d783>] l2cap_recv_frame+0x118d/0x20f4 [l2cap]
[   14.125417]  [<ffffffff810ddf9c>] ? __slab_free+0x2b3/0x2f9
[   14.125617]  [<ffffffffa003c8cd>] ? hci_event_packet+0x2984/0x299f
[bluetooth]
[   14.125892]  [<ffffffff812fa217>] ? __kfree_skb+0x78/0x7c
[   14.126079]  [<ffffffff812fa2aa>] ? kfree_skb+0x65/0x6d
[   14.126276]  [<ffffffffa003c8cd>] ? hci_event_packet+0x2984/0x299f
[bluetooth]
[   14.126552]  [<ffffffff81299598>] ? usb_submit_urb+0x217/0x22e
[   14.126745]  [<ffffffffa006063c>] ? btusb_bulk_complete+0x9f/0xd6 [btusb]
[   14.126935]  [<ffffffff813bad1d>] ? _spin_lock+0x9/0xb
[   14.127126]  [<ffffffffa009093d>] ? uhci_giveback_urb+0x124/0x1a5 [uhci_hcd]
[   14.127322]  [<ffffffffa004e7fe>] l2cap_recv_acldata+0xc5/0x233 [l2cap]
[   14.127526]  [<ffffffffa003809f>] hci_rx_task+0x155/0x253 [bluetooth]
[   14.127718]  [<ffffffff81064319>] tasklet_action+0x80/0xdf
[   14.127906]  [<ffffffff81065ba7>] __do_softirq+0xe0/0x1a1
[   14.128099]  [<ffffffff8102d9ac>] call_softirq+0x1c/0x28
[   14.128288]  [<ffffffff8102ee35>] do_softirq+0x41/0x81
[   14.128480]  [<ffffffff8106597a>] irq_exit+0x36/0x78
[   14.128671]  [<ffffffff8102e513>] do_IRQ+0xa0/0xb7
[   14.128860]  [<ffffffff8102d1d3>] ret_from_intr+0x0/0x11
[   14.129043]  <EOI>  [<ffffffffa0018c88>] ?
acpi_idle_enter_bm+0x2d7/0x30b [processor]
[   14.129432]  [<ffffffffa0018c81>] ? acpi_idle_enter_bm+0x2d0/0x30b
[processor]
[   14.129709]  [<ffffffff812d65b9>] ? cpuidle_idle_call+0x88/0xbf
[   14.129899]  [<ffffffff8102bbf7>] ? cpu_idle+0x58/0x93
[   14.130086]  [<ffffffff813aa2ad>] ? rest_init+0x61/0x63
[   14.130276]  [<ffffffff8162514e>] ? start_kernel+0x361/0x36c
[   14.130466]  [<ffffffff81624785>] ? x86_64_start_reservations+0xac/0xb0
[   14.130656]  [<ffffffff81624881>] ? x86_64_start_kernel+0xf8/0x107
[   14.642763] applesmc: light sensor data length set to 6

I can try and do a git bisect,
but might not be right now.

-- 
Justin P. Mattock
