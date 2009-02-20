Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbZBTNAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbZBTNAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 08:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbZBTM7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 07:59:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39036 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283AbZBTM7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 07:59:44 -0500
Date: Fri, 20 Feb 2009 13:59:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gleb Natapov <gleb@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: enable x2apic early at the first point
Message-ID: <20090220125919.GE26418@elte.hu>
References: <499DD40F.40102@kernel.org> <1235081612.14523.23.camel@vayu> <499DE05A.40804@kernel.org> <1235086118.14523.40.camel@vayu> <20090220083528.GB24555@elte.hu> <20090220090912.GA4632@redhat.com> <20090220094123.GJ24555@elte.hu> <20090220105804.GA24826@redhat.com> <20090220110651.GH28581@elte.hu> <20090220123328.GC24826@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220123328.GC24826@redhat.com>
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


* Gleb Natapov <gleb@redhat.com> wrote:

> On Fri, Feb 20, 2009 at 12:06:51PM +0100, Ingo Molnar wrote:
> > > > > If you'll revert my patch it will not be possible to use 
> > > > > x2apic in KVM (at least without KVM implementing interrupt 
> > > > > remapping which is unneeded otherwise) and x2apic interface is 
> > > > > much better for vitalization. Instead of reverting the patch 
> > > > > it will be better to add check if x2apic can be used without 
> > > > > intr-remmaping (all CPUs belong to cluster 0) or allow 
> > > > > enabling of x2apic without IR if running as a guest.
> > > > 
> > > > yep, that would be required - because your patch can break real 
> > > > systems right now. Mind sending me a fix for it?
> > > > 
> > > > I've applied Yinghai's fix as well, so please base it on latest 
> > > > tip:master.
> > > > 
> > > OK. Will send next week.
> > 
> > ok, that's too long of a breakage window - i'll revert it then, 
> > please send a new version once you have it.
> > 
>
> What approach you actually prefer? Enable x2apic without 
> intr-remapping only when running in KVM, or even if running on 
> real HW but all CPUs are in cluster 0? If former then below is 
> updated patch (tested only in KVM) if later then it's 
> definitely for next week :)

The latter would be the ideal solution - i.e. next week :)

x2apic is a rare feature, and the more exposure we give it the 
more tested it becomes. It's also obviously good for general 
code structure if core CPU features are separated from 
chipset/iommu features.

Plus, x2apic accesses could actually be faster than UC accesses 
to the lapic, so whenever we can we should enter x2apic mode - 
even if intr-remap is not turned on (because not needed).

	Ingo
