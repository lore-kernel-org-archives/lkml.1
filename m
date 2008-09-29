Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbYI2Wri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbYI2Wri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 18:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbYI2Wra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 18:47:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36818 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbYI2Wra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 18:47:30 -0400
Message-ID: <48E15AC7.2080603@redhat.com>
Date: Tue, 30 Sep 2008 00:46:31 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>,
       "Jun.Nakajima@Intel.Com" <Jun.Nakajima@Intel.Com>
Subject: Re: Use CPUID to communicate with the hypervisor.
References: <1222472815.29886.43.camel@alok-dev1>	 <48E090B6.2080809@redhat.com> <1222710924.30247.21.camel@alok-dev1>	 <48E1227B.9040809@redhat.com> <1222717085.30247.44.camel@alok-dev1>
In-Reply-To: <1222717085.30247.44.camel@alok-dev1>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> On Mon, 2008-09-29 at 11:46 -0700, Gerd Hoffmann wrote:
>> But even that you can't take for granted, see the
>> discussion of the "tsc-may-change-on-migration" problem.
> 
> I may have been unclear in my first attempt to this question, let me try
> again. 
> If the frequency of tsc changes during migration, it should be the task
> of hypervisor to handle it. There could be multiple ways to solve that
> problem, either the hypervisor emulates the old frequency (by whatever
> way) or there are cpufreq drivers in the guest which detect changes in
> frequency, and ask the hypervisor for the new frequency. The interface
> still allows you to query the cpuid leaf and get the new frequency.
> right ? 

This small print is part of the guest/host ABI though, so hypervisors
must agree here too, be it "tsc is constant" or "re-read tsc freq on
$event" or whatever else.  Otherwise it isn't a generic interface.

>> The real big problem are other closed-source hypervisors (VirtualPC /
>> Hyper-V / Parallels / ...).  How can we be sure they don't define that
>> leaf to something different?
> 
> How does that matter, if we are able to standardize all this then,
> hypervisors which want to run a Linux guest should effectively play by
> the standards over here or else they would never work properly on Linux.

Although we are working on world domination I think we are not close
enough yet that this is a realistic point of view.

> Hmm, I am confused, from the patch i posted above, in
> native_calibrate_tsc
> 
> +       tsc_khz = hypervisor_tsc_freq();
> +       if (tsc_khz)
> +               return tsc_khz;
> 
> We do ignore zero values over here.

Oh, ok.

I expected the check explicitly coded within the hypervisor_tsc_freq()
function.  This deserves at least a comment saying that this side effect
is actually intentional.

cheers,
  Gerd


