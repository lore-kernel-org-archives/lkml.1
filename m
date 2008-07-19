Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbYGSVyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbYGSVyH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 17:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbYGSVxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 17:53:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46110 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920AbYGSVxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 17:53:55 -0400
Date: Sat, 19 Jul 2008 23:53:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Zachary Amsden <zach@vmware.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: APIC: Remove apic_write_around(); use alternatives
Message-ID: <20080719215325.GA12737@elte.hu>
References: <20080718210348.GB24373@elte.hu> <86802c440807181413n7e79e821l90afaae86b322de9@mail.gmail.com> <Pine.LNX.4.55.0807182254270.12125@cliff.in.clinika.pl> <1216420937.30348.30.camel@bodhitayantram.eng.vmware.com> <20080718224922.GB4507@linux-os.sc.intel.com> <86802c440807181551l7e6e143dy7cea8ab59f1830ed@mail.gmail.com> <20080718230012.GD4507@linux-os.sc.intel.com> <86802c440807181604y502e7deal98abfeb1ceee769d@mail.gmail.com> <20080718231828.GE4507@linux-os.sc.intel.com> <20080719214944.GC836@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080719214944.GC836@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > > maciej, patch will go first, and x2apic will goes later, so bisect 
> > > on x2apic will be broken.
> > 
> > hm, ok. Ingo? should I send the rebased 30 or so patches. or we can 
> > move this patch later.
> 
> hm, yes, please send the rebased patches - as this stuff has some 
> risks so bisectability is important.

hm, actually - the order is correct so no need to rebase any of this.

We've got two topics: tip/x86/apic and tip/x86/x2apic.

both tip/x86/x2apic and tip/x86/apic were OK standalone. I merged them 
together in this commit:

commit 453c1404c5273a30d715e5a83372a78cff70b6d9
Merge: a208f37... 35b6805...
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Jul 18 23:00:05 2008 +0200

    Merge branch 'x86/apic' into x86/x2apic

    Conflicts:

        arch/x86/kernel/paravirt.c
        arch/x86/kernel/smpboot.c
        arch/x86/kernel/vmi_32.c
        arch/x86/lguest/boot.c
        arch/x86/xen/enlighten.c
        include/asm-x86/apic.h
        include/asm-x86/paravirt.h

    Signed-off-by: Ingo Molnar <mingo@elte.hu>

and that didnt work straight away, so i applied your fixups - but that's 
the next commit. So there's only a single commit that is not bisectable 
and that's OK.

so unless there's some other breakage i missed, this should be fine and 
no need to resend/rebase anything.

	Ingo
