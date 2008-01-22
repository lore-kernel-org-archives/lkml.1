Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbYAVCf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbYAVCf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 21:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYAVCfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 21:35:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:18746 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbYAVCfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 21:35:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=lqYTNM4G6xlsi1OSweG3zkB/OfuxB1n0dqPEdqpl1aVq3gK9tqdyPinqZkjIMBd+zw9leXN5yjRINqAmdkP8TUse0+TrUvsaN6zUlVWSnms5d845CtWEpraztbaV5Z/IZo6oyoGNR1vgmOpVwCYCKsj79qnjdmD02A73bgG8v1I=
Date: Tue, 22 Jan 2008 10:36:26 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: WARNING: at kernel/mutex.c:134
Message-ID: <20080122023626.GA12213@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While try to trigger bug 9778, press ctrl+alt+sysrq +w, the following warnings appeared:

usb0: unregister 'cdc_ether' usb-0000:00:1d.7-1.3, CDC Ethernet Device
unregister_netdevice: waiting for usb0 to become free. Usage count = 1
SysRq : Show Blocked State
  task                PC stack   pid father
Sched Debug Version: v0.07, 2.6.24-rc8-mm1 #5
now at 2660467.699238 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 20.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 39

cpu#0, 2793.192 MHz
  .nr_running                    : 2
  .load                          : 4096
  .nr_switches                   : 1627754
  .nr_load_updates               : 241563
  .nr_uninterruptible            : 4294967012
  .jiffies                       : 708140
  .next_balance                  : 0.708327
  .curr->pid                     : 0
  .clock                         : 2656959.965268
  .idle_clock                    : 0.000000
  .prev_clock_raw                : 2674890.031768
  .clock_warps                   : 0
  .clock_overflows               : 5805
  .clock_underflows              : 127079
  .clock_deep_idle_events        : 2
  .clock_max_delta               : 671.628710
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 6
  .cpu_load[3]                   : 48
  .cpu_load[4]                   : 85

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 180379.753201
  .min_vruntime                  : 180379.753201
  .max_vruntime                  : 180379.753201
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 1
  .load                          : 4096
  .nr_spread_over                : 0
------------[ cut here ]------------
WARNING: at kernel/mutex.c:134 mutex_lock_nested+0x277/0x290()
Modules linked in: cdc_ether usbnet snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss eeprom e100 psmouse snd_hda_intel snd_pcm intel_agp btusb snd_timer rtc_cmos bluetooth sg rtc_core 3c59x evdev agpgart snd serio_raw button thermal processor soundcore rtc_lib snd_page_alloc i2c_i801 pcspkr dcdbas
Pid: 0, comm: swapper Not tainted 2.6.24-rc8-mm1 #5
 [<c0132100>] ? printk+0x0/0x20
 [<c0131834>] warn_on_slowpath+0x54/0x80
 [<c043641e>] ? _spin_unlock_irqrestore+0x5e/0x70
 [<c0132791>] ? release_console_sem+0xd1/0xe0
 [<c0132428>] ? vprintk+0x308/0x320
 [<c0153241>] ? put_lock_stats+0x21/0x30
 [<c01532b0>] ? lock_release_holdtime+0x60/0x80
 [<c0126b07>] ? print_cfs_rq+0x117/0x500
 [<c0156b87>] ? __lock_release+0x47/0x70
 [<c0126b07>] ? print_cfs_rq+0x117/0x500
 [<c0132118>] ? printk+0x18/0x20
 [<c0434757>] mutex_lock_nested+0x277/0x290
 [<c0132428>] ? vprintk+0x308/0x320
 [<c0124f60>] ? print_cfs_stats+0x30/0xb0
 [<c0124f60>] print_cfs_stats+0x30/0xb0
 [<c012770c>] print_cpu+0x81c/0x830
 [<c012794a>] sched_debug_show+0x22a/0x430
 [<c0127b5c>] sysrq_sched_debug_show+0xc/0x10
 [<c012bb06>] show_state_filter+0x86/0xb0
 [<c02c95cd>] sysrq_handle_showstate_blocked+0xd/0x10
 [<c02c97a9>] __handle_sysrq+0x89/0x120
 [<c02c9873>] handle_sysrq+0x33/0x40
 [<c02c39ae>] kbd_keycode+0x39e/0x480
 [<c013b320>] ? __mod_timer+0xa0/0xb0
 [<c02c3b7a>] kbd_event+0xea/0x100
 [<c0386d0c>] input_pass_event+0xec/0x100
 [<c0386c20>] ? input_pass_event+0x0/0x100
 [<c013b3b6>] ? mod_timer+0x26/0x40
 [<c0386ef2>] input_handle_event+0xb2/0x2b0
 [<c038714f>] input_event+0x5f/0x80
 [<c03a1e2f>] hidinput_hid_event+0xef/0x390
 [<c039f410>] ? hid_input_field+0x40/0x340
 [<c039f3a3>] hid_process_event+0x63/0x90
 [<c039f695>] hid_input_field+0x2c5/0x340
 [<c039fc66>] hid_input_report+0x106/0x260
 [<c015322d>] ? put_lock_stats+0xd/0x30
 [<c01532b0>] ? lock_release_holdtime+0x60/0x80
 [<c03a44e1>] hid_irq_in+0x181/0x190
 [<c03816fa>] ? uhci_giveback_urb+0x8a/0x160
 [<c0368b31>] usb_hcd_giveback_urb+0x41/0xa0
 [<c0381707>] uhci_giveback_urb+0x97/0x160
 [<c0381840>] uhci_scan_qh+0x70/0x1c0
 [<c0381b0b>] uhci_scan_schedule+0x8b/0x130
 [<c03828f5>] uhci_irq+0xb5/0x150
 [<c0156b87>] ? __lock_release+0x47/0x70
 [<c0368ec4>] usb_hcd_irq+0x24/0x60
 [<c0164fd8>] handle_IRQ_event+0x28/0x60
 [<c016626e>] handle_fasteoi_irq+0x6e/0xd0
 [<c01078ac>] do_IRQ+0x3c/0x80
 [<c0151d2c>] ? tick_nohz_stop_sched_tick+0x25c/0x350
 [<c01059ca>] common_interrupt+0x2e/0x34
 [<c0103390>] ? mwait_idle_with_hints+0x40/0x50
 [<c01033a0>] ? mwait_idle+0x0/0x20
 [<c01033b2>] mwait_idle+0x12/0x20
 [<c0103141>] cpu_idle+0x61/0x110
 [<c04333bd>] rest_init+0x5d/0x60
 [<c05a47fa>] start_kernel+0x1fa/0x260
 [<c05a4190>] ? unknown_bootoption+0x0/0x130
 =======================
---[ end trace bc131943b9b4ac4c ]---
