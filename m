Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab0BNWRa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 17:17:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54923 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031Ab0BNWR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 17:17:28 -0500
Message-ID: <4B78758C.2090808@zytor.com>
Date: Sun, 14 Feb 2010 14:13:32 -0800
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
References: <4B6C93A2.1090302@zytor.com> <20100206093659.GA28326@aftab> <4B6E1DA3.50204@zytor.com> <20100208092845.GB12618@a1.tnic> <4B6FDAED.9060204@zytor.com> <20100208095945.GA14740@a1.tnic> <20100211172424.GB19779@aftab> <1266142343.5273.419.camel@laptop> <20100214112447.GA8353@liondog.tnic> <4B7842C0.20701@zytor.com> <20100214202841.GA25110@liondog.tnic>
In-Reply-To: <20100214202841.GA25110@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2010 12:28 PM, Borislav Petkov wrote:
> 
> Hmm, basically, what PeterZ suggested is that I drop one indirection
> under __arch_hweightN, which would make x86-specific fallback functions
> superfluous.
> 
> IOW, what we have so far is:
> 
> #define hweightN(w) (__builtin_constant_p(w) ? __const_hweightN(w) : __arch_hweightN(w))
> 
> and have <asm-generic/bitops/arch_hweight.h> provide __arch_hweightN()
> -> __sw_hweightN wrappers per default, where the __sw_hweightN are the
> lib/hweight.c generic versions.
> 
> On architectures/CPUs which provide popcnt in
> hardware, we create __arch_hweightN implementations in
> <arch/[:ARCH_NAME:]/include/asm/bitops.h> overriding the
> <asm-generic/bitops/arch_hweight.h> versions by simply not including
> that last header.
> 
> Is that agreeable?
> 

That makes sense... after all, that's a pretty typical use of asm-generic.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

