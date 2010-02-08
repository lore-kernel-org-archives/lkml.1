Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab0BHJkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 04:40:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54808 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521Ab0BHJkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 04:40:01 -0500
Message-ID: <4B6FDAED.9060204@zytor.com>
Date: Mon, 08 Feb 2010 01:35:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@googlemail.com>, Borislav Petkov <bp@amd64.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for hweight_long(CONSTANT)
References: <1265222875.24455.1020.camel@laptop> <4B69D362.10608@zytor.com> <20100204151050.GC32711@aftab> <1265296432.22001.18.camel@laptop> <20100204155419.GD32711@aftab> <1265299457.22001.72.camel@laptop> <20100205121139.GA9044@aftab> <4B6C93A2.1090302@zytor.com> <20100206093659.GA28326@aftab> <4B6E1DA3.50204@zytor.com> <20100208092845.GB12618@a1.tnic>
In-Reply-To: <20100208092845.GB12618@a1.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2010 01:28 AM, Borislav Petkov wrote:
>
> Well, in the second version I did replace a 'call _hweightXX' with
> the actual popcnt opcode so the alternatives is only needed to do the
> replacement during boot. We might just as well do
>
> if (X86_FEATURE_POPCNT)
> 	__hw_popcnt()
> else
> 	__software_hweight()
>
> The only advantage of the alternatives is that it would save us the
> if-else test above each time we do cpumask_weight. However, the if-else
> approach is much more readable and obviates the need for all that macro
> magic and taking special care of calling c function from within asm. And
> since we do not call cpumask_weight all that often I'll honestly opt for
> alternative-less solution...
>

The highest performance will be gotten by alternatives, but it only make 
sense if they are inlined at the point of use... otherwise it's 
basically pointless.

	-hpa
