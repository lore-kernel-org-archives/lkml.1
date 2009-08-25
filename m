Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbZHYSnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbZHYSnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbZHYSnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:43:55 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54131 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbZHYSny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:43:54 -0400
Subject: Re: [bisected] 2.6.31 regression: fails to boot as xen guest
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <4A942F96.7000900@nets.rwth-aachen.de>
References: <4A9407B1.6020400@nets.rwth-aachen.de>
	 <84144f020908250929t7d4a74f1n4827de04e5c4c56a@mail.gmail.com>
	 <4A94161A.2020609@nets.rwth-aachen.de>
	 <1251219129.4852.1.camel@penberg-laptop>
	 <4A94242E.30309@nets.rwth-aachen.de>
	 <1251223399.13451.5.camel@penberg-laptop>
	 <4A942BDD.70303@nets.rwth-aachen.de> <20090825182510.GA6903@elte.hu>
	 <4A942DB9.3020209@goop.org>  <4A942F96.7000900@nets.rwth-aachen.de>
Date: Tue, 25 Aug 2009 21:43:54 +0300
Message-Id: <1251225834.13451.13.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 20:38 +0200, Arnd Hannemann wrote:
> >>> Hmm, -rc7 + this fix does not work for me :-/ Still hangs before
> >>> any output...
> >>>
> >> does earlyprintk=vga tell you anything about precisely where it
> >> hangs?
> >>
> >
> > It's a Xen domain, so it should be earlyprintk=xen
> >
> > J
> >
> Here is the output with earlyprintk=xen and the second patch from pekka
> applied:
> 
> (early) [    0.000000] Initializing CPU#0
> (early) [    0.000000] Checking if this processor honours the WP bit
> even in supervisor mode...(early)
> (early) [    0.000000] BUG: unable to handle kernel (early) NULL pointer
> dereference(early)  at (null)
> (early) [    0.000000] IP:(early)  [<c1192993>]
> xen_evtchn_do_upcall+0xd3/0x160
> (early) [    0.000000] *pdpt = 0000000008386001 (early)
> (early) [    0.000000] Thread overran stack, or stack corrupted
> (early) [    0.000000] Oops: 0000 [#1] (early) SMP (early)
> (early) [    0.000000] last sysfs file:
> (early) [    0.000000] Modules linked in:(early)
> (early) [    0.000000]
> (early) [    0.000000] Pid: 0, comm: swapper Not tainted
> (2.6.31-rc7-pae-um #10)
> (early) [    0.000000] EIP: 0061:[<c1192993>] EFLAGS: 00010046 CPU: 0
> (early) [    0.000000] EIP is at xen_evtchn_do_upcall+0xd3/0x160
> (early) [    0.000000] EAX: 00000004 EBX: 00000000 ECX: 00000004 EDX:
> ffffffff
> (early) [    0.000000] ESI: fffffffe EDI: 00000000 EBP: 00000000 ESP:
> c1413e64
> (early) [    0.000000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: e021
> (early) [    0.000000] Process swapper (pid: 0, ti=c1412000
> task=c13d11a0 task.ti=c1412000)
> (early) [    0.000000] Stack:
> (early) [    0.000000]  f5793000(early)  c146d9f0(early) 
> c146d9f0(early)  00000000(early)  c1413e9c(early)  00000000(early) 
> 00000000(early)  c3a01020(early)
> (early) [    0.000000] <0>(early)  00000000(early)  eec06067(early) 
> c000cff8(early)  00000000(early)  00000000(early)  c10086d7(early) 
> eec06067(early)  c000cff8(early)
> (early) [    0.000000] <0>(early)  f55ff000(early)  c000cff8(early) 
> 00000000(early)  00000000(early)  c13d7d60(early)  c101e021(early) 
> c141e021(early)  c10100d8(early)
> (early) [    0.000000] Call Trace:
> (early) [    0.000000]  [<c10086d7>] ? xen_do_upcall+0x7/0xc
> (early) [    0.000000]  [<c101e021>] ? ptep_set_access_flags+0x1/0x80
> (early) [    0.000000]  [<c141e021>] ? find_e820_area_size+0x51/0x330
> (early)

Aha, the previous patch worked because I #ifdef the WP test completely.
Jeremy, the root cause here is that we do the WP test much earlier than
before. Even with the test moved to trap_init(), we do it early compared
to what we did before.

I guess Xen is not prepared to handle traps this early in the boot
sequence? Can we fix that?

			Pekka

