Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbXEDOdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbXEDOdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbXEDOdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:33:03 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:60673 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358AbXEDOdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:33:00 -0400
Date: Fri, 4 May 2007 16:32:58 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.20.1] BUG: soft lockup detected on CPU#1!
Message-ID: <20070504143258.GN7874@vanheusden.com>
References: <20070503191120.GW7874@vanheusden.com> <6bffcb0e0705031331y4cbfafebof9522e326a989748@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0705031331y4cbfafebof9522e326a989748@mail.gmail.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Tue May  1 11:57:23 CEST 2007
X-Message-Flag: www.vanheusden.com
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The one of moments ago looks a little different. Still in show_trace_log but starting at a different source.

[361648.127868] usb 7-2: usbfs: USBDEVFS_CONTROL failed cmd newhidups rqt 161 rq 1 len 10 ret -110
[362269.228906] BUG: soft lockup detected on CPU#1!
[362269.228987]  [<c1004d53>] show_trace_log_lvl+0x1a/0x30
[362269.229116]  [<c1004d7b>] show_trace+0x12/0x14
[362269.229240]  [<c1004e75>] dump_stack+0x16/0x18
[362269.229358]  [<c104d52b>] softlockup_tick+0xa6/0xc2
[362269.229477]  [<c10267ae>] run_local_timers+0x12/0x14
[362269.229585]  [<c10265dc>] update_process_times+0x72/0xa1
[362269.229702]  [<c1038390>] tick_sched_timer+0x53/0xb6
[362269.229817]  [<c1033ba8>] hrtimer_interrupt+0x16b/0x1c2
[362269.229939]  [<c100e9e2>] local_apic_timer_interrupt+0x55/0x5b
[362269.230065]  [<c100ea12>] smp_apic_timer_interrupt+0x2a/0x39
[362269.230189]  [<c1004a3f>] apic_timer_interrupt+0x33/0x38
[362269.230312]  [<c120fdfc>] error_code+0x7c/0x84
[362269.230431]  [<c1099fbf>] padzero+0x1f/0x2d
[362269.230547]  [<c109a6c6>] load_elf_interp+0x200/0x2a3
[362269.230663]  [<c109b17d>] load_elf_binary+0x838/0xc38
[362269.230780]  [<c1073b20>] search_binary_handler+0x94/0x20a
[362269.230886]  [<c1073df6>] do_execve+0x160/0x1ee
[362269.230977]  [<c1002ce9>] sys_execve+0x32/0x8b
[362269.231065]  [<c1003f74>] syscall_call+0x7/0xb
[362269.231155]  =======================


On Thu, May 03, 2007 at 10:31:23PM +0200, Michal Piotrowski wrote:
> On 03/05/07, Folkert van Heusden <folkert@vanheusden.com> wrote:
> >My P4 with HT and 2GB of ram on an IDE disk succeeded in triggering
> >another bug:
> >
> >[273187.872796] usb 7-2: usbfs: USBDEVFS_CONTROL failed cmd newhidups rqt 
> >161 rq 1 len 10 ret -110
> >[273902.586320] BUG: soft lockup detected on CPU#1!
> >[273902.586385]  [<c1004d53>] show_trace_log_lvl+0x1a/0x30
> >[273902.586472]  [<c1004d7b>] show_trace+0x12/0x14
> >[273902.586557]  [<c1004e75>] dump_stack+0x16/0x18
> >[273902.586636]  [<c104d52b>] softlockup_tick+0xa6/0xc2
> >[273902.586724]  [<c10267ae>] run_local_timers+0x12/0x14
> >[273902.586810]  [<c10265dc>] update_process_times+0x72/0xa1
> >[273902.586893]  [<c1038390>] tick_sched_timer+0x53/0xb6
> >[273902.586977]  [<c1033ba8>] hrtimer_interrupt+0x16b/0x1c2
> >[273902.587062]  [<c100e9e2>] local_apic_timer_interrupt+0x55/0x5b
> >[273902.587147]  [<c100ea12>] smp_apic_timer_interrupt+0x2a/0x39
> >[273902.587230]  [<c1004a3f>] apic_timer_interrupt+0x33/0x38
> >[273902.587312]  [<c10020f2>] cpu_idle+0x6b/0x85
> >[273902.587393]  [<c130b218>] start_secondary+0xe8/0x30a
> >[273902.587476]  [<00000000>] 0x0
> >[273902.587568]  =======================
> >[277740.475464] usb 7-2: usbfs: USBDEVFS_CONTROL failed cmd newhidups rqt 
> >161 rq 1 len 10 ret -110
> >...
> >[285799.322391] usb 7-2: usbfs: USBDEVFS_CONTROL failed cmd newhidups rqt 
> >161 rq 1 len 10 ret -110
> >[286630.885843] BUG: soft lockup detected on CPU#1!
> >[286630.885901]  [<c1004d53>] show_trace_log_lvl+0x1a/0x30
> >[286630.885988]  [<c1004d7b>] show_trace+0x12/0x14
> >[286630.886071]  [<c1004e75>] dump_stack+0x16/0x18
> >[286630.886152]  [<c104d52b>] softlockup_tick+0xa6/0xc2
> >[286630.886235]  [<c10267ae>] run_local_timers+0x12/0x14
> >[286630.886323]  [<c10265dc>] update_process_times+0x72/0xa1
> >[286630.886406]  [<c1038390>] tick_sched_timer+0x53/0xb6
> >[286630.886488]  [<c1033ba8>] hrtimer_interrupt+0x16b/0x1c2
> >[286630.886571]  [<c100e9e2>] local_apic_timer_interrupt+0x55/0x5b
> >[286630.886657]  [<c100ea12>] smp_apic_timer_interrupt+0x2a/0x39
> >[286630.886741]  [<c1004a3f>] apic_timer_interrupt+0x33/0x38
> >[286630.886824]  [<c10020f2>] cpu_idle+0x6b/0x85
> >[286630.886907]  [<c130b218>] start_secondary+0xe8/0x30a
> >[286630.886991]  [<00000000>] 0x0
> >[286630.887088]  =======================
> >[290177.972351] usb 7-2: usbfs: USBDEVFS_CONTROL failed cmd newhidups rqt 
> >161 rq 1 len 10 ret -110
> >
> >My .config can be found here: 
> >http://keetweej.vanheusden.com/~folkert/config-2.6.21.1
> >
> >
> >Folkert van Heusden
> >
> 
> Thomas, this looks very similar to
> http://lkml.org/lkml/2007/5/2/511
> 
> Already on list of known regressions.
> 
> Regards,
> Michal
> 
> -- 
> Michal K. K. Piotrowski
> Kernel Monkeys
> (http://kernel.wikidot.com/start)


Folkert van Heusden

-- 
www.vanheusden.com/multitail - win een vlaai van multivlaai! zorg
ervoor dat multitail opgenomen wordt in Fedora Core, AIX, Solaris of
HP/UX en win een vlaai naar keuze
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
