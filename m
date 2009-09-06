Return-Path: <linux-kernel-owner+w=401wt.eu-S1758286AbZIFXJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286AbZIFXJW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 19:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758212AbZIFXJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 19:09:21 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:54768 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758203AbZIFXJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 19:09:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=M4nqrJxt3j8JYLCHe6TpYy5Y/2rM2gmBrcp+lhK/tFnChYWh/mANzszWReVqEn3fLY
         ZVS/eopp9Yeye7dmx7KZ8tOoEWfOFpOE0sFNvQ6AP17HscNuzWeALINYcy/7eXpDTxwN
         fS54BK3W/3ZjvJLRPSsWc70gUI82sbTIEJcRI=
Subject: Re: [BUG] partial and rare system freeze
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <20090906225216.GA6268@nowhere>
References: <1252271151.32726.19.camel@localhost.localdomain>
	 <20090906225216.GA6268@nowhere>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 02:09:17 +0300
Message-Id: <1252278557.14692.1.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-07 at 00:52 +0200, Frederic Weisbecker wrote:
> On Mon, Sep 07, 2009 at 12:05:51AM +0300, Maxim Levitsky wrote:
> > I have noticed that sometimes keyboard input would stop working, and
> > system will refuse to do many things.
> > 
> > I tried to ssh to this system, but again after a login I can't type a
> > thing.
> > 
> > Then I realized that I can run a program via ssh, so I did run the
> > dmesg, and here important parts of it:
> > 
> > 
> > 
> > 
> > [   79.101221] ACPI Error (dswload-0790): [_T_0] Namespace lookup failure, AE_ALREADY_EXISTS
> > [   79.101232] ACPI Exception: AE_ALREADY_EXISTS, During name lookup/catalog 20090521 psloop-227
> > [   79.101240] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.WMID.WMBA] (Node ffff88007f8400c0), AE_ALREADY_EXISTS
> > [   79.101254] ACPI: Marking method WMBA as Serialized because of AE_ALREADY_EXISTS error
> > 
> > Is very likely due to acer-wmi module I use to control brightness.
> > 
> > 
> > Then it bugs out with this:
> > 
> > [   79.101221] ACPI Error (dswload-0790): [_T_0] Namespace lookup failure, AE_ALREADY_EXISTS
> > [   79.101232] ACPI Exception: AE_ALREADY_EXISTS, During name lookup/catalog 20090521 psloop-227
> > [   79.101240] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.WMID.WMBA] (Node ffff88007f8400c0), AE_ALREADY_EXISTS
> > [   79.101254] ACPI: Marking method WMBA as Serialized because of AE_ALREADY_EXISTS error
> > [  134.543609] No probe response from AP 00:1b:9e:d8:77:02 after 500ms, try 1
> > [  240.702553] INFO: task events/0:10 blocked for more than 120 seconds.
> > [  240.702561] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  240.702566] events/0      D ffff880002073980     0    10      2 0x00000000
> > [  240.702578] BUG: using smp_processor_id() in preemptible [00000000] code: khungtaskd/275
> > [  240.702589] caller is show_stack_log_lvl+0x29/0x160
> > [  240.702596] Pid: 275, comm: khungtaskd Tainted: P           2.6.31-rc8-wl #105
> > [  240.702600] Call Trace:
> > [  240.702612]  [<ffffffff811f5a8d>] debug_smp_processor_id+0xdd/0xe0
> > [  240.702619]  [<ffffffff8100f3b9>] show_stack_log_lvl+0x29/0x160
> > [  240.702627]  [<ffffffff81010ba7>] show_stack+0x17/0x20
> > [  240.702635]  [<ffffffff81040315>] sched_show_task+0x95/0x100
> > [  240.702644]  [<ffffffff8108eea1>] watchdog+0x211/0x240
> > [  240.702651]  [<ffffffff8108ec90>] ? watchdog+0x0/0x240
> > [  240.702659]  [<ffffffff81061c56>] kthread+0xa6/0xc0
> > [  240.702667]  [<ffffffff8100d05a>] child_rip+0xa/0x20
> > [  240.702676]  [<ffffffff8100c9c0>] ? restore_args+0x0/0x30
> > [  240.702683]  [<ffffffff81061bb0>] ? kthread+0x0/0xc0
> > [  240.702689]  [<ffffffff8100d050>] ? child_rip+0x0/0x20
> > [  240.702694]  ffff88007f8a39d0 0000000000000046 000000007f8a3910 ffff880002070380
> > [  240.702705]  0000000000013980 000000000000ef28 0000000000000000 ffff88007f893ee0
> > [  240.702715]  ffff8800673d1f70 ffff88007f894260 000000007f8a3950 ffffffff8125d19d
> > [  240.702726] Call Trace:
> > [  240.702735]  [<ffffffff8125d19d>] ? acpi_ut_validate_exception+0x10/0xa2
> > [  240.702742]  [<ffffffff8125bbd8>] ? acpi_ut_status_exit+0x6f/0x84
> > [  240.702752]  [<ffffffff813b470d>] schedule_timeout+0x1ad/0x1e0
> > [  240.702760]  [<ffffffff813b5e1d>] __down_timeout+0x6d/0xb0
> > [  240.702768]  [<ffffffff81066cef>] ? down_timeout+0x1f/0x60
> > [  240.702775]  [<ffffffff81066d28>] down_timeout+0x58/0x60
> > [  240.702783]  [<ffffffff81228be0>] acpi_os_wait_semaphore+0x95/0x132
> > [  240.702790]  [<ffffffff8125bc1e>] ? acpi_ut_exit+0x31/0x39
> > [  240.702799]  [<ffffffff812473ae>] acpi_ex_system_wait_mutex+0x84/0xed
> > [  240.702807]  [<ffffffff81237cfc>] acpi_ds_begin_method_execution+0x184/0x271
> > [  240.702816]  [<ffffffff81257010>] acpi_ps_execute_method+0x77/0x3d3
> > [  240.702823]  [<ffffffff8125bc1e>] ? acpi_ut_exit+0x31/0x39
> > [  240.702830]  [<ffffffff8125066e>] acpi_ns_evaluate+0x236/0x3bc
> > [  240.702838]  [<ffffffff8124fb27>] acpi_evaluate_object+0x265/0x3cc
> > [  240.702861]  [<ffffffffa09c56fa>] wmi_evaluate_method+0x10a/0x130 [wmi]
> > [  240.702869]  [<ffffffff81040956>] ? finish_task_switch+0x46/0x120
> > [  240.702877]  [<ffffffff813b3c9c>] ? thread_return+0x9f/0x723
> > [  240.702889]  [<ffffffffa0a9d7d0>] ? acer_rfkill_update+0x0/0xa0 [acer_wmi]
> > [  240.702899]  [<ffffffffa0a9d17c>] WMI_execute_u32+0x4c/0x90 [acer_wmi]
> > [  240.702911]  [<ffffffffa0a9d620>] get_u32+0x90/0x100 [acer_wmi]
> > [  240.702918]  [<ffffffff8105d19a>] ? worker_thread+0x1ca/0x390
> > [  240.702928]  [<ffffffffa0a9d7ea>] acer_rfkill_update+0x1a/0xa0 [acer_wmi]
> > [  240.702936]  [<ffffffff8105d1ed>] worker_thread+0x21d/0x390
> > [  240.702943]  [<ffffffff8105d19a>] ? worker_thread+0x1ca/0x390
> > [  240.702951]  [<ffffffff810620e0>] ? autoremove_wake_function+0x0/0x40
> > [  240.702959]  [<ffffffff81072ddd>] ? trace_hardirqs_on+0xd/0x10
> > [  240.702967]  [<ffffffff8105cfd0>] ? worker_thread+0x0/0x390
> > [  240.702974]  [<ffffffff81061c56>] kthread+0xa6/0xc0
> > [  240.702982]  [<ffffffff8100d05a>] child_rip+0xa/0x20
> > [  240.702990]  [<ffffffff8100c9c0>] ? restore_args+0x0/0x30
> > [  240.702997]  [<ffffffff81061bb0>] ? kthread+0x0/0xc0
> > [  240.703003]  [<ffffffff8100d050>] ? child_rip+0x0/0x20
> > [  240.703007] INFO: lockdep is turned off.
> > [  240.703043] INFO: task gnome-keyring-d:3915 blocked for more than 120 seconds.
> > [  240.703048] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  240.703053] gnome-keyring D ffff880002073980     0  3915      1 0x00000000
> > [  240.703063] BUG: using smp_processor_id() in preemptible [00000000] code: khungtaskd/275
> > [  240.703070] caller is show_stack_log_lvl+0x29/0x160
> > [  240.703075] Pid: 275, comm: khungtaskd Tainted: P           2.6.31-rc8-wl #105
> 
> 
> 
> Looks like the wireless tree and a version based on -rc8.
> 
> It would be nice to test it on -rc9 Linus tree and on latest
> wireless tree as well.
> 

This happens very rarely.
wireless-testing tree pulled yesterday.

Best regards,
	Maxim Levitsky

