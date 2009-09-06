Return-Path: <linux-kernel-owner+w=401wt.eu-S1758694AbZIFVF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694AbZIFVF5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 17:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758515AbZIFVF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 17:05:56 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58201 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758435AbZIFVFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 17:05:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=bkkG/aOcQqJcFbSbBQoLEqyoeRXrkUmH646PTCrbXpSfJrunaHCyhTKe0y6edaEzze
         G+1nvMpwiuKHL1c++koO+6X2buoWTEIwsaEg7C/Z1jHyGV3xnlpqAcF5BSGROfuL1mhJ
         DNR5+e2+540LT5V+S+VFOgUZJpdJyf9PsnQZw=
Subject: [BUG] partial and rare system freeze
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 00:05:51 +0300
Message-Id: <1252271151.32726.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have noticed that sometimes keyboard input would stop working, and
system will refuse to do many things.

I tried to ssh to this system, but again after a login I can't type a
thing.

Then I realized that I can run a program via ssh, so I did run the
dmesg, and here important parts of it:




[   79.101221] ACPI Error (dswload-0790): [_T_0] Namespace lookup failure, AE_ALREADY_EXISTS
[   79.101232] ACPI Exception: AE_ALREADY_EXISTS, During name lookup/catalog 20090521 psloop-227
[   79.101240] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.WMID.WMBA] (Node ffff88007f8400c0), AE_ALREADY_EXISTS
[   79.101254] ACPI: Marking method WMBA as Serialized because of AE_ALREADY_EXISTS error

Is very likely due to acer-wmi module I use to control brightness.


Then it bugs out with this:

[   79.101221] ACPI Error (dswload-0790): [_T_0] Namespace lookup failure, AE_ALREADY_EXISTS
[   79.101232] ACPI Exception: AE_ALREADY_EXISTS, During name lookup/catalog 20090521 psloop-227
[   79.101240] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.WMID.WMBA] (Node ffff88007f8400c0), AE_ALREADY_EXISTS
[   79.101254] ACPI: Marking method WMBA as Serialized because of AE_ALREADY_EXISTS error
[  134.543609] No probe response from AP 00:1b:9e:d8:77:02 after 500ms, try 1
[  240.702553] INFO: task events/0:10 blocked for more than 120 seconds.
[  240.702561] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.702566] events/0      D ffff880002073980     0    10      2 0x00000000
[  240.702578] BUG: using smp_processor_id() in preemptible [00000000] code: khungtaskd/275
[  240.702589] caller is show_stack_log_lvl+0x29/0x160
[  240.702596] Pid: 275, comm: khungtaskd Tainted: P           2.6.31-rc8-wl #105
[  240.702600] Call Trace:
[  240.702612]  [<ffffffff811f5a8d>] debug_smp_processor_id+0xdd/0xe0
[  240.702619]  [<ffffffff8100f3b9>] show_stack_log_lvl+0x29/0x160
[  240.702627]  [<ffffffff81010ba7>] show_stack+0x17/0x20
[  240.702635]  [<ffffffff81040315>] sched_show_task+0x95/0x100
[  240.702644]  [<ffffffff8108eea1>] watchdog+0x211/0x240
[  240.702651]  [<ffffffff8108ec90>] ? watchdog+0x0/0x240
[  240.702659]  [<ffffffff81061c56>] kthread+0xa6/0xc0
[  240.702667]  [<ffffffff8100d05a>] child_rip+0xa/0x20
[  240.702676]  [<ffffffff8100c9c0>] ? restore_args+0x0/0x30
[  240.702683]  [<ffffffff81061bb0>] ? kthread+0x0/0xc0
[  240.702689]  [<ffffffff8100d050>] ? child_rip+0x0/0x20
[  240.702694]  ffff88007f8a39d0 0000000000000046 000000007f8a3910 ffff880002070380
[  240.702705]  0000000000013980 000000000000ef28 0000000000000000 ffff88007f893ee0
[  240.702715]  ffff8800673d1f70 ffff88007f894260 000000007f8a3950 ffffffff8125d19d
[  240.702726] Call Trace:
[  240.702735]  [<ffffffff8125d19d>] ? acpi_ut_validate_exception+0x10/0xa2
[  240.702742]  [<ffffffff8125bbd8>] ? acpi_ut_status_exit+0x6f/0x84
[  240.702752]  [<ffffffff813b470d>] schedule_timeout+0x1ad/0x1e0
[  240.702760]  [<ffffffff813b5e1d>] __down_timeout+0x6d/0xb0
[  240.702768]  [<ffffffff81066cef>] ? down_timeout+0x1f/0x60
[  240.702775]  [<ffffffff81066d28>] down_timeout+0x58/0x60
[  240.702783]  [<ffffffff81228be0>] acpi_os_wait_semaphore+0x95/0x132
[  240.702790]  [<ffffffff8125bc1e>] ? acpi_ut_exit+0x31/0x39
[  240.702799]  [<ffffffff812473ae>] acpi_ex_system_wait_mutex+0x84/0xed
[  240.702807]  [<ffffffff81237cfc>] acpi_ds_begin_method_execution+0x184/0x271
[  240.702816]  [<ffffffff81257010>] acpi_ps_execute_method+0x77/0x3d3
[  240.702823]  [<ffffffff8125bc1e>] ? acpi_ut_exit+0x31/0x39
[  240.702830]  [<ffffffff8125066e>] acpi_ns_evaluate+0x236/0x3bc
[  240.702838]  [<ffffffff8124fb27>] acpi_evaluate_object+0x265/0x3cc
[  240.702861]  [<ffffffffa09c56fa>] wmi_evaluate_method+0x10a/0x130 [wmi]
[  240.702869]  [<ffffffff81040956>] ? finish_task_switch+0x46/0x120
[  240.702877]  [<ffffffff813b3c9c>] ? thread_return+0x9f/0x723
[  240.702889]  [<ffffffffa0a9d7d0>] ? acer_rfkill_update+0x0/0xa0 [acer_wmi]
[  240.702899]  [<ffffffffa0a9d17c>] WMI_execute_u32+0x4c/0x90 [acer_wmi]
[  240.702911]  [<ffffffffa0a9d620>] get_u32+0x90/0x100 [acer_wmi]
[  240.702918]  [<ffffffff8105d19a>] ? worker_thread+0x1ca/0x390
[  240.702928]  [<ffffffffa0a9d7ea>] acer_rfkill_update+0x1a/0xa0 [acer_wmi]
[  240.702936]  [<ffffffff8105d1ed>] worker_thread+0x21d/0x390
[  240.702943]  [<ffffffff8105d19a>] ? worker_thread+0x1ca/0x390
[  240.702951]  [<ffffffff810620e0>] ? autoremove_wake_function+0x0/0x40
[  240.702959]  [<ffffffff81072ddd>] ? trace_hardirqs_on+0xd/0x10
[  240.702967]  [<ffffffff8105cfd0>] ? worker_thread+0x0/0x390
[  240.702974]  [<ffffffff81061c56>] kthread+0xa6/0xc0
[  240.702982]  [<ffffffff8100d05a>] child_rip+0xa/0x20
[  240.702990]  [<ffffffff8100c9c0>] ? restore_args+0x0/0x30
[  240.702997]  [<ffffffff81061bb0>] ? kthread+0x0/0xc0
[  240.703003]  [<ffffffff8100d050>] ? child_rip+0x0/0x20
[  240.703007] INFO: lockdep is turned off.
[  240.703043] INFO: task gnome-keyring-d:3915 blocked for more than 120 seconds.
[  240.703048] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.703053] gnome-keyring D ffff880002073980     0  3915      1 0x00000000
[  240.703063] BUG: using smp_processor_id() in preemptible [00000000] code: khungtaskd/275
[  240.703070] caller is show_stack_log_lvl+0x29/0x160
[  240.703075] Pid: 275, comm: khungtaskd Tainted: P           2.6.31-rc8-wl #105
[  240.703079] Call Trace:
[  240.703085]  [<ffffffff811f5a8d>] debug_smp_processor_id+0xdd/0xe0
[  240.703092]  [<ffffffff8100f3b9>] show_stack_log_lvl+0x29/0x160
[  240.703100]  [<ffffffff81010ba7>] show_stack+0x17/0x20
[  240.703106]  [<ffffffff81040315>] sched_show_task+0x95/0x100
[  240.703114]  [<ffffffff8108eea1>] watchdog+0x211/0x240
[  240.703121]  [<ffffffff8108ec90>] ? watchdog+0x0/0x240
[  240.703128]  [<ffffffff81061c56>] kthread+0xa6/0xc0
[  240.703135]  [<ffffffff8100d05a>] child_rip+0xa/0x20
[  240.703143]  [<ffffffff8100c9c0>] ? restore_args+0x0/0x30
[  240.703150]  [<ffffffff81061bb0>] ? kthread+0x0/0xc0
[  240.703156]  [<ffffffff8100d050>] ? child_rip+0x0/0x20
[  240.703160]  ffff88006ab93d18 0000000000000046 ffff88006ab93c88 ffffffff810a7373
[  240.703171]  0000000000013980 000000000000ef28 0000000000000000 ffff88006a951f70
[  240.703182]  ffff88006a950000 ffff88006a9522f0 000000006ab93c88 0000000181072ddd
[  240.703192] Call Trace:
[  240.703200]  [<ffffffff810a7373>] ? rmqueue_bulk+0xb3/0xe0
[  240.703210]  [<ffffffff813b470d>] schedule_timeout+0x1ad/0x1e0
[  240.703217]  [<ffffffff813b34a3>] ? wait_for_common+0x43/0x190
[  240.703225]  [<ffffffff813b35bc>] wait_for_common+0x15c/0x190
[  240.703233]  [<ffffffff81043300>] ? default_wake_function+0x0/0x10
[  240.703241]  [<ffffffff810acd40>] ? lru_add_drain_per_cpu+0x0/0x10
[  240.703249]  [<ffffffff813b3688>] wait_for_completion+0x18/0x20
[  240.703256]  [<ffffffff8105df2a>] flush_work+0xca/0x110
[  240.703262]  [<ffffffff8105de9c>] ? flush_work+0x3c/0x110
[  240.703270]  [<ffffffff8105d810>] ? wq_barrier_func+0x0/0x10
[  240.703278]  [<ffffffff8105e353>] schedule_on_each_cpu+0xe3/0x130
[  240.703286]  [<ffffffff810ac7b0>] lru_add_drain_all+0x10/0x20
[  240.703294]  [<ffffffff810be9b5>] sys_mlock+0x45/0x110
[  240.703302]  [<ffffffff8100bf6b>] system_call_fastpath+0x16/0x1b
[  240.703307] INFO: lockdep is turned off.
[  240.703314] INFO: task nm-applet:3992 blocked for more than 120 seconds.
[  240.703318] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.703322] nm-applet     D ffff880002073980     0  3992   3782 0x00000000
[  240.703332] BUG: using smp_processor_id() in preemptible [00000000] code: khungtaskd/275
[  240.703339] caller is show_stack_log_lvl+0x29/0x160
[  240.703344] Pid: 275, comm: khungtaskd Tainted: P           2.6.31-rc8-wl #105
[  240.703348] Call Trace:
[  240.703355]  [<ffffffff811f5a8d>] debug_smp_processor_id+0xdd/0xe0
[  240.703362]  [<ffffffff8100f3b9>] show_stack_log_lvl+0x29/0x160
[  240.703369]  [<ffffffff81010ba7>] show_stack+0x17/0x20
[  240.703376]  [<ffffffff81040315>] sched_show_task+0x95/0x100
[  240.703383]  [<ffffffff8108eea1>] watchdog+0x211/0x240
[  240.703390]  [<ffffffff8108ec90>] ? watchdog+0x0/0x240
[  240.703398]  [<ffffffff81061c56>] kthread+0xa6/0xc0
[  240.703405]  [<ffffffff8100d05a>] child_rip+0xa/0x20
[  240.703412]  [<ffffffff8100c9c0>] ? restore_args+0x0/0x30
[  240.703420]  [<ffffffff81061bb0>] ? kthread+0x0/0xc0
[  240.703426]  [<ffffffff8100d050>] ? child_rip+0x0/0x20
[  240.703430]  ffff880065cc3d18 0000000000000046 0000000000000000 000000470000001b
[  240.703440]  0000000000013980 000000000000ef28 0000000000000000 ffff880065e20000
[  240.703451]  ffff88006f530000 ffff880065e20380 0000000065cc3c88 ffffffff81072ddd
[  240.703461] Call Trace:
[  240.703468]  [<ffffffff81072ddd>] ? trace_hardirqs_on+0xd/0x10
[  240.703477]  [<ffffffff813b470d>] schedule_timeout+0x1ad/0x1e0
[  240.703484]  [<ffffffff813b34a3>] ? wait_for_common+0x43/0x190
[  240.703492]  [<ffffffff813b35bc>] wait_for_common+0x15c/0x190
[  240.703499]  [<ffffffff81043300>] ? default_wake_function+0x0/0x10
[  240.703508]  [<ffffffff810acd40>] ? lru_add_drain_per_cpu+0x0/0x10
[  240.703515]  [<ffffffff813b3688>] wait_for_completion+0x18/0x20
[  240.703522]  [<ffffffff8105df2a>] flush_work+0xca/0x110
[  240.703528]  [<ffffffff8105de9c>] ? flush_work+0x3c/0x110
[  240.703535]  [<ffffffff8105d810>] ? wq_barrier_func+0x0/0x10
[  240.703543]  [<ffffffff8105e353>] schedule_on_each_cpu+0xe3/0x130
[  240.703551]  [<ffffffff810ac7b0>] lru_add_drain_all+0x10/0x20
[  240.703558]  [<ffffffff810be9b5>] sys_mlock+0x45/0x110
[  240.703566]  [<ffffffff8100bf6b>] system_call_fastpath+0x16/0x1b
[  240.703570] INFO: lockdep is turned off.
[  272.766205] ------------[ cut here ]------------
[  272.766222] WARNING: at /home/maxim/software/kernel/linux-2.6/drivers/char/tty_io.c:1267 tty_open+0x469/0x520()
[  272.766228] Hardware name: Aspire 5720     
[  272.766231] Modules linked in: af_packet vmnet vmblock vmci vmmon nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc usb_storage usb_libusual cpufreq_powersave cpufreq_conservative cpufreq_userspace acpi_cpufreq coretemp sbp2 snd_hda_codec_realtek iwl3945 snd_hda_intel uvcvideo iwlcore joydev snd_hda_codec videodev v4l1_compat mac80211 snd_hwdep v4l2_compat_ioctl32 psmouse uhci_hcd snd_pcm acer_wmi backlight ohci1394 cfg80211 sdhci_pci tg3 lirc_ene0100 lirc_dev ehci_hcd iTCO_wdt iTCO_vendor_support usbcore wmi ieee1394 ricoh_mmc sdhci serio_raw rfkill snd_timer snd_page_alloc nvidia(P) libphy evdev fuse
[  272.766356] Pid: 4738, comm: clear_console Tainted: P           2.6.31-rc8-wl #105
[  272.766361] Call Trace:
[  272.766370]  [<ffffffff812751e9>] ? tty_open+0x469/0x520
[  272.766380]  [<ffffffff810498c8>] warn_slowpath_common+0x78/0xd0
[  272.766388]  [<ffffffff8104992f>] warn_slowpath_null+0xf/0x20
[  272.766395]  [<ffffffff812751e9>] tty_open+0x469/0x520
[  272.766404]  [<ffffffff810daf77>] chrdev_open+0x137/0x220
[  272.766412]  [<ffffffff813b7230>] ? _spin_unlock+0x30/0x60
[  272.766419]  [<ffffffff810d8828>] ? file_move+0x28/0x60
[  272.766426]  [<ffffffff810d5724>] __dentry_open+0x124/0x350
[  272.766433]  [<ffffffff810dae40>] ? chrdev_open+0x0/0x220
[  272.766440]  [<ffffffff810d5a57>] nameidata_to_filp+0x57/0x70
[  272.766448]  [<ffffffff810e5c2a>] do_filp_open+0x73a/0xb20
[  272.766458]  [<ffffffff810f0609>] ? alloc_fd+0x129/0x150
[  272.766464]  [<ffffffff810d54ef>] do_sys_open+0x7f/0x140
[  272.766471]  [<ffffffff810d55db>] sys_open+0x1b/0x20
[  272.766480]  [<ffffffff8100bf6b>] system_call_fastpath+0x16/0x1b
[  272.766485] ---[ end trace 996055d7a12e942b ]---
maxim@MAIN:~$ 


Tell me if I need to provide more info.


Best regards,
	Maxim Levitsky


