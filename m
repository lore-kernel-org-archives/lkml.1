Return-Path: <linux-kernel-owner+w=401wt.eu-S934994AbYBVDSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934994AbYBVDSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 22:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbYBVDST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 22:18:19 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:26513 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933152AbYBVDSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 22:18:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=I5oL2iJz1YWWy2SUXYu2Fry0YHD/fbrSS553JPICGB6MpeFbM7Ct+yDifdUaXhCQ2/Dg7tPZlUjdKPZCOqWqXhML9Egyu0yqSh+FiJYdriX19/gJh8IRDQCIF5C1Ldj1JFo8aOopDUwyDeunPEkEB/nS1tfVzo5mYN6P9tmboHM=
Date: Fri, 22 Feb 2008 11:23:50 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Quel Qun <kelk1@comcast.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Kernel oops with bluetooth usb dongle
Message-ID: <20080222031752.GA3198@darkstar.te-china.tietoenator.com>
References: <022220080240.25836.47BE362900072A1C000064EC2200761394CE05040A05@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <022220080240.25836.47BE362900072A1C000064EC2200761394CE05040A05@comcast.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 02:40:41AM +0000, Quel Qun wrote:
> 
>  -------------- Original message ----------------------
> From: Thomas Gleixner <tglx@linutronix.de>
> > On Thu, 21 Feb 2008, Quel Qun wrote:
> > > > >  > Not that I'm aware off, but this might as well be some old use after
> > > > >  > free bug which got exposed by some unrelated change. The good news is
> > > > >  > that it is reproducible. I'll hack up some nasty debug patch which
> > > > >  > lets us - hopefully - decode where the timer was armed.
> > > > >
> > > > >  Quel, before I do that, is there any chance that you retest with the
> > > > >  latest mainline git version ?
> > > > >
> > > > >  
> > > > 
> > http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.25-rc2-git4.bz2
> > > > 
> > > > And please test with this patch as well:
> > > > 
> > > > http://lkml.org/lkml/2008/2/20/121
> > > > 
> > > Same kind of result unfortunately with this last patch on top of git4:
> > 
> > At least it is fully reproducible. Please apply the patch below to
> > your git4 tree and do not change your .config. The output should show,
> > which code armed the timer.
> > 
> Thomas,
> 
> Thanks for the patch, but that did not work, I never got the trace.
> 
> I switched to git5 and applied the patch.
> 
> First crash (= attached kernlog.9) showed some hald process, so I decided to reduce the number of services and processes to a maximum. Attached are process list before starting sdptool browse and crashing, list of modules and list of services.
> 
> Second crash:
> 
> BUG: unable to handle kernel paging request at 6b6b6b6b
> IP: [<c012d51d>] get_next_timer_interrupt+0x11f/0x234
> *pde = 00000000
> Oops: 0000 [#1] SMP
> Modules linked in: hidp rfcomm l2cap nfsd exportfs nfs lockd nfs_acl sunrpc autofs4 af_packet binfmt_misc loop nls_iso8859_1 nls_cp437 vfat fat fuse snd_pcm_oss snd_mixer_oss snd_intel8x0 snd_ac97_codec hci_usb ac97_bus snd_pcm parport_pc snd_timer snd sr_mod i2c_i801 rtc_cmos iTCO_wdt i2c_core parport soundcore iTCO_vendor_support pcspkr snd_page_alloc bluetooth button thermal processor evdev dcdbas tg3 sg ide_disk piix ide_core ata_piix ahci libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: scsi_wait_scan]
> 
> Pid: 0, comm: swapper Not tainted (2.6.25-rc2-git5kk1 #1)
> EIP: 0060:[<c012d51d>] EFLAGS: 00010002 CPU: 0
> EIP is at get_next_timer_interrupt+0x11f/0x234
> EAX: 6b6b6b6b EBX: 3ffda6f6 ECX: c0432744 EDX: 6b6b6b6b
> ESI: 00000027 EDI: c043260c EBP: c03b1ee8 ESP: c03b1eac
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process swapper (pid: 0, ti=c03b0000 task=c03813a0 task.ti=c03b0000)
> Stack: fffda6f6 c0431e00 00000000 fffda700 00000001 000000f7 00000027 00fffda7
>        c043260c c043280c c0432a0c c0432c0c c18090c0 0643e180 fffda6f6 c03b1f2c
>        c013fb78 00000001 c03a3b08 00000046 c03b1f20 0644b3c1 00000022 0643e180
> Call Trace:
>  [<c013fb78>] ? tick_nohz_stop_sched_tick+0x130/0x337
>  [<c0129a54>] ? irq_exit+0x55/0x6e
>  [<c01146e7>] ? smp_apic_timer_interrupt+0x59/0x92
>  [<c010582c>] ? apic_timer_interrupt+0x28/0x30
>  [<c013007b>] ? get_signal_to_deliver+0x2d8/0x332
>  [<c011879f>] ? native_safe_halt+0x5/0x7
>  [<c0103965>] ? default_idle+0x4d/0x7f
>  [<c0103918>] ? default_idle+0x0/0x7f
>  [<c01037c4>] ? cpu_idle+0x6f/0x100
>  [<c02e2e89>] ? rest_init+0x49/0x50
>  =======================
> Code: 85 e0 8b 4d e0 83 e1 3f 89 4d dc 89 ce 8b 04 f7 8b 10 0f 18 02 90 8d 0c f7 39 c8 0f 84 8d 00 00 00 8b 40 08 39 d8 0f 48 d8 89 d0 <8b> 12 0f 18 02 90 39 c8 75 ec c7 45 cc 01 00 00 00 8b 7d dc 85
> EIP: [<c012d51d>] get_next_timer_interrupt+0x11f/0x234
> 
> $ addr2line -e vmlinux c012d51d
> /usr/src/linux-2.6.25-rc2-git5kk1/kernel/timer.c:770
> 
> Crap, that is on the next list_for_each_entry in timer.c :(
> 
> I tried to make a similar test loop as you did a few lines above:
> 
> @@ -718,6 +767,14 @@
>  
>  		index = slot = timer_jiffies & TVN_MASK;
>  		do {
> +			struct list_head *tmp;
> +
> +			__list_for_each(tmp, varp->vec + slot) {
> +				nte = (struct timer_list *) tmp;
> +				if (nte->entry.next == (void *)0x6b6b6b6b)
> +					ttrace_find_timer(nte);
> +			}
> +
>  			list_for_each_entry(nte, varp->vec + slot, entry) {
>  				found = 1;
>  				if (time_before(nte->expires, expires))
> 
> I thought I got it on the next crash, but the system locked too fast, and the only thing I saw was:
> 
> TTRACE timer f7b52858 fn f8e7c608 addr c012d776
> TTRACE fn l2cap_info_timeout
> TTRACE addr mod_timer
> BUG: unable to handle kernel paging request at 6b6b6b6b
> IP:
> 
> $ addr2line -e vmlinux.kk1 c012d776
> /usr/src/linux-2.6.25-rc2-git5kk1/kernel/timer.c:533
> 
> int mod_timer(struct timer_list *timer, unsigned long expires)
> {
>         BUG_ON(!timer->function);
> 
>         timer_stats_timer_set_start_info(timer);
>         /*
>          * This is a common optimization triggered by the
>          * networking code - if the timer is re-modified
>          * to be the same thing then just return:
>          */
>         if (timer->expires == expires && timer_pending(timer))
>                 return 1;
> 
>         return __mod_timer(timer, expires);
> }     <<<< line 533 is here
> 
> Unfortunately, I never got anything more. After that, the only thing I got, even without my changes, was:
> 
> list_add corruption. prev->next should be next (c0432764), but was 6b6b6b6b. (prev=f6d6e908).
> ------------[ cut here ]------------
> kernel BUG at lib/list_debug.c:33!
> invalid opcode: 0000 [#1] SMP
> Modules linked in: hidp rfcomm l2cap binfmt_misc loop nls_iso8859_1 nls_cp437 vfat fat fuse snd_pcm_oss snd_mixer_oss snd_intel8x0 sr_mod snd_ac97_codec ac97_bus snd_pcm parport_pc snd_timer parport snd soundcore i2c_i801 i2c_core hci_usb snd_page_alloc bluetooth rtc_cmos pcspkr iTCO_wdt iTCO_vendor_support tg3 processor button evdev dcdbas sg ide_disk piix ide_core ata_piix ahci libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: scsi_wait_scan]
> 
> Pid: 8, comm: events/0 Not tainted (2.6.25-rc2-git5kk1 #3)
> EIP: 0060:[<c01f5703>] EFLAGS: 00010086 CPU: 0
> EIP is at __list_add+0x5a/0x5e
> EAX: 00000061 EBX: c18093d0 ECX: 00000001 EDX: 00000096
> ESI: c18093d0 EDI: c0431e00 EBP: f788defc ESP: f788dee8
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process events/0 (pid: 8, ti=f788c000 task=f785cc60 task.ti=f788c000)
> Stack: c035609c c0432764 6b6b6b6b f6d6e908 fffd277d f788df0c c012cba2 c18093d0
>        c0431e00 f788df2c c012d2cc fffd2b64 00000000 00000286 c18093c0 c18093d0
>        f7811690 f788df44 c0133ee6 ffffffff c18093c0 000003e8 f7811690 f788df5c
> Call Trace:
>  [<c012cba2>] ? internal_add_timer+0x53/0xb4
>  [<c012d2cc>] ? __mod_timer+0xe9/0x102
>  [<c0133ee6>] ? queue_delayed_work_on+0x84/0xb7
>  [<c0133f71>] ? queue_delayed_work+0x40/0x48
>  [<c0169025>] ? vmstat_update+0x0/0x28
>  [<c0133f9b>] ? schedule_delayed_work+0x22/0x26
>  [<c016904b>] ? vmstat_update+0x26/0x28
>  [<c01337d4>] ? run_workqueue+0xc1/0x150
>  [<c0134022>] ? worker_thread+0x83/0xd9
>  [<c013676e>] ? autoremove_wake_function+0x0/0x38
>  [<c0133f9f>] ? worker_thread+0x0/0xd9
>  [<c01364c4>] ? kthread+0x37/0x59
>  [<c013648d>] ? kthread+0x0/0x59
>  [<c01059bb>] ? kernel_thread_helper+0x7/0x1c
>  =======================
> Code: 54 24 04 c7 04 24 4c 60 35 c0 e8 f1 fe f2 ff 0f 0b eb fe 89 44 24 0c 89 54 24 08 89 4c 24 04 c7 04 24 9c 60 35 c0 e8 d5 fe f2 ff <0f> 0b eb fe 55 89 e5 8b 0a e8 98 ff ff ff 5d c3 90 55 89 e5 53
> EIP: [<c01f5703>] __list_add+0x5a/0x5e SS:ESP 0068:f788dee8
> ---[ end trace bd4e31c9ceb47c4f ]---
> 
> I hope the tiny bit of trace can trigger some idea. At least l2cap has something to do with bluetooth. l2cap_info_timeout is line 360 of net/bluetooth/l2cap.c, apparently only called from l2cap_conn_add, line 391: setup_timer(&conn->info_timer, l2cap_info_timeout, (unsigned long)conn);
> 
> After four hours and ten crashes today, it is the little I got. Kernel stuff is tough...
> --
> kk1

Could you try the following patch? I'm not so sure whether put del_timer
here safe or not.

diff -upr linux/net/bluetooth/l2cap.c linux.new/net/bluetooth/l2cap.c
--- linux/net/bluetooth/l2cap.c	2008-02-22 11:11:33.000000000 +0800
+++ linux.new/net/bluetooth/l2cap.c	2008-02-22 11:14:12.000000000 +0800
@@ -418,6 +418,7 @@ static void l2cap_conn_del(struct hci_co
 	}
 
 	hcon->l2cap_data = NULL;
+	del_timer(&conn->info_timer);
 	kfree(conn);
 }
 
