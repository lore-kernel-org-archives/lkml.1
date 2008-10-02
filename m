Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbYJBBZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbYJBBZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 21:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbYJBBZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 21:25:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41851 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYJBBZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 21:25:46 -0400
Message-ID: <48E42234.9000808@zytor.com>
Date: Wed, 01 Oct 2008 18:21:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Alok Kataria <akataria@vmware.com>, "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Daniel Hecht <dhecht@vmware.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC] CPUID usage for interaction between	Hypervisors	and	Linux.
References: <1222881242.9381.17.camel@alok-dev1> <48E3BBC1.2050607@goop.org>	 <1222894878.9381.63.camel@alok-dev1> <48E3E8DE.1080602@goop.org>	 <48E3ECD1.30809@codemonkey.ws>	 <1222904824.7330.83.camel@bodhitayantram.eng.vmware.com>	 <48E4183A.7090208@zytor.com> <1222909900.7330.106.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1222909900.7330.106.camel@bodhitayantram.eng.vmware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> 
> I'm not suggesting using the nominal value.  I'm suggesting the
> measurement be done in the one and only place where there is perfect
> control of the system, the processor boot-strapping in the BIOS.
> 
> Only the platform designers themselves know the speed of the oscillator
> which is modulating the clock and so only they should be calibrating the
> speed of the TSC.
> 

No.  *Noone*, including the manufacturers, know the speed of the 
oscillator which is modulating the clock.  What you have to do is 
average over a timespan which is long enough that the SSM averages out 
(a relatively small fraction of a second.)

As for trusting the BIOS on this, that's a total joke.  Firmware vendors 
can't get the most basic details right.

> If this modulation really does alter the frequency by +/- 2% (seems high
> to me, but hey, I don't design motherboards), using an LFO, then
> basically all the calibration done in Linux is broken and has been for
> some time.  You can't calibrate only once, or risk being off by 2%, you
> can't calibrate repeatedly and take the fastest estimate, or you are off
> by 2%, and you can't calibrate repeatedly and take the average without
> risking SMI noise affecting the lowest clock speed measurement,
> contributing unknown error.

You have to calibrate over a sample interval long enough that the SSM 
averages out.

> Hmm.  Re-reading your e-mail, I see you are saying the nominal frequency
> may be off by 2% (and I easily believe that), not necessarily that the
> frequency modulation may be 2% (which I still think is high).  Does
> anyone know what the actual bounds on spread spectrum modulation are or
> how fast the clock is modulated?

No, I'm saying the frequency modulation may be up to 2%.  Typically it 
is something like [-2%,+0%].

	-hpa
