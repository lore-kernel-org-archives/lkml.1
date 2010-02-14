Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab0BNSk5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 13:40:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42877 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526Ab0BNSkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 13:40:55 -0500
Message-ID: <4B7842C0.20701@zytor.com>
Date: Sun, 14 Feb 2010 10:36:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@googlemail.com>,
       Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@amd64.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for hweight_long(CONSTANT)
References: <1265299457.22001.72.camel@laptop> <20100205121139.GA9044@aftab> <4B6C93A2.1090302@zytor.com> <20100206093659.GA28326@aftab> <4B6E1DA3.50204@zytor.com> <20100208092845.GB12618@a1.tnic> <4B6FDAED.9060204@zytor.com> <20100208095945.GA14740@a1.tnic> <20100211172424.GB19779@aftab> <1266142343.5273.419.camel@laptop> <20100214112447.GA8353@liondog.tnic>
In-Reply-To: <20100214112447.GA8353@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2010 03:24 AM, Borislav Petkov wrote:
> 
> __const_hweightN - for at compile time known constants as arguments
> __arch_hweightN - arch possibly has an optimized hweight version
> __sw_hweightN - fall back when nothing else is there, aka the functions in
> lib/hweight.c
> 
> Now, in the x86 case, when the compiler can't know that the argument is
> a constant, we call the __arch_hweightN versions. The alternative does
> call the __sw_hweightN version in case the CPU doesn't support popcnt.
> In this case, we need to build __sw_hweightN with -fcall-saved* for gcc
> to be able to take care of the regs clobbered ny __sw_hweightN.
> 
> So, if I understand you correctly, your suggestion might work, we
> simply need to rename the lib/hweight.c versions to __sw_hweightN
> and have <asm-generic/bitops/arch_hweight.h> have __arch_hweightN ->
> __sw_hweightN wrappers in the default case, all arches which have an
> optimized version will provide it in their respective bitops header...
> 

I'm not entirely sure what you're asking; if what you're asking what to
name an x86-specific fallback function, it presumably should be
__arch_sw_hweightN (i.e. __arch prefix with a modifier.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

