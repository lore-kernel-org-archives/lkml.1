Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbZEHBwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbZEHBwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 21:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZEHBwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 21:52:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:11442 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbZEHBwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 21:52:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,314,1239001200"; 
   d="scan'208";a="513587743"
Subject: Re: acpi/suspend - irq 9: nobody cared
From: yakui_zhao <yakui.zhao@intel.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <20090507105821.GA5864@hash.localnet>
References: <20090507105821.GA5864@hash.localnet>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Fri, 08 May 2009 09:53:54 +0800
Message-Id: <1241747634.3773.129.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-07 at 18:58 +0800, Bob Copeland wrote:
> Hi,
> 
> I have been seeing the following in 2.6.30 whenever I suspend to ram.
> The power button no longer works afterwards.  I don't recall any 
> problems with 2.6.29.  Anyone have any ideas before I try bisecting?
>From the description it seems that this is a regression.
Will you please use git-bisect to identify the commit which causes the
regression?

Thanks.
> 
> (The previous W taint is something unrelated.)
> 
> [31263.940249] appletouch: Geyser mode initialized.
> [31263.941375] usb 4-2: type resume
> [31264.043112] usb 4-2: reset full speed USB device using uhci_hcd and address 2
> [31264.183582] usb 5-1: type resume
> [31264.283313] irq 9: nobody cared (try booting with the "irqpoll" option)
> [31264.283318] Pid: 0, comm: swapper Tainted: G        W  2.6.30-rc4-wl #116
> [31264.283320] Call Trace:
> [31264.283328]  [<c015a01a>] __report_bad_irq+0x33/0x74
> [31264.283333]  [<c015a150>] note_interrupt+0xf5/0x14d
> [31264.283337]  [<c015a6bf>] handle_fasteoi_irq+0x8c/0xb0
> [31264.283342]  [<c0104601>] handle_irq+0x40/0x4b
> [31264.283348]  [<c035a322>] do_IRQ+0x4a/0x8c
> [31264.283352]  [<c010312e>] common_interrupt+0x2e/0x34
> [31264.283358]  [<c01455a3>] ? trace_hardirqs_on+0xb/0xd
> [31264.283362]  [<c014007b>] ? timer_list_show+0x1b3/0x939
> [31264.283375]  [<f891c00f>] ? acpi_idle_enter_c1+0xad/0xb9 [processor]
> [31264.283380]  [<c02d20ee>] cpuidle_idle_call+0x6a/0x9c
> [31264.283384]  [<c0101cc8>] cpu_idle+0x53/0x87
> [31264.283388]  [<c03467e0>] rest_init+0x6c/0x6e
> [31264.283394]  [<c04df74d>] start_kernel+0x286/0x28b
> [31264.283398]  [<c04df037>] __init_begin+0x37/0x3c
> [31264.283400] handlers:
> [31264.283402] [<c022cabc>] (acpi_irq+0x0/0x2e)
> [31264.283408] Disabling IRQ #9
> [31264.285035] usb 5-1: reset full speed USB device using uhci_hcd and address 2
> [31264.383127] ------------[ cut here ]------------
> [31264.383132] WARNING: at kernel/irq/handle.c:366 handle_IRQ_event+0x40/0x179()
> [31264.383137] Hardware name: MacBook1,1
> [31264.383140] BUG: IRQ handler called from non-hardirq context!Modules linked in: fuse i915 drm af_packet acpi_cpufreq binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath dm_mod arc4 ecb ath5k snd_hda_codec_idt snd_hda_intel hid_apple appletouch snd_hda_codec mac80211 usbhid snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq ath snd_seq_device sky2 ohci1394 snd_pcm_oss snd_mixer_oss cfg80211 ieee1394 processor button snd_pcm snd_timer uhci_hcd ehci_hcd bitrev snd ac battery thermal snd_page_alloc crc32 sg joydev sr_mod applesmc input_polldev evdev cdrom unix [last unloaded: microcode]
> [31264.383241] Pid: 0, comm: swapper Tainted: G        W  2.6.30-rc4-wl #116
> [31264.383245] Call Trace:
> [31264.383254]  [<c012590f>] warn_slowpath+0x76/0xa5
> [31264.383264]  [<c01473e5>] ? print_lock_contention_bug+0x14/0xd7
> [31264.383272]  [<c013bb30>] ? sched_clock_cpu+0x92/0x2f1
> [31264.383281]  [<c01455a3>] ? trace_hardirqs_on+0xb/0xd
> [31264.383290]  [<c035659a>] ? _spin_unlock_irqrestore+0x3b/0x5d
> [31264.383298]  [<c0145473>] ? trace_hardirqs_on_caller+0x18/0x13d
> [31264.383307]  [<c03565a6>] ? _spin_unlock_irqrestore+0x47/0x5d
> [31264.383315]  [<c0159f0d>] ? try_one_irq+0x92/0xf7
> [31264.383323]  [<c0158f31>] handle_IRQ_event+0x40/0x179
> [31264.383331]  [<c0159f25>] try_one_irq+0xaa/0xf7
> [31264.383340]  [<c0159fa1>] poll_all_shared_irqs+0x2f/0x44
> [31264.383348]  [<c0159fc3>] poll_spurious_irqs+0xd/0x22
> [31264.383356]  [<c012d860>] run_timer_softirq+0x196/0x20f
> [31264.383363]  [<c012d7e1>] ? run_timer_softirq+0x117/0x20f
> [31264.383372]  [<c0159fb6>] ? poll_spurious_irqs+0x0/0x22
> [31264.383381]  [<c0129f91>] __do_softirq+0xb1/0x182
> [31264.383390]  [<c012a092>] do_softirq+0x30/0x48
> [31264.383397]  [<c012a20a>] irq_exit+0x3d/0x74
> [31264.383405]  [<c035a34e>] do_IRQ+0x76/0x8c
> [31264.383413]  [<c010312e>] common_interrupt+0x2e/0x34
> [31264.383422]  [<c014007b>] ? timer_list_show+0x1b3/0x939
> [31264.383440]  [<f891c281>] ? acpi_idle_enter_bm+0x266/0x291 [processor]
> [31264.383450]  [<c02d20ee>] cpuidle_idle_call+0x6a/0x9c
> [31264.383458]  [<c0101cc8>] cpu_idle+0x53/0x87
> [31264.383465]  [<c03467e0>] rest_init+0x6c/0x6e
> [31264.383482]  [<c04df74d>] start_kernel+0x286/0x28b
> [31264.383487]  [<c04df037>] __init_begin+0x37/0x3c
> [31264.383489] ---[ end trace 576a96bb93c6d61f ]---
> [31264.460510] ieee80211 phy0: legacy class resume
> [31264.460589] drm card0: legacy class resume
> [31264.460634] pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900003)
> [31264.460661] pci 0000:00:02.0: setting latency timer to 64
> 
> bob@sludge wireless-testing]$ cat /proc/interrupts 
>            CPU0       CPU1       
>   0:    1967552          0   IO-APIC-edge      timer
>   8:         84          0   IO-APIC-edge      rtc0
>   9:     138333     261669   IO-APIC-fasteoi   acpi
>  14:     329504          0   IO-APIC-edge      ata_piix
>  15:          0          0   IO-APIC-edge      ata_piix
>  16:       1918      84773   IO-APIC-fasteoi   uhci_hcd:usb5, eth0, i915@pci:0000:00:02.0
>  17:     127320          0   IO-APIC-fasteoi   ath
>  18:         69          0   IO-APIC-fasteoi   uhci_hcd:usb4
>  19:       4230     117896   IO-APIC-fasteoi   ata_piix, uhci_hcd:usb3, ohci1394
>  21:        744      79985   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
>  22:        268          0   IO-APIC-fasteoi   HDA Intel
> NMI:          0          0   Non-maskable interrupts
> LOC:     357130    1384924   Local timer interrupts
> SPU:          0          0   Spurious interrupts
> RES:     243366     162707   Rescheduling interrupts
> CAL:        193        367   Function call interrupts
> TLB:       2533       2519   TLB shootdowns
> TRM:          0          0   Thermal event interrupts
> ERR:          0
> MIS:          0
> 

