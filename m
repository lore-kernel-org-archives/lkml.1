Return-Path: <linux-kernel-owner+w=401wt.eu-S1761281AbYCEQ4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761281AbYCEQ4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757267AbYCEQzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:55:35 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:52750 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760177AbYCEQzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:55:33 -0500
Date: Wed, 5 Mar 2008 08:55:31 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jike Song <albcamus@gmail.com>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc4 rcupreempt.h WARNINGs while suspend/resume
Message-ID: <20080305165531.GB8728@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <a8e1da0803042324ndd3873ay61cee6112d9dda9a@mail.gmail.com> <df9815e70803042335j4ea66028y96d6be21f0970aa1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df9815e70803042335j4ea66028y96d6be21f0970aa1@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 03:35:20PM +0800, Jike Song wrote:
> I have the very same problem. (Dell Optiplex 745, and 2.6.25-rc2 is
> fine with this)
> 
> Besides, when "echo mem > /sys/power/state", everything goes right;
> while "echo standby > /sys/power/state", the WARNING appears.

Could you please try applying Karsten Wiese's patch to see if it
fixes the WARNINGs?  See http://lkml.org/lkml/2008/2/26/386 for
the patch.

						Thanx, Paul

> On Wed, Mar 5, 2008 at 3:24 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> > Hi,
> >  don't know if it's fixed or not, with 2.6.25-rc4 after suspend/resume,
> >  my syslog full of rcupreempt warnings.
> >
> >  root@darkstar:/var/log# grep WARNING syslog|wc
> >  85499  940859 11223920
> >
> >  warnings are as following:
> >
> >  [ 4134.833641] ------------[ cut here ]------------
> >  [ 4134.833647] WARNING: at include/linux/rcupreempt.h:91
> >  tick_nohz_stop_sched_tick+0x39d/0x3b0()
> >  [ 4134.833650] Modules linked in: binfmt_misc rfcomm l2cap
> >  snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> >  snd_pcm_oss snd_mixer_oss thermal snd_hda_intel processor snd_pcm
> >  button sg hci_usb rtc_cmos bluetooth evdev rtc_core snd_timer snd
> >  pcspkr 3c59x i2c_i801 rtc_lib dcdbas serio_raw soundcore intel_agp
> >  agpgart snd_page_alloc
> >  [ 4134.833690] Pid: 0, comm: swapper Not tainted 2.6.25-rc4 #1
> >  [ 4134.833693]  [<c0128700>] ? zap_locks+0x30/0x70
> >  [ 4134.833700]  [<c0127ea4>] warn_on_slowpath+0x54/0x80
> >  [ 4134.833708]  [<c0140030>] ? hrtimer_init_sleeper+0x0/0x20
> >  [ 4134.833715]  [<c014c4ea>] ? __lock_acquired+0x10a/0x140
> >  [ 4134.833722]  [<c013fa05>] ? hrtimer_get_next_event+0x75/0xe0
> >  [ 4134.833728]  [<c014bf36>] ? __lock_release+0x26/0x70
> >  [ 4134.833734]  [<c013fa05>] ? hrtimer_get_next_event+0x75/0xe0
> >  [ 4134.833741]  [<c03d5989>] ? _spin_unlock_irqrestore+0x39/0x70
> >  [ 4134.833749]  [<c013fa05>] ? hrtimer_get_next_event+0x75/0xe0
> >  [ 4134.833757]  [<c013188b>] ? cmp_next_hrtimer_event+0x1b/0xa0
> >  [ 4134.833765]  [<c01470dd>] tick_nohz_stop_sched_tick+0x39d/0x3b0
> >  [ 4134.833772]  [<c03d3059>] ? __sched_text_start+0x229/0x4c0
> >  [ 4134.833781]  [<c0103030>] ? default_idle+0x0/0xa0
> >  [ 4134.833787]  [<c0103117>] cpu_idle+0x37/0x140
> >  [ 4134.833793]  [<c03d0e7f>] start_secondary+0x9f/0xc0
> >  [ 4134.833802]  =======================
> >  [ 4134.833805] ---[ end trace f3669ad1d62556af ]---
> >  [ 4134.833811] ------------[ cut here ]------------
> >  [ 4134.833814] WARNING: at include/linux/rcupreempt.h:99
> >  tick_nohz_restart_sched_tick+0x17a/0x180()
> >  [ 4134.833817] Modules linked in: binfmt_misc rfcomm l2cap
> >  snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> >  snd_pcm_oss snd_mixer_oss thermal snd_hda_intel processor snd_pcm
> >  button sg hci_usb rtc_cmos bluetooth evdev rtc_core snd_timer snd
> >  pcspkr 3c59x i2c_i801 rtc_lib dcdbas serio_raw soundcore intel_agp
> >  agpgart snd_page_alloc
> >  [ 4134.833855] Pid: 0, comm: swapper Not tainted 2.6.25-rc4 #1
> >  [ 4134.833857]  [<c0128700>] ? zap_locks+0x30/0x70
> >  [ 4134.833864]  [<c0127ea4>] warn_on_slowpath+0x54/0x80
> >  [ 4134.833873]  [<c013f81d>] ? hrtimer_start+0xdd/0x150
> >  [ 4134.833879]  [<c014bf36>] ? __lock_release+0x26/0x70
> >  [ 4134.833885]  [<c013f81d>] ? hrtimer_start+0xdd/0x150
> >  [ 4134.833892]  [<c010ac18>] ? read_tsc+0x8/0x10
> >  [ 4134.833898]  [<c014212e>] ? getnstimeofday+0x3e/0x120
> >  [ 4134.833906]  [<c013ee78>] ? ktime_get_ts+0x58/0x60
> >  [ 4134.833914]  [<c013edcf>] ? ktime_get+0xf/0x30
> >  [ 4134.833921]  [<c0103030>] ? default_idle+0x0/0xa0
> >  [ 4134.833927]  [<c014729a>] tick_nohz_restart_sched_tick+0x17a/0x180
> >  [ 4134.833934]  [<c0103030>] ? default_idle+0x0/0xa0
> >  [ 4134.833940]  [<c01031c0>] cpu_idle+0xe0/0x140
> >  [ 4134.833946]  [<c03d0e7f>] start_secondary+0x9f/0xc0
> >  [ 4134.833955]  =======================
> >  --
> >  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >  the body of a message to majordomo@vger.kernel.org
> >  More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >  Please read the FAQ at  http://www.tux.org/lkml/
> >
