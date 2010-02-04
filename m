Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab0BDPVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 10:21:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43448 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932346Ab0BDPVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 10:21:44 -0500
Message-ID: <4B6AE4BE.70600@zytor.com>
Date: Thu, 04 Feb 2010 07:16:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for hweight_long(CONSTANT)
References: <20100130094515.475881280@intel.com> <20100130094957.692671259@intel.com> <20100201124825.cc024f2a.akpm@linux-foundation.org> <20100203133951.GA24357@localhost> <20100203070825.e36b3932.akpm@linux-foundation.org> <1265210157.24455.646.camel@laptop> <20100203074251.e2caa3f3.akpm@linux-foundation.org> <20100203181425.GB1367@aftab> <1265222875.24455.1020.camel@laptop> <4B69D362.10608@zytor.com> <20100204151050.GC32711@aftab>
In-Reply-To: <20100204151050.GC32711@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2010 07:10 AM, Borislav Petkov wrote:
>>
>> Arguably the "best" option is to have the alternative being a jump to an
>> out-of-line stub which does the necessary parameter marshalling before
>> calling a stub.  This technique is already used in a few other places.
> 
> Ok, here's a first alpha prototype and completely untested. The asm
> output looks ok though. I've added separate 32-bit and 64-bit helpers in
> order to dispense with the if-else tests. The hw-popcnt versions are the
> opcodes for "popcnt %eax, %eax" and "popcnt %rax, %rax", respectively,
> so %rAX has to be preloaded with the bitmask and the computed value
> has to be retrieved from there afterwards. And yes, it looks not that
> elegant so I'm open for suggestions.
> 
> The good thing is, this should work on any toolchain since we don't rely
> on the compiler to know about popcnt and we're protected by CPUID flag
> so that the hw-popcnt version is used only on processors which support
> it.
> 
> Please take a good look and let me know what do you guys think.
> 

I think you misunderstood me.  The idea was to use the alternatives
mechanism to put the popcnt instruction inline instead of the call.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

