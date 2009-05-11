Return-Path: <linux-kernel-owner+w=401wt.eu-S1758378AbZEKSO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbZEKSO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbZEKSOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:14:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33226 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414AbZEKSOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:14:19 -0400
Message-ID: <4A086AB2.7010309@zytor.com>
Date: Mon, 11 May 2009 11:13:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/15 -tip] x86: Add cpufeatures for Advanced Power Management
References: <1242058494.5139.7.camel@ht.satnam>	 <1242060119.5139.9.camel@ht.satnam> <1242060207.5139.11.camel@ht.satnam>
In-Reply-To: <1242060207.5139.11.camel@ht.satnam>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> 1. Add Advanced Power Management (Function 8000_0007h), edx
> 2. unification of X86_FEATURE_CONSTANT_TSC (from intel.c, amd.c to common.c)
> 3. Remove cpu/powerflags.c
> 4. Remove x86_power
> 5. Move 'power management' to flags of /proc/cpuinfo
> 
> /proc/cpuinfo (before)
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
> rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc pni cx16
> lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch osvw skinit pname
> ..
> power management: ts ttp tm stc 100mhzsteps hwpstate
> 
> /proc/cpuinfo (after)
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
> rdtscp lm 3dnowext 3dnow rep_good tsc_reliable nonstop_tsc pni cx16
> lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch osvw skinit pname
> ts ttp htc stc 100mhzsteps hwpstate constant_tsc
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

NAK in the extreme.

This is an incompatible change to a userspace visible API.  The fact 
that power management flags were separate was braindamage in the first 
place, of course, but we don't break established userspace APIs even if 
they're stupid.

	-hpa
