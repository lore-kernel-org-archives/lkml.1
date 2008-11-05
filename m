Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbYKEK1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbYKEK1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 05:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbYKEK1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 05:27:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50910 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950AbYKEK1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 05:27:31 -0500
Date: Wed, 5 Nov 2008 11:26:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       lguest@ozlabs.org, jeremy@xensource.com,
       Steven Rostedt <srostedt@redhat.com>, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Message-ID: <20081105102643.GA11383@elte.hu>
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <20081104204400.GC10825@elte.hu> <20081104210643.GH29626@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104210643.GH29626@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> On Tue, Nov 04, 2008 at 09:44:00PM +0100, Ingo Molnar wrote:
> > 
> > * Alexander van Heukelum <heukelum@fastmail.fm> wrote:
> > 
> > > On Tue, 4 Nov 2008 18:05:01 +0100, "Andi Kleen" <andi@firstfloor.org>
> > > said:
> > > > > not taking into account the cost of cs reading (which I
> > > > > don't suspect to be that expensive apart from writting,
> > > > 
> > > > GDT accesses have an implied LOCK prefix. Especially
> > > > on some older CPUs that could be slow.
> > > > 
> > > > I don't know if it's a problem or not but it would need
> > > > some careful benchmarking on different systems to make sure interrupt 
> > > > latencies are not impacted.
> > 
> > That's not a real issue on anything produced in this decade as we have 
> > had per CPU GDTs in Linux for about a decade as well.
> > 
> > It's only an issue on ancient CPUs that export all their LOCKed 
> > cycles to the bus. Pentium and older or so. The PPro got it right 
> > already.
> 
> ???  LOCK slowness is not because of the bus. And I know you know 
> that Ingo, so I don't know why you wrote that bogosity above.

.. of course the historic LOCK slowness was all due to the system bus: 
very old CPUs exported a LOCK signal to the system bus for every 
LOCK-prefix access (implicit and explicit) and that made it _really_ 
expensive. (hundreds of cycles)

... on reasonably modern CPUs the LOCK-ed access has been abstracted 
away to within the CPU, and the cost of LOCK-ed access is rather low 
(think 10-20 cycles - of course only if there's no cache miss cost) 
(That's obviously the case with the GDT, with is both per CPU and well 
cached.)

on _really_ modern CPUs LOCK can be as cheap as just a few cycles - so 
low that we can stop bothering about it in the future. There's no 
fundamental physical reason why the LOCK prefix (implicit or explicit) 
should be expensive.

the real reason why Alexander's patch needs to be measured is not the 
LOCK cycle of GDT accesses but what i pointed out in my first mail: 
the segmentation trick it plays. And that's why shrinking the stubs is 
probably a better idea which should be tried first.

... anyway, the unacceptable tone of your reply shows that you still 
have not changed a bit in your old habit of attacking and bullying 
people on lkml. All the other Intel engineers i'm working with as a 
maintainer show a very professional approach and are very easy to work 
with. You need to stop your attacks, and until you change this 
negative way of working with people i'll continue to ignore you.

	Ingo
