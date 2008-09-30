Return-Path: <linux-kernel-owner+w=401wt.eu-S1753738AbYI3AeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbYI3AeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 20:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYI3AeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 20:34:00 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:60278 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752096AbYI3AeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 20:34:00 -0400
Subject: Re: Use CPUID to communicate with the hypervisor.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>,
       "Jun.Nakajima@Intel.Com" <Jun.Nakajima@Intel.Com>
In-Reply-To: <48E15AC7.2080603@redhat.com>
References: <1222472815.29886.43.camel@alok-dev1>
	 <48E090B6.2080809@redhat.com> <1222710924.30247.21.camel@alok-dev1>
	 <48E1227B.9040809@redhat.com> <1222717085.30247.44.camel@alok-dev1>
	 <48E15AC7.2080603@redhat.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 29 Sep 2008 17:33:58 -0700
Message-Id: <1222734838.30247.102.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-29 at 15:46 -0700, Gerd Hoffmann wrote:
> Alok Kataria wrote:
> > On Mon, 2008-09-29 at 11:46 -0700, Gerd Hoffmann wrote:
> >> But even that you can't take for granted, see the
> >> discussion of the "tsc-may-change-on-migration" problem.
> >
> > I may have been unclear in my first attempt to this question, let me try
> > again.
> > If the frequency of tsc changes during migration, it should be the task
> > of hypervisor to handle it. There could be multiple ways to solve that
> > problem, either the hypervisor emulates the old frequency (by whatever
> > way) or there are cpufreq drivers in the guest which detect changes in
> > frequency, and ask the hypervisor for the new frequency. The interface
> > still allows you to query the cpuid leaf and get the new frequency.
> > right ?
> 
> This small print is part of the guest/host ABI though, so hypervisors
> must agree here too, be it "tsc is constant" or "re-read tsc freq on
> $event" or whatever else.  Otherwise it isn't a generic interface.

Hi Gerd,

I really fail to see your point here. Maybe you can point out what am i
missing.
Think about the current situation, whenever there is migration to such a
tsc-is-different system , how does the guest come to know about the
frequency change, either through a $event or if it reboots it runs the
calibration algorithm.
How does asking the hypervisor for tsc instead of calibrating it, breaks
the semantics for this migration.

What special things does Xen do at migration, which would be affected by
this interface ?

> > Hmm, I am confused, from the patch i posted above, in
> > native_calibrate_tsc
> >
> > +       tsc_khz = hypervisor_tsc_freq();
> > +       if (tsc_khz)
> > +               return tsc_khz;
> >
> > We do ignore zero values over here.
> 
> Oh, ok.
> 
> I expected the check explicitly coded within the hypervisor_tsc_freq()
> function.  This deserves at least a comment saying that this side effect
> is actually intentional.

Yep i will document this in my next post.

Thanks,
Alok
> 
> cheers,
>   Gerd
> 
> 

