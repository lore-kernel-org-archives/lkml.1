Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbZEKTJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbZEKTJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbZEKTJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:09:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59955 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbZEKTJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:09:25 -0400
Date: Mon, 11 May 2009 21:09:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/15 -tip] x86: Add cpufeatures for Advanced Power
	Management
Message-ID: <20090511190910.GA28684@elte.hu>
References: <1242058494.5139.7.camel@ht.satnam> <1242060119.5139.9.camel@ht.satnam> <1242060207.5139.11.camel@ht.satnam> <4A086AB2.7010309@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A086AB2.7010309@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Jaswinder Singh Rajput wrote:
>> 1. Add Advanced Power Management (Function 8000_0007h), edx
>> 2. unification of X86_FEATURE_CONSTANT_TSC (from intel.c, amd.c to common.c)
>> 3. Remove cpu/powerflags.c
>> 4. Remove x86_power
>> 5. Move 'power management' to flags of /proc/cpuinfo
>>
>> /proc/cpuinfo (before)
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>> mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
>> rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc pni cx16
>> lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch osvw skinit pname
>> ..
>> power management: ts ttp tm stc 100mhzsteps hwpstate
>>
>> /proc/cpuinfo (after)
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>> mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
>> rdtscp lm 3dnowext 3dnow rep_good tsc_reliable nonstop_tsc pni cx16
>> lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch osvw skinit pname
>> ts ttp htc stc 100mhzsteps hwpstate constant_tsc
>>
>> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
>
> NAK in the extreme.
>
> This is an incompatible change to a userspace visible API.  The 
> fact that power management flags were separate was braindamage in 
> the first place, of course, but we don't break established 
> userspace APIs even if they're stupid.

Yes, and you pointed it out in an earlier reply.

Jaswinder, as hpa said it before, we only ever extend cpuflags (i.e. 
add new ones mainly, and map new CPUs to the existing flags), but we 
dont change their semantics.

	Ingo
