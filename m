Return-Path: <linux-kernel-owner+w=401wt.eu-S1764203AbZD3WqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764203AbZD3WqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 18:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764168AbZD3Wpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 18:45:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34858 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764148AbZD3Wpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 18:45:52 -0400
Date: Fri, 1 May 2009 00:45:51 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Guillaume Chazarain <guichaz@gmail.com>
Cc: oliver@neukum.org, linux-kernel@vger.kernel.org
Subject: Re: What's in hid.git for 2.6.30
In-Reply-To: <3d8471ca0904301529s140339c5w4b39e83b31d4e9c0@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.0905010044450.5012@wotan.suse.de>
References: <alpine.LNX.2.00.0903251742520.14346@wotan.suse.de> <3d8471ca0904301529s140339c5w4b39e83b31d4e9c0@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009, Guillaume Chazarain wrote:

> Testing 2.6.30-rc4 this patch breaks the IR remote control on my macbook 
> pro (ubuntu 9.04 x86_64). Pressing a button on the Apple A1156 triggers 
> a kernel panic, reverting that patch fixes it.
> 
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<ffffffffa018c432>] hid_check_keys_pressed+0x12/0x60 [hid]
> PGD 0
> Oops: 0000 [#1] PREEMPT SMP
> last sysfs file: /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
> CPU 1
> Modules linked in: netconsole configfs af_packet rfcomm btusb sco
> bridge stp llc bnep l2cap bluetooth container acpi_cpufreq
> snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep
> snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_oss snd_seq_midi_event
> snd_seq snd_timer snd_seq_device applesmc snd uvcvideo led_class
> soundcore video iTCO_wdt videodev appletouch hid_apple i2c_core
> input_polldev evdev snd_page_alloc iTCO_vendor_support intel_agp
> processor output battery button v4l1_compat v4l2_compat_ioctl32 ac
> usbhid hid ext3 jbd mbcache sg sd_mod sr_mod cdrom pata_acpi ata_piix
> libata scsi_mod sky2 ehci_hcd uhci_hcd usbcore thermal fan thermal_sys
> fuse
> Pid: 0, comm: swapper Not tainted 2.6.30-rc4-custom-gc #1 MacBookPro3,1
> RIP: 0010:[<ffffffffa018c432>]  [<ffffffffa018c432>]
> hid_check_keys_pressed+0x12/0x60 [hid]
> RSP: 0018:ffff88000102dd18  EFLAGS: 00010046
> RAX: 0000000000000000 RBX: ffff88007e8c5000 RCX: 0000000000000001
> RDX: ffff880079950800 RSI: ffff8800371759f0 RDI: ffff880037174000
> RBP: ffff88000102dd18 R08: ffff8800799c5918 R09: 0000000000000000
> R10: 0000000000000004 R11: 00000000ffffff00 R12: 0000000000000000
> R13: ffff88007e8c5000 R14: ffff88003757c000 R15: ffff880037174000
> FS:  0000000000000000(0000) GS:ffff88000102a000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 0, threadinfo ffff88007e890000, task ffff88007e884350)
> Stack:
>  ffff88000102dd58 ffffffffa019fb14 0000000000000086 ffff88007e8c5000
>  ffff880036d8c800 0000000000000000 ffff88007a0ac800 ffff880036d8c978
>  ffff88000102dd88 ffffffffa0038320 ffff88000102dd88 ffff880036d8ca00
> Call Trace:
>  <IRQ> <0> [<ffffffffa019fb14>] hid_irq_in+0x1f4/0x240 [usbhid]
>  [<ffffffffa0038320>] usb_hcd_giveback_urb+0x60/0xe0 [usbcore]
>  [<ffffffffa0067c6e>] uhci_giveback_urb+0xae/0x2f0 [uhci_hcd]
>  [<ffffffffa00749b8>] ? timer_action+0x48/0x60 [ehci_hcd]
>  [<ffffffffa00763a6>] ? ehci_work+0x886/0xac0 [ehci_hcd]
>  [<ffffffffa0068354>] uhci_scan_schedule+0x354/0xab0 [uhci_hcd]
>  [<ffffffffa006ad61>] uhci_irq+0x91/0x190 [uhci_hcd]
>  [<ffffffffa0037c80>] usb_hcd_irq+0x40/0xb0 [usbcore]
>  [<ffffffff8028ad34>] handle_IRQ_event+0xc4/0x260
>  [<ffffffff8028cb9c>] handle_fasteoi_irq+0x7c/0xf0
>  [<ffffffff8020e65f>] handle_irq+0x1f/0x30
>  [<ffffffff8020dd5a>] do_IRQ+0x6a/0xf0
>  [<ffffffff8020c913>] ret_from_intr+0x0/0xf
>  <EOI> <0> [<ffffffffa01d7631>] ? acpi_idle_enter_bm+0x274/0x2a2 [processor]
>  [<ffffffffa01d7627>] ? acpi_idle_enter_bm+0x26a/0x2a2 [processor]
>  [<ffffffff80402ca5>] ? cpuidle_idle_call+0xa5/0x100
>  [<ffffffff8020b11e>] ? cpu_idle+0x6e/0xe0
>  [<ffffffff804921f6>] ? start_secondary+0x1bd/0x2a7
> Code: b7 10 66 85 d2 75 ce 66 90 31 c0 eb 92 66 66 66 2e 0f 1f 84 00
> 00 00 00 00 55 48 8d b7 f0 19 00 00 48 8b 87 f0 19 00 00 48 89 e5 <48>
> 8b 08 48 39 f0 0f 18 09 74 2e 48 8b 50 18 31 c0 0f 1f 44 00
> RIP  [<ffffffffa018c432>] hid_check_keys_pressed+0x12/0x60 [hid]
>  RSP <ffff88000102dd18>
> CR2: 0000000000000000

Does the pathc below fix the problem for you?


 drivers/hid/hid-core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 5746a59..8f26403 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1824,6 +1824,9 @@ int hid_check_keys_pressed(struct hid_device *hid)
 	struct hid_input *hidinput;
 	int i;
 
+	if (!(hid->claimed & HID_CLAIMED_INPUT))
+		return 0;
+
 	list_for_each_entry(hidinput, &hid->inputs, list) {
 		for (i = 0; i < BITS_TO_LONGS(KEY_MAX); i++)
 			if (hidinput->input->key[i])

-- 
Jiri Kosina
SUSE Labs
