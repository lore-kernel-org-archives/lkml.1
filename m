Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbZELAa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbZELAa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 20:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757978AbZELAap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 20:30:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:37064 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756952AbZELAao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 20:30:44 -0400
Subject: Re: [PATCH 2/15 -tip] x86: Add cpufeatures for Advanced Power
 Management
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <hpa@kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090511190910.GA28684@elte.hu>
References: <1242058494.5139.7.camel@ht.satnam>
	 <1242060119.5139.9.camel@ht.satnam> <1242060207.5139.11.camel@ht.satnam>
	 <4A086AB2.7010309@zytor.com>  <20090511190910.GA28684@elte.hu>
Content-Type: text/plain
Date: Tue, 12 May 2009 06:01:04 +0530
Message-Id: <1242088264.2504.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 21:09 +0200, Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > Jaswinder Singh Rajput wrote:
> >> 1. Add Advanced Power Management (Function 8000_0007h), edx
> >> 2. unification of X86_FEATURE_CONSTANT_TSC (from intel.c, amd.c to common.c)
> >> 3. Remove cpu/powerflags.c
> >> 4. Remove x86_power
> >> 5. Move 'power management' to flags of /proc/cpuinfo
> >>
> >> /proc/cpuinfo (before)
> >> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> >> mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
> >> rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc pni cx16
> >> lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch osvw skinit pname
> >> ..
> >> power management: ts ttp tm stc 100mhzsteps hwpstate
> >>
> >> /proc/cpuinfo (after)
> >> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> >> mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
> >> rdtscp lm 3dnowext 3dnow rep_good tsc_reliable nonstop_tsc pni cx16
> >> lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch osvw skinit pname
> >> ts ttp htc stc 100mhzsteps hwpstate constant_tsc
> >>
> >> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> >
> > NAK in the extreme.
> >
> > This is an incompatible change to a userspace visible API.  The 
> > fact that power management flags were separate was braindamage in 
> > the first place, of course, but we don't break established 
> > userspace APIs even if they're stupid.
> 
> Yes, and you pointed it out in an earlier reply.
> 
> Jaswinder, as hpa said it before, we only ever extend cpuflags (i.e. 
> add new ones mainly, and map new CPUs to the existing flags), but we 
> dont change their semantics.
> 

OK, then I will remove from this patch :

 3. Remove cpu/powerflags.c
 4. Remove x86_power
 5. Move 'power management' to flags of /proc/cpuinfo

--
JSR

