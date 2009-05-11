Return-Path: <linux-kernel-owner+w=401wt.eu-S1751852AbZEKEUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbZEKEUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 00:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbZEKET7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 00:19:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50723 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbZEKET6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 00:19:58 -0400
Message-ID: <4A07A724.9010405@zytor.com>
Date: Sun, 10 May 2009 21:18:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: cpu/proc.c grouping of cpuid in /proc/cpuinfo
References: <1241941217.3200.3.camel@localhost.localdomain>
In-Reply-To: <1241941217.3200.3.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> Unification of cpuid_level.
> Also added extended_cpuid_level to make it complete.
> 
> So cpuid* and cpufeature flag come in same group and /proc/cpuinfo
> looks like on AMD box:
> 
> cpuid level     : 1
> ext cpuid level : 0x8000001a
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch osvw skinit
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Jaswinder,

/proc/cpuinfo is a userspace API.  You CANNOT change the format of it
without breaking applications.

Therefore, any change which moves flags between fields or removes fields
is unacceptable.  Adding new fields is possible, however.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

