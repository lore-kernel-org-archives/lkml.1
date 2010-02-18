Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400Ab0BRPZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 10:25:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53437 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757261Ab0BRPZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 10:25:14 -0500
Message-ID: <4B7D5BB4.4000307@zytor.com>
Date: Thu, 18 Feb 2010 07:24:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Luca Barbieri <luca@luca-barbieri.com>
CC: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if available
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>	 <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>	 <87eikj54wp.fsf@basil.nowhere.org>	 <ff13bc9a1002180153g308b0f3dxb59959936d1e343b@mail.gmail.com>	 <20100218101156.GE5964@basil.fritz.box> <ff13bc9a1002180227j70e0748ag49d88c3034e3900d@mail.gmail.com>
In-Reply-To: <ff13bc9a1002180227j70e0748ag49d88c3034e3900d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2010 02:27 AM, Luca Barbieri wrote:
>> CR changes are slow and synchronize the CPU. The later is always slow.
>>
>> It sounds like you didn't time it?
> I didn't, because I think it strongly depends on the microarchitecture
> and I don't have a comprehensive set of machines to test on, so it
> would just be a single data point.
> 
> The lock prefix on cmpxchg8b is also serializing so it might be as bad.

No.  LOCK isn't serializing in the same way CRx writes are.


> Anyway, if we use this, we should keep TS cleared in kernel mode and
> lazily restore it on return to userspace.
> This would make clts/stts performance mostly moot.

This is what kernel_fpu_begin/kernel_fpu_end is all about.  We
definitely cannot leave TS cleared without the user space CPU state
moved to its home location, or we have yet another complicated state to
worry about.

I really feel that without a *strong* use case for this, there is
absolutely no point.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

