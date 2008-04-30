Return-Path: <linux-kernel-owner+w=401wt.eu-S1762178AbYD3LmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762178AbYD3LmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 07:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbYD3LmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 07:42:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754333AbYD3Ll7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 07:41:59 -0400
Date: Wed, 30 Apr 2008 04:40:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       mchehab@infradead.org, torvalds@linux-foundation.org,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch, -git] drivers/media build fix for modular builds
Message-Id: <20080430044009.6c5bbc8d.akpm@linux-foundation.org>
In-Reply-To: <1209547231.4898.2.camel@marge.simson.net>
References: <20080429185009.716c3284@gaivota>
	<20080430074807.GA11224@elte.hu>
	<20080430.005212.46815036.davem@davemloft.net>
	<20080430081345.GA16519@elte.hu>
	<1209544030.30990.2.camel@marge.simson.net>
	<1209544951.15609.3.camel@marge.simson.net>
	<1209545784.31419.2.camel@marge.simson.net>
	<1209547231.4898.2.camel@marge.simson.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 11:20:31 +0200 Mike Galbraith <efault@gmx.de> wrote:

> [   16.299803] kernel BUG at kernel/module.c:784!
> [   16.307170] invalid opcode: 0000 [1] SMP 
> [   16.314110] CPU 3 
> [   16.318911] Modules linked in: tuner(+) snd_hda_intel(+) saa7134(+) compat_ioctl32 firewire_ohci videodev snd_pcm firewire_core v4l1_compat v4l2_common snd_timer videobuf_dma_sg videobuf_core crc_itu_t snd_page_alloc snd_hwdep ir_kbd_i2c ohci1394 snd ir_common usb_storage rtc_cmos ieee1394 tveeprom rtc_core i2c_i801 button sr_mod intel_agp serio_raw e1000e iTCO_wdt i2c_core iTCO_vendor_support rtc_lib cdrom sg soundcore usbhid hid ff_memless ehci_hcd uhci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ahci libata scsi_mod dock thermal processor
> [   16.386303] Pid: 2239, comm: modprobe Not tainted 2.6.26-smp #1
> [   16.395339] RIP: 0010:[<ffffffff80254714>]  [<ffffffff80254714>] __symbol_put+0x22/0x31

Does this make it feel better?

--- a/drivers/media/video/tuner-core.c~a
+++ a/drivers/media/video/tuner-core.c
@@ -40,11 +40,11 @@
 	typeof(&FUNCTION) __a = symbol_request(FUNCTION); \
 	if (__a) { \
 		__r = (int) __a(ARGS); \
+		symbol_put(FUNCTION); \
 	} else { \
 		printk(KERN_ERR "TUNER: Unable to find " \
 				"symbol "#FUNCTION"()\n"); \
 	} \
-	symbol_put(FUNCTION); \
 	__r; \
 })
 
_

