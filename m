Return-Path: <linux-kernel-owner+w=401wt.eu-S1762118AbZD3DVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762118AbZD3DVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 23:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761391AbZD3DVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 23:21:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49548 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761784AbZD3DVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 23:21:30 -0400
Date: Thu, 30 Apr 2009 13:21:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nick Piggin <npiggin@suse.de>
Cc: Sachin Sant <sachinp@in.ibm.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linuxppc-dev@ozlabs.org, linux-next@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: Next April 28: boot failure on PowerPC with SLQB
Message-Id: <20090430132118.4a36f737.sfr@canb.auug.org.au>
In-Reply-To: <49F87FAB.9050408@in.ibm.com>
References: <20090428165343.2e357d7a.sfr@canb.auug.org.au>
	<49F6E421.401@in.ibm.com>
	<84144f020904280422s6a9a277fjc4619c904f37e5ca@mail.gmail.com>
	<20090429113604.GE3398@wotan.suse.de>
	<49F87FAB.9050408@in.ibm.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__30_Apr_2009_13_21_18_+1000_TjY63O6d0bqFvAh9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_Apr_2009_13_21_18_+1000_TjY63O6d0bqFvAh9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nick,

On Wed, 29 Apr 2009 21:56:19 +0530 Sachin Sant <sachinp@in.ibm.com> wrote:
>
> Nick Piggin wrote:
> > Does this help?
> > ---
> With the patch the machine boots past the failure point, but panics
> immediately with the following trace...

That patch also changes the behaviour of my machine.  I now get:

calling  .init_trace_printk+0x0/0x34 @ 1
initcall .init_trace_printk+0x0/0x34 returned 0 after 0 usecs
Unable to handle kernel paging request for data at address 0x00000030
Faulting instruction address: 0xc00000000008ae7c
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=3D128 NUMA pSeries
Modules linked in:
NIP: c00000000008ae7c LR: c0000000002b0cb8 CTR: 0000000000000000
REGS: c0000000d6357910 TRAP: 0300   Not tainted  (2.6.30-rc3-autokern1)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 28000084  XER: 0000000f
DAR: 0000000000000030, DSISR: 0000000042000000
TASK =3D c0000000fe368000[1] 'swapper' THREAD: c0000000d6354000 CPU: 0
GPR00: 0000000000000000 c0000000d6357b90 c000000000b04410 0000000000000028=
=20
GPR04: c0000000006d7bd0 c000000000b95400 0000000000000000 c0000000fe368980=
=20
GPR08: 000000000000004c 0000000000000291 0000000000000002 c0000000012bfd5c=
=20
GPR12: 0000000048000088 c000000000b53280 0000000000000000 0000000002100000=
=20
GPR16: c0000000006c8f50 c0000000006c76c8 0000000000000000 00000000003d8800=
=20
GPR20: 00000000028c6bb0 c0000000007c6bb0 00000000028c6e20 c0000000007c6e20=
=20
GPR24: c0000000006c89b8 0000000000000028 0000000000000003 c000000000b95400=
=20
GPR28: c0000000006d7bd0 0000000000000010 c000000000a68708 0000000000000010=
=20
NIP [c00000000008ae7c] .lockdep_init_map+0x3c/0x57c
LR [c0000000002b0cb8] .__spin_lock_init+0x44/0x90
Call Trace:
[c0000000d6357b90] [c000000000a68708] klist_remove_waiters+0xe210/0x2e2e0 (=
unreliable)
[c0000000d6357c50] [c0000000002b0cb8] .__spin_lock_init+0x44/0x90
[c0000000d6357d00] [c00000000054552c] .timer_cpu_notify+0xec/0x2c4
[c0000000d6357db0] [c000000000540bc0] .notifier_call_chain+0x5c/0xcc
[c0000000d6357e50] [c000000000544ee0] .cpu_up+0xe8/0x1c4
[c0000000d6357f00] [c00000000078fb94] .kernel_init+0xf8/0x220
[c0000000d6357f90] [c0000000000262b8] .kernel_thread+0x54/0x70
Instruction dump:
fbc1fff0 fbe1fff8 fae1ffb8 fb01ffc0 f8010010 fb41ffd0 fb61ffd8 fb81ffe0=20
f821ff41 ebc2b160 38000000 7c791b78 <f8030008> 7cbf2b78 7cdd3378 e93e8138=20
---[ end trace 31fd0ba7d8756001 ]---
Kernel panic - not syncing: Attempted to kill init!
Call Trace:
[c0000000d6357570] [c00000000000fd58] .show_stack+0x70/0x184 (unreliable)
[c0000000d6357620] [c00000000005ed34] .panic+0x80/0x1b4
[c0000000d63576c0] [c00000000006337c] .do_exit+0x84/0x6f0
[c0000000d6357780] [c000000000024350] .die+0x24c/0x27c
[c0000000d6357820] [c00000000002c1f4] .bad_page_fault+0xb8/0xd4
[c0000000d63578a0] [c00000000000534c] handle_page_fault+0x3c/0x5c
--- Exception: 300 at .lockdep_init_map+0x3c/0x57c
    LR =3D .__spin_lock_init+0x44/0x90
[c0000000d6357b90] [c000000000a68708] klist_remove_waiters+0xe210/0x2e2e0 (=
unreliable)
[c0000000d6357c50] [c0000000002b0cb8] .__spin_lock_init+0x44/0x90
[c0000000d6357d00] [c00000000054552c] .timer_cpu_notify+0xec/0x2c4
[c0000000d6357db0] [c000000000540bc0] .notifier_call_chain+0x5c/0xcc
[c0000000d6357e50] [c000000000544ee0] .cpu_up+0xe8/0x1c4
[c0000000d6357f00] [c00000000078fb94] .kernel_init+0xf8/0x220
[c0000000d6357f90] [c0000000000262b8] .kernel_thread+0x54/0x70

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__30_Apr_2009_13_21_18_+1000_TjY63O6d0bqFvAh9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkn5GS4ACgkQjjKRsyhoI8zBNwCfTCMhsweqoqJQILgXYu8ipEO2
s1oAn22dNsVw91rOZ/AKy4T8N1C8mYvI
=ere6
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Apr_2009_13_21_18_+1000_TjY63O6d0bqFvAh9--
