Return-Path: <linux-kernel-owner+w=401wt.eu-S1763971AbZDBQpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763971AbZDBQpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbZDBQp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:45:29 -0400
Received: from exprod7og111.obsmtp.com ([64.18.2.175]:57910 "HELO
	exprod7og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761421AbZDBQp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:45:26 -0400
X-Greylist: delayed 1193 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Apr 2009 12:45:25 EDT
Subject: mutex_lock_slowpath warning using mxser tty driver (input/output
 error)
From: Christophe Lermytte <christophe.lermytte@thomson.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 02 Apr 2009 18:26:05 +0200
Message-Id: <1238689565.14822.99.camel@thom>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
X-OriginalArrivalTime: 02 Apr 2009 16:25:21.0594 (UTC) FILETIME=[9E75D1A0:01C9B3AF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have upgraded one of my automated test setups from 2.6.27 to 2.6.29. I
now have issues with using a Moxa multiport serial device, where I had
none before :-)

> MOXA Smartio/Industio family driver version 2.0.4
> mxser 0000:03:02.0: found MOXA C168H/PCI series board (BusNo=3,
DevNo=2)
> mxser 0000:03:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> mxser: max. baud rate = 921600 bps

When I cat /dev/setup3 (which is a symlink to /dev/ttyMI3), which is
connected to a device that outputs data (tried it with one @ 115200bps
and one @ 9600bps), I get the following kernel trace:

------------[ cut here ]------------
WARNING: at kernel/mutex.c:135 __mutex_lock_slowpath+0x50/0x211()
Hardware name: OptiPlex 755                 
Modules linked in: i915 drm i2c_algo_bit ipv6 8021q dummy fuse arc4 ecb
snd_hda_codec_analog snd_hda_intel snd_hda_codec rtl8187 mac80211 usbhid
i2c_i801 snd_pcm serio_raw eeprom_93cx6 iTCO_wdt i2c_core
iTCO_vendor_support cfg80211 snd_timer snd snd_page_alloc rtc_cmos
rtc_core intel_agp agpgart mxser ppdev thermal uhci_hcd sg rtc_lib
parport_pc processor parport button thermal_sys dcdbas
Pid: 0, comm: swapper Not tainted 2.6.29-autodistro-r4 #1
Call Trace:
[<c0127479>] warn_slowpath+0x74/0x8a
[<c016bb1a>] ? get_page_from_freelist+0xc1/0x3c6
[<c04e0093>] ? usb_hcd_submit_urb+0x88d/0x95b
[<c05d2d41>] ? _spin_lock+0x8/0xb
[<c0187063>] ? cache_alloc_refill+0x19f/0x499
[<c05d1b63>] __mutex_lock_slowpath+0x50/0x211
[<c05d1d36>] mutex_lock+0x12/0x15
[<c026d677>] echo_set_canon_col+0x14/0x37
[<c026e478>] n_tty_receive_buf+0x2f3/0xe0c
[<c05d2d41>] ? _spin_lock+0x8/0xb
[<c0187063>] ? cache_alloc_refill+0x19f/0x499
[<c05d2e5e>] ? _spin_lock_irqsave+0x28/0x2f
[<c012f01d>] ? lock_timer_base+0x1f/0x3e
[<c0118b2d>] ? default_spin_lock_flags+0x8/0xb
[<c0118b2d>] ? default_spin_lock_flags+0x8/0xb
[<c02710ed>] flush_to_ldisc+0xe9/0x159
[<c027119e>] tty_flip_buffer_push+0x41/0x51
[<f842e5f5>] mxser_receive_chars+0x237/0x246 [mxser]
[<f842fac5>] mxser_interrupt+0x18e/0x228 [mxser]
[<c015ac54>] handle_IRQ_event+0x2a/0x5a
[<c015c11a>] handle_fasteoi_irq+0x7b/0xb4
[<c015c09f>] ? handle_fasteoi_irq+0x0/0xb4
<IRQ>  [<c0103527>] ? common_interrupt+0x27/0x2c
[<c0108131>] ? mwait_idle+0x4c/0x5b
[<c0101a5b>] ? cpu_idle+0x59/0x6d
[<c05ce807>] ? start_secondary+0x19f/0x1a4
---[ end trace 433a17e91cdf059a ]---

After I break the cat, subsequent cat's result in:

cat /dev/setup3 
cat: /dev/setup3: Input/output error

I'm not a kernel expert, so if you have any pointers or ways to provide
more information, don't hesitate to ask.

Regards,
Christophe L.
