Return-Path: <linux-kernel-owner+w=401wt.eu-S937486AbXG0R6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937486AbXG0R6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 13:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932871AbXG0R6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 13:58:36 -0400
Received: from merkurneu.hrz.uni-giessen.de ([134.176.2.3]:32895 "EHLO
	merkurneu.hrz.uni-giessen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932717AbXG0R6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 13:58:35 -0400
From: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: NFSv4 poops itself
Date: Fri, 27 Jul 2007 19:58:10 +0200
User-Agent: KMail/1.9.5
Cc: "Jeff Garzik" <jeff@garzik.org>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Trond Myklebust" <Trond.Myklebust@netapp.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
References: <46A9EAB0.3090306@garzik.org> <200707271537.00647.marc.dietrich@ap.physik.uni-giessen.de> <a781481a0707270758n16e4e174t344f539e0be27a6f@mail.gmail.com>
In-Reply-To: <a781481a0707270758n16e4e174t344f539e0be27a6f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707271958.11482.marc.dietrich@ap.physik.uni-giessen.de>
X-HRZ-JLUG-MailScanner-Information: Passed JLUG virus check
X-HRZ-JLUG-MailScanner: No virus found
X-MailScanner-From: marc.dietrich@ap.physik.uni-giessen.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi again,

Am Freitag, 27. Juli 2007 16:58 schrieb Satyam Sharma:
> On 7/27/07, Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de> wrote:
> > Hi,
> >
> > (...)
> >
> > me too, my server has 2.6.18-? (openSUSE 10.2). On the client
> > (2.6.23-rc1-mm1), I also see (shortly before the hang)
> >
> > Jul 26 13:09:19 fb07-iapwap2 kernel: =================================
> > Jul 26 13:09:19 fb07-iapwap2 kernel: [ INFO: inconsistent lock state ]
> > Jul 26 13:09:19 fb07-iapwap2 kernel: 2.6.23-rc1-mm1 #1
> > Jul 26 13:09:19 fb07-iapwap2 kernel: ---------------------------------
> > Jul 26 13:09:19 fb07-iapwap2 kernel: inconsistent {softirq-on-W} ->
> > (cut away ugly dump)
>
> Doesn't appear related ... could you rebuild with CONFIG_FRAME_POINTER
> and test + resend the above log? The trace up there looks quite ugly.

this seems to be better ...

Jul 27 19:43:33 fb07-iapwap2 kernel: =================================
Jul 27 19:43:33 fb07-iapwap2 kernel: [ INFO: inconsistent lock state ]
Jul 27 19:43:33 fb07-iapwap2 kernel: 2.6.23-rc1-mm1 #1
Jul 27 19:43:33 fb07-iapwap2 kernel: ---------------------------------
Jul 27 19:43:33 fb07-iapwap2 kernel: inconsistent {softirq-on-W} -> 
{in-softirq-W} usage.
Jul 27 19:43:33 fb07-iapwap2 kernel: kdm/5909 [HC0[0]:SC1[1]:HE1:SE0] takes:
Jul 27 19:43:33 fb07-iapwap2 kernel:  (rpc_credcache_lock){-+..}, at: 
[<c01dba67>] _atomic_dec_and_lock+0x17/0x60
Jul 27 19:43:33 fb07-iapwap2 kernel: {softirq-on-W} state was registered at:
Jul 27 19:43:33 fb07-iapwap2 kernel:   [<c013e800>] 
__lock_acquire+0x650/0x1030
Jul 27 19:43:33 fb07-iapwap2 kernel:   [<c013f241>] lock_acquire+0x61/0x80
Jul 27 19:43:33 fb07-iapwap2 kernel:   [<c02db8dc>] _spin_lock+0x2c/0x40
Jul 27 19:43:33 fb07-iapwap2 kernel:   [<c01dba67>] 
_atomic_dec_and_lock+0x17/0x60
Jul 27 19:43:33 fb07-iapwap2 kernel:   [<dceca5fd>] put_rpccred+0x5d/0x100 
[sunrpc]
Jul 27 19:43:33 fb07-iapwap2 kernel:   [<dceca6c1>] 
rpcauth_unbindcred+0x21/0x60 [sunrpc]
Jul 27 19:43:33 fb07-iapwap2 kernel:   [<dcec8fd4>] rpc_put_task+0x44/0xa0 
[sunrpc]
Jul 27 19:43:33 fb07-iapwap2 kernel:   [<dcec3fe0>] rpc_call_sync+0x30/0x40 
[sunrpc]
Jul 27 19:43:33 fb07-iapwap2 kernel:   [<dced172b>] rpcb_register+0xdb/0x180 
[sunrpc]
Jul 27 19:43:33 fb07-iapwap2 kernel:   [<dcecb5b3>] svc_register+0x93/0x160 
[sunrpc]
Jul 27 19:43:33 fb07-iapwap2 kernel:   [<dcecbebe>] __svc_create+0x1ee/0x220 
[sunrpc]
Jul 27 19:43:33 fb07-iapwap2 kernel:   [<dcecc053>] svc_create+0x13/0x20 
[sunrpc]
Jul 27 19:43:33 fb07-iapwap2 kernel:   [<dcf62752>] nfs_callback_up+0x82/0x120 
[nfs]
Jul 27 19:43:33 fb07-iapwap2 kernel:   [<dcf3df36>] nfs_get_client+0x176/0x390 
[nfs]
Jul 27 19:43:33 fb07-iapwap2 kernel:   [<dcf3e181>] nfs4_set_client+0x31/0x190 
[nfs]
Jul 27 19:43:33 fb07-iapwap2 kernel:   [<dcf3e983>] 
nfs4_create_server+0x63/0x3b0 [nfs]
Jul 27 19:43:33 fb07-iapwap2 kernel:   [<dcf47426>] nfs4_get_sb+0x346/0x5b0 
[nfs]
Jul 27 19:43:33 fb07-iapwap2 kernel:   [<c017aa74>] vfs_kern_mount+0x94/0x110
Jul 27 19:43:33 fb07-iapwap2 kernel:   [<c01900c2>] do_mount+0x1f2/0x7d0
Jul 27 19:43:33 fb07-iapwap2 kernel:   [<c0190706>] sys_mount+0x66/0xa0
Jul 27 19:43:33 fb07-iapwap2 kernel:   [<c01040de>] syscall_call+0x7/0xb
Jul 27 19:43:33 fb07-iapwap2 kernel:   [<ffffffff>] 0xffffffff
Jul 27 19:43:33 fb07-iapwap2 kernel: irq event stamp: 4916
Jul 27 19:43:33 fb07-iapwap2 kernel: hardirqs last  enabled at (4916): 
[<c017518a>] kmem_cache_free+0x8a/0xc0
Jul 27 19:43:33 fb07-iapwap2 kernel: hardirqs last disabled at (4915): 
[<c0175152>] kmem_cache_free+0x52/0xc0
Jul 27 19:43:33 fb07-iapwap2 kernel: softirqs last  enabled at (4888): 
[<dcec9ff1>] rpc_wake_up_next+0x81/0x180 [sunrpc]
Jul 27 19:43:33 fb07-iapwap2 kernel: softirqs last disabled at (4905): 
[<c01241e7>] do_softirq+0x47/0x50
Jul 27 19:43:33 fb07-iapwap2 kernel:
Jul 27 19:43:33 fb07-iapwap2 kernel: other info that might help us debug this:
Jul 27 19:43:33 fb07-iapwap2 kernel: 1 lock held by kdm/5909:
Jul 27 19:43:33 fb07-iapwap2 kernel:  #0:  (&inode->i_mutex/1){--..}, at: 
[<c0182efd>] do_unlinkat+0x7d/0x140
Jul 27 19:43:33 fb07-iapwap2 kernel:
Jul 27 19:43:33 fb07-iapwap2 kernel: stack backtrace:
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<c010506a>] 
show_trace_log_lvl+0x1a/0x30
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<c0105c92>] show_trace+0x12/0x20
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<c0105da5>] dump_stack+0x15/0x20
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<c013cc53>] print_usage_bug+0x153/0x160
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<c013d849>] mark_lock+0x449/0x620
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<c013e7b4>] __lock_acquire+0x604/0x1030
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<c013f241>] lock_acquire+0x61/0x80
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<c02db8dc>] _spin_lock+0x2c/0x40
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<c01dba67>] 
_atomic_dec_and_lock+0x17/0x60
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<dceca5fd>] put_rpccred+0x5d/0x100 
[sunrpc]
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<dcf60fb3>] 
nfs_free_delegation_callback+0x13/0x20 [nfs]
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<c012fa3a>] 
__rcu_process_callbacks+0x6a/0x1c0
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<c012fba2>] 
rcu_process_callbacks+0x12/0x30
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<c0124228>] tasklet_action+0x38/0x80
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<c0124135>] __do_softirq+0x55/0xc0
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<c01241e7>] do_softirq+0x47/0x50
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<c0124615>] irq_exit+0x35/0x40
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<c0112463>] 
smp_apic_timer_interrupt+0x43/0x80
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<c0104b0f>] 
apic_timer_interrupt+0x33/0x38
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<dcecab53>] 
rpcauth_lookup_credcache+0x83/0x1c0 [sunrpc]
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<dcecb1a8>] unx_lookup_cred+0x8/0x10 
[sunrpc]
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<dceca8fe>] rpcauth_bindcred+0x5e/0xe0 
[sunrpc]
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<dcec3e87>] rpc_call_setup+0x57/0x60 
[sunrpc]
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<dcec3edb>] rpc_do_run_task+0x4b/0xb0 
[sunrpc]
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<dcec3fce>] rpc_call_sync+0x1e/0x40 
[sunrpc]
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<dcf53cba>] 
_nfs4_proc_lookupfh+0x6a/0xb0 [nfs]
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<dcf55b89>] 
_nfs4_proc_lookup+0x49/0x1d0 [nfs]
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<dcf55d42>] nfs4_proc_lookup+0x32/0x60 
[nfs]
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<dcf3fe69>] nfs_lookup+0xa9/0x260 [nfs]
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<dcf4226c>] 
nfs_atomic_lookup+0x10c/0x180 [nfs]
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<c0180190>] lookup_hash+0x90/0xb0
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<c0182f05>] do_unlinkat+0x85/0x140
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<c0182fd0>] sys_unlink+0x10/0x20
Jul 27 19:43:33 fb07-iapwap2 kernel:  [<c01040de>] syscall_call+0x7/0xb
Jul 27 19:43:33 fb07-iapwap2 kernel:  =======================

this kernel is 2.6.23-rc1-mm1 with Trond's fix from this thread and this one. 
http://marc.info/?l=linux-kernel&m=118546628202419&w=2.

Problem (hang) is easy reproduceable here by just launching kde and open 
konsole.

> [ Unrelated, but I just realized from lib/Kconfig.debug that stuff in there
> "select"s LOCKDEP, which itself "selects" frame pointers (on some archs).
> But I thought "select" didn't chain properly like that? There's whole lots
> of depending and selecting and non-user-visible options out there in
> that file -- and I'm not sure all those selects and depends are really
> even required to successfully build (?) ]
>
>
> Satyam

marc

