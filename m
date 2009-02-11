Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbZBKMse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbZBKMse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbZBKMsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:48:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41907 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180AbZBKMsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:48:24 -0500
Date: Wed, 11 Feb 2009 13:48:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Zach Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Rohit Jain <rjain@vmware.com>, LKML <linux-kernel@vger.kernel.org>,
       tj@kernel.org
Subject: Re: [PARAVIRT/x86] BUGFIX: Put a missing paravirt_release_pmd in
	pgd_dtor
Message-ID: <20090211124802.GI16535@elte.hu>
References: <1233885731.29693.26.camel@alok-dev1> <498BA0CA.2040603@goop.org> <1233901043.8943.6.camel@alok-dev1> <498BDE1D.8030101@goop.org> <20090206145324.GF18368@elte.hu> <498C6CC9.5050302@goop.org> <1233944975.15269.14.camel@alok-dev1> <20090209121045.GF17782@elte.hu> <1234210794.16177.35.camel@alok-dev1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234210794.16177.35.camel@alok-dev1>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alok Kataria <akataria@vmware.com> wrote:

> On Mon, 2009-02-09 at 04:10 -0800, Ingo Molnar wrote:
> 
> > 
> > Applied to tip:x86/urgent, thanks guys!
> 
> Thanks Ingo, 
> 
> I gave the tip tree a spin today and hit this bug.
> 
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<(null)>] (null)
> *pdpt = 0000000000839001 *pde = 0000000000c97067 *pte = 0000000000000163
> Oops: 0000 [#1] SMP
> last sysfs file:
> Modules linked in:
> 
> Pid: 1, comm: swapper Not tainted (2.6.29-rc4-tip #18) VMware Virtual
> Platform
> EIP: 0062:[<00000000>] EFLAGS: 00010293 CPU: 0
> EIP is at 0x0
> EAX: 00000001 EBX: 00006000 ECX: c077ed00 EDX: 00006000
> ESI: 00000001 EDI: 00000001 EBP: ef04cf40 ESP: ef04cf1c
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 006a
> Process swapper (pid: 1, ti=ef04c000 task=ef050000 task.ti=ef04c000)
> Stack:
>  c0644e52 00000000 ef04cf24 ef04cf24 c064468d c0886dc0 00000000 c0702aea
>  ef055480 00000001 00000101 dead4ead ffffffff ffffffff c08af530 00000000
>  c0709715 ef04cf60 ef04cf60 00000001 00000000 00000000 dead4ead ffffffff
> Call Trace:
>  [<c0644e52>] ? native_cpu_up+0x2de/0x45b
>  [<c064468d>] ? do_fork_idle+0x0/0x19
>  [<c0645c5e>] ? _cpu_up+0x88/0xe8
>  [<c0645d20>] ? cpu_up+0x42/0x4e
>  [<c07e7462>] ? kernel_init+0x99/0x14b
>  [<c07e73c9>] ? kernel_init+0x0/0x14b
>  [<c040375f>] ? kernel_thread_helper+0x7/0x10
> Code:  Bad EIP value.
> EIP: [<00000000>] 0x0 SS:ESP 006a:ef04cf1c

This is the crash fixed by your later genapic patch, right?

> This happens with out the fix too. So was wondering if there is any
> other known bug in the tip tree. 
> Also note that i synced to the mainline tree (29-rc4) and that works
> fine. So this only exists in tip.
> I will debug this later today, but if anyone has any ideas about this
> bug do let me know. 
> 
> And ya i also had to apply this patch to get tip to compile. 

yes, that should be fixed too - it appeared briefly.

Let me know if you can see any problems with the latest -tip tree.

	Ingo
