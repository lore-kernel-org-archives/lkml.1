Return-Path: <linux-kernel-owner+w=401wt.eu-S935183AbXG0Nhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935183AbXG0Nhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 09:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760924AbXG0Nhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 09:37:32 -0400
Received: from merkurneu.hrz.uni-giessen.de ([134.176.2.3]:56141 "EHLO
	merkurneu.hrz.uni-giessen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759756AbXG0Nha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 09:37:30 -0400
From: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: NFSv4 poops itself
Date: Fri, 27 Jul 2007 15:36:43 +0200
User-Agent: KMail/1.9.5
References: <46A9EAB0.3090306@garzik.org>
In-Reply-To: <46A9EAB0.3090306@garzik.org>
Cc: kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707271537.00647.marc.dietrich@ap.physik.uni-giessen.de>
X-HRZ-JLUG-MailScanner-Information: Passed JLUG virus check
X-HRZ-JLUG-MailScanner: No virus found
X-MailScanner-From: marc.dietrich@ap.physik.uni-giessen.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Am Friday 27 July 2007 14:53 schrieben Sie:
> Background:
>
> Server: x86-64 dual core Intel, kernel 2.6.23-rc1 (my home fileserver)
> 	Exporting NFS/NFSv4 mounts.  Client count: 1  Uptime: 4 days
>
> Client: x86-64 dual core Intel, kernel 2.6.23-rc1 (my main workstation)
> 	NFS mount setup:
> 	pretzel:/ on /g type nfs4 (rw,noatime,proto=tcp,addr=10.10.10.1)
> 	Uptime: 4 days
>
> 	Home directory mounted via NFSv4.
>
> Problem:
>
> My workstation has been happily talking to my file server for several
> days without incident.  An hour ago, my numeric keypad stopping working
> (unrelated problem... USB or X bug?).  The solution to the keypad
> problem is usually to log out of X and log back in, or worse case, reboot.
>
> So, I log out, and log back in.  At first, a few shell windows open and
> successfully initialize themselves (read bash profile over NFS, etc.)
> Then, as more shell windows open, things start hanging.  I can easily
> switch to console and ssh to the fileserver, so it is clear this is an
> NFS hang.
>
> No adverse messages at all on the client.
>
> On the server, I see NFSv4 spamming dmesg with hundreds of thousands of
> messages:
>
> Jul 27 08:20:53 pretzel kernel: NFSD: preprocess_seqid_op: old stateid!
> Jul 27 08:21:24 pretzel last message repeated 167966 times
> Jul 27 08:21:55 pretzel last message repeated 173628 times
> Jul 27 08:21:55 pretzel kernel: NFSD: preprocess_seqid_op: old stateid!
> Jul 27 08:22:26 pretzel last message repeated 171286 times
> Jul 27 08:23:27 pretzel last message repeated 344461 times
> Jul 27 08:23:30 pretzel last message repeated 18656 times
>
> I rebooted the client, the problem disappeared, and everything is happy
> again...  but clearly NFSv4 shat itself.  And now I am worried this will
> happen again.
>
> In all my quite-heavy use of NFSv4 I've never seen this behavior before,
>   so I would call this a regression.
>
> I always run vanilla linux-2.6.git self-built kernels on both client and
> server.

me too, my server has 2.6.18-? (openSUSE 10.2). On the client 
(2.6.23-rc1-mm1), I also see (shortly before the hang)

Jul 26 13:09:19 fb07-iapwap2 kernel: =================================
Jul 26 13:09:19 fb07-iapwap2 kernel: [ INFO: inconsistent lock state ]
Jul 26 13:09:19 fb07-iapwap2 kernel: 2.6.23-rc1-mm1 #1
Jul 26 13:09:19 fb07-iapwap2 kernel: ---------------------------------
Jul 26 13:09:19 fb07-iapwap2 kernel: inconsistent {softirq-on-W} -> 
{in-softirq-W} usage.
Jul 26 13:09:19 fb07-iapwap2 kernel: hald/3873 [HC0[0]:SC1[1]:HE1:SE0] takes:
Jul 26 13:09:19 fb07-iapwap2 kernel:  (rpc_credcache_lock){-+..}, at: 
[<c01dc166>] _atomic_dec_and_lock+0x16/0x60
Jul 26 13:09:19 fb07-iapwap2 kernel: {softirq-on-W} state was registered at:
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c013d4f7>] mark_lock+0x77/0x630
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c013c094>] add_lock_to_list+0x44/0xc0
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c013e8af>] 
__lock_acquire+0x65f/0x1020
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c013db0e>] mark_held_locks+0x5e/0x80
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c012448d>] local_bh_enable+0x7d/0x130
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c013f2cf>] lock_acquire+0x5f/0x80
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c01dc166>] 
_atomic_dec_and_lock+0x16/0x60
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c02d156a>] _spin_lock+0x2a/0x40
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c01dc166>] 
_atomic_dec_and_lock+0x16/0x60
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c01dc166>] 
_atomic_dec_and_lock+0x16/0x60
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c02d156a>] _spin_lock+0x2a/0x40
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dcecf770>] put_rpccred+0x60/0x110 
[sunrpc]
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dcecf840>] 
rpcauth_unbindcred+0x20/0x60 [sunrpc]
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dcece1f4>] rpc_put_task+0x44/0xb0 
[sunrpc]
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dcec8ffd>] rpc_call_sync+0x2d/0x40 
[sunrpc]
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dced680d>] rpcb_register+0x10d/0x1c0 
[sunrpc]
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dced06ef>] svc_register+0x8f/0x160 
[sunrpc]
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c013dca5>] 
trace_hardirqs_on+0xc5/0x170
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dced0fc5>] __svc_create+0x1d5/0x200 
[sunrpc]
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dced1160>] svc_create+0x10/0x20 
[sunrpc]
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dcf69602>] nfs_callback_up+0x82/0x120 
[nfs]
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dcf43efd>] nfs_get_client+0x17d/0x390 
[nfs]
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c0175f59>] kmem_cache_alloc+0x79/0xd0
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c013dca5>] 
trace_hardirqs_on+0xc5/0x170
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dcf44144>] nfs4_set_client+0x34/0x1a0 
[nfs]
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dcf448d1>] 
nfs4_create_server+0x61/0x3c0 [nfs]
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c017657f>] __kmalloc+0xdf/0x120
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c013dca5>] 
trace_hardirqs_on+0xc5/0x170
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c013e987>] 
__lock_acquire+0x737/0x1020
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c01e22cd>] copy_from_user+0x3d/0x80
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c01636e2>] strndup_user+0x62/0x80
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dcf4d647>] nfs4_get_sb+0x3c7/0x610 
[nfs]
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c013e987>] 
__lock_acquire+0x737/0x1020
Jul 26Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c015d536>] 
get_page_from_freelist+0x316/0x460
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c013dca5>] 
trace_hardirqs_on+0xc5/0x170
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c015e0be>] __alloc_pages+0x4e/0x370
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c017b380>] vfs_kern_mount+0xa0/0x120
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c0190b1d>] do_mount+0x21d/0x840
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c01667c7>] 
handle_mm_fault+0x4a7/0x690
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c02d1494>] _spin_unlock+0x14/0x20
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c0166773>] 
handle_mm_fault+0x453/0x690
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c0135c24>] up_read+0x14/0x30
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c0116ddd>] do_page_fault+0x1ed/0x6e0
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c018f597>] 
copy_mount_options+0xb7/0x150
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c01911b2>] sys_mount+0x72/0xb0
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c01040b2>] syscall_call+0x7/0xb
Jul 26 13:09:19 fb07-iapwap2 kernel:   [<ffffffff>] 0xffffffff
Jul 26 13:09:19 fb07-iapwap2 kernel: irq event stamp: 240896
Jul 26 13:09:19 fb07-iapwap2 kernel: hardirqs last  enabled at (240896): 
[<c017592e>] kmem_cache_free+0x7e/0xb0
Jul 26 13:09:19 fb07-iapwap2 kernel: hardirqs last disabled at (240895): 
[<c01758fc>] kmem_cache_free+0x4c/0xb0
Jul 26 13:09:19 fb07-iapwap2 kernel: softirqs last  enabled at (240446): 
[<c0124255>] do_softirq+0x45/0x50
Jul 26 13:09:19 fb07-iapwap2 kernel: softirqs last disabled at (240887): 
[<c0124255>] do_softirq+0x45/0x50
Jul 26 13:09:19 fb07-iapwap2 kernel:
Jul 26 13:09:19 fb07-iapwap2 kernel: other info that might help us debug this:
Jul 26 13:09:19 fb07-iapwap2 kernel: no locks held by hald/3873.
Jul 26 13:09:19 fb07-iapwap2 kernel:
Jul 26 13:09:19 fb07-iapwap2 kernel: stack backtrace:
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c013ccbc>] print_usage_bug+0x15c/0x170
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c013d8da>] mark_lock+0x45a/0x630
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c013e857>] __lock_acquire+0x607/0x1020
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c013e987>] __lock_acquire+0x737/0x1020
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c013f2cf>] lock_acquire+0x5f/0x80
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c01dc166>] 
_atomic_dec_and_lock+0x16/0x60
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c02d156a>] _spin_lock+0x2a/0x40
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c01dc166>] 
_atomic_dec_and_lock+0x16/0x60
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c01dc166>] 
_atomic_dec_and_lock+0x16/0x60
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<dcecf770>] put_rpccred+0x60/0x110 
[sunrpc]
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<dcf67e10>] 
nfs_free_delegation_callback+0x10/0x20 [nfs]
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c012fa47>] 
__rcu_process_callbacks+0x67/0x1c0
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c012fbaf>] 
rcu_process_callbacks+0xf/0x20
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c0124293>] tasklet_action+0x33/0x70
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c01241b5>] __do_softirq+0x55/0xb0
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c0124255>] do_softirq+0x45/0x50
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c0112490>] 
smp_apic_timer_interrupt+0x40/0x80
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c0104ad9>] 
apic_timer_interrupt+0x29/0x38
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c0104ae3>] 
apic_timer_interrupt+0x33/0x38
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c02d18a2>] _spin_unlock_irq+0x22/0x30
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c02cecb4>] 
__sched_text_start+0x1c4/0x390
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c02cec29>] 
__sched_text_start+0x139/0x390
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c0127feb>] __mod_timer+0x8b/0xa0
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c02cf63a>] schedule_timeout+0x4a/0xc0
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c0127b40>] process_timeout+0x0/0x10
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c0186197>] do_sys_poll+0x237/0x320
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c0186d70>] __pollwait+0x0/0xf0
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c011aa50>] 
default_wake_function+0x0/0x10
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c011aa50>] 
default_wake_function+0x0/0x10
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c011aa50>] 
default_wake_function+0x0/0x10
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c011aa50>] 
default_wake_function+0x0/0x10
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c011aa50>] 
default_wake_function+0x0/0x10
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c011aa50>] 
default_wake_function+0x0/0x10
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c011aa50>] 
default_wake_function+0x0/0x10
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c011aa50>] 
default_wake_function+0x0/0x10
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c011aa50>] 
default_wake_function+0x0/0x10
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c011aa50>] 
default_wake_function+0x0/0x10
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c011aa50>] 
default_wake_function+0x0/0x10
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c011aa50>] 
default_wake_function+0x0/0x10
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c02d1444>] _read_unlock+0x14/0x20
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c02cbae5>] 
unix_stream_sendmsg+0x1a5/0x350
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c0263727>] sock_aio_write+0x117/0x140
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c013e987>] __lock_acquire+0x737/0x1020
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c0179874>] do_readv_writev+0x144/0x1c0
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c0263610>] sock_aio_write+0x0/0x140
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c0136ac1>] do_gettimeofday+0x31/0xf0
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c0104108>] restore_nocheck+0x12/0x15
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c013dca5>] 
trace_hardirqs_on+0xc5/0x170
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c01e25af>] copy_to_user+0x3f/0x70
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c01862a8>] sys_poll+0x28/0x40
Jul 26 13:09:19 fb07-iapwap2 kernel:  [<c01040b2>] syscall_call+0x7/0xb
Jul 26 13:09:19 fb07-iapwap2 kernel:  =======================

marc
