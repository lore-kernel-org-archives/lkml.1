Return-Path: <linux-kernel-owner+w=401wt.eu-S1764033AbYCEW1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764033AbYCEW1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755187AbYCEW07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:26:59 -0500
Received: from hc6521041.dhcp.vt.edu ([198.82.16.65]:42393 "EHLO
	hc6521041.dhcp.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbYCEW06 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:26:58 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc3-mm1 - PROFILE_LIKELY redux..
In-Reply-To: Your message of "Wed, 05 Mar 2008 10:02:21 PST."
             <20080305100221.1d7316e6.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <4911.1204701694@turing-police.cc.vt.edu> <p738x0x5al2.fsf@bingen.suse.de>
            <20080305100221.1d7316e6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1204755985_5116P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 05 Mar 2008 17:26:25 -0500
Message-ID: <5762.1204755985@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1204755985_5116P
Content-Type: text/plain; charset=us-ascii

On Wed, 05 Mar 2008 10:02:21 PST, Andrew Morton said:

> at the top, so it'll be something else.  Perhaps a `likely' snuck in via an
> inline in a header file.  It would be better to add a #define DONT_DO_THAT
> at the top of arch/x86/kernel/vsyscall_64.c and
> arch/x86/vdso/vclock_gettime.c, then use that to defeat likely-profiling.
> 
>  arch/x86/kernel/vsyscall_64.c  |   11 ++---------
>  arch/x86/vdso/vclock_gettime.c |   11 ++---------
>  include/linux/compiler.h       |    3 ++-
>  3 files changed, 6 insertions(+), 19 deletions(-)

Confirming that this patch works and my system goes multi-user cleanly.

Actual numbers after about 10 minutes of uptime:

% wc -l /proc/likely_prof 
2635 /proc/likely_prof
% grep '^[^ ]' /proc/likely_prof 
Likely Profiling Results
[+- ] Type | # True | # False | Function:Filename@Line
+unlikely |        1|        0  in_dev_get()@:include/linux/inetdevice.h@185
+unlikely |      513|        0  dst_input()@:include/net/dst.h@254
-likely   |        0|      148  ip6_mc_input()@:net/ipv6/ip6_input.c@271
-likely   |        0|        1  sock_error()@:include/net/sock.h@1211
-likely   |      851|     1219  tcp_transmit_skb()@:net/ipv4/tcp_output.c@493
+unlikely |        1|        0  signal_pending()@:include/linux/sched.h@1927
-likely   |        0|  1172946  audit_syscall_entry()@:kernel/auditsc.c@1522
+unlikely |  1172716|        0  syscall_trace_enter()@:arch/x86/kernel/ptrace.c@1556
-likely   |        0|  1173020  audit_syscall_exit()@:kernel/auditsc.c@1551
+unlikely |  1172831|        0  syscall_trace_leave()@:arch/x86/kernel/ptrace.c@1573
-likely   |        0|     1272  audit_alloc()@:kernel/auditsc.c@841
+unlikely |        3|        0  icmp_unreach()@:net/ipv4/icmp.c@773
+unlikely |        2|        1  nf_ct_attach()@:net/netfilter/core.c@230
-likely   |        0|        2  dst_gc_task()@:net/core/dst.c@82
+unlikely |      143|       61  fput_light()@:include/linux/file.h@77
+unlikely |      892|      424  _read_unlock_irqrestore()@:kernel/spinlock.c@375
+unlikely |       28|        0  sched_move_task()@:kernel/sched.c@7835
+unlikely |       28|        0  sched_move_task()@:kernel/sched.c@7828
+unlikely |      108|        0  verify_export_symbols()@:kernel/module.c@1401
+unlikely |      313|        0  verify_export_symbols()@:kernel/module.c@1393
+unlikely |       14|        0  ll_front_merge_fn()@:block/blk-merge.c@347
-likely   |       17|     1150  audit_free()@:kernel/auditsc.c@1428
-likely   |       17|  1174290  audit_get_context()@:kernel/auditsc.c@711
+unlikely |       33|        0  inotify_find_update_watch()@:fs/inotify.c@591
+unlikely |     4360|      775  kill_pid_info()@:kernel/signal.c@1065
+unlikely |     7239|     2767  next_pidmap()@:kernel/pid.c@194
+unlikely |    42009|    33683  copy_pte_range()@:mm/memory.c@510
-likely   |        0|        1  qh_completions()@:drivers/usb/host/ehci-q.c@368
+unlikely |    19934|        0  ll_back_merge_fn()@:block/blk-merge.c@309
-likely   |      927|     2323  load_elf_binary()@:fs/binfmt_elf.c@896
+unlikely |     2435|      875  pmd_alloc()@:include/linux/mm.h@862
+unlikely |       13|       12  psmouse_interrupt()@:drivers/input/mouse/psmouse-base.c@296
+unlikely |       70|       25  psmouse_interrupt()@:drivers/input/mouse/psmouse-base.c@292
-likely   |       20|       80  qh_completions()@:drivers/usb/host/ehci-q.c@415
-likely   |        0|       30  qh_completions()@:drivers/usb/host/ehci-q.c@319
-likely   |        5|       14  submit_async()@:drivers/usb/host/ehci-q.c@975
+unlikely |       19|        2  qh_append_tds()@:drivers/usb/host/ehci-q.c@876
-likely   |        6|       15  atapi_drain_needed()@:drivers/ata/libata-scsi.c@846
+unlikely |    27395|    18153  add_timer_randomness()@:drivers/char/random.c@628
+unlikely |    34665|    19948  bio_phys_segments()@:fs/bio.c@226
-likely   |      347|      678  clocksource_adjust()@:kernel/time/timekeeping.c@418
-likely   |        1|        4  __ata_qc_from_tag()@:include/linux/libata.h@1319
-likely   |        0|       15  __cancel_work_timer()@:kernel/workqueue.c@490
+unlikely |    15638|     1127  queue_delayed_work_on()@:kernel/workqueue.c@233
+unlikely |        2|        0  srcu_notifier_chain_register()@:kernel/notifier.c@419
+unlikely |     6502|     2429  queue_work()@:kernel/workqueue.c@171
+unlikely |        9|        2  blocking_notifier_chain_register()@:kernel/notifier.c@212
+unlikely |    13631|        0  pre_schedule_rt()@:kernel/sched_rt.c@961
+unlikely |   591400|   443725  __update_curr()@:kernel/sched_fair.c@313
+unlikely |   233625|   205658  __switch_to()@:arch/x86/kernel/process_64.c@656
+unlikely |   313057|   126225  __switch_to()@:arch/x86/kernel/process_64.c@641
+unlikely |   313053|   126225  __switch_to()@:arch/x86/kernel/process_64.c@637
+unlikely |   467383|        0  sched_info_switch()@:kernel/sched_stats.h@230
+unlikely |   188448|    13628  pick_next_task_rt()@:kernel/sched_rt.c@522
+unlikely |   240619|        0  sched_info_queued()@:kernel/sched_stats.h@188
-likely   |       61|      644  ifind()@:fs/inode.c@798
+unlikely |   258562|    61703  scheduler_tick()@:kernel/sched.c@3756
-likely   |    61220|   241529  acct_update_integrals()@:kernel/tsacct.c@120
+unlikely |  1189922|   902477  kfree()@:mm/slab.c@3785
+unlikely |       23|        0  __rmqueue_fallback()@:mm/page_alloc.c@812
+unlikely |    14376|     9655  rt_policy()@:kernel/sched.c@140


--==_Exmh_1204755985_5116P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHzx4RcC3lWbTT17ARAj8JAJ4/jWGjUbWw9VtzsnGocDoDII4/eACfT8vO
12MkmtR7XnSYiC4YyEMeXVs=
=YtKp
-----END PGP SIGNATURE-----

--==_Exmh_1204755985_5116P--
