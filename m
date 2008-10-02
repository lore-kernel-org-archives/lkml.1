Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbYJBApj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbYJBApj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 20:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYJBApa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 20:45:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38047 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbYJBAp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 20:45:29 -0400
Message-ID: <48E4183A.7090208@zytor.com>
Date: Wed, 01 Oct 2008 17:39:22 -0700
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
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors	and	Linux.
References: <1222881242.9381.17.camel@alok-dev1> <48E3BBC1.2050607@goop.org>	 <1222894878.9381.63.camel@alok-dev1> <48E3E8DE.1080602@goop.org>	 <48E3ECD1.30809@codemonkey.ws> <1222904824.7330.83.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1222904824.7330.83.camel@bodhitayantram.eng.vmware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> 
> Jun, you work at Intel.  Can you ask for a new architecturally defined
> MSR that returns the TSC frequency?  Not a virtualization specific MSR.
> A real MSR that would exist on physical processors.  The TSC started as
> an MSR anyway.  There should be another MSR that tells the frequency.
> If it's hard to do in hardware, it can be a write-once MSR that gets
> initialized by the BIOS.  It's really a very simple solution to a very
> common problem.  Other MSRs are dedicated to bus speed and so on, this
> seems remarkably similar.
> 

Ah, if it was only that simple.  Transmeta actually did this, but it's 
not as useful as you think.

There are at least three crystals in modern PCs: one at 32.768 kHz (for 
the RTC), one at 14.31818 MHz (PIT, PMTMR and HPET), and one at a higher 
frequency (often 200 MHz.)

All the main data distribution clocks in the system are derived from the 
third, which is subject to spread-spectrum modulation due to RFI 
concerns.  Therefore, relying on the *nominal* frequency of this clock 
is vastly incorrect; often by as much as 2%.  Spread-spectrum modulation 
is supposed to vary around zero enough that the spreading averages out, 
but the only way to know what the center frequency actually is is to 
average.  Furthermore, this high-frequency clock is generally not 
calibrated anywhere near as well as the 14 MHz clock; in good designs 
the 14 MHz is actually a TCXO (temperature compensated crystal 
oscillator), which is accurate to something like ±2 ppm.

	-hpa
