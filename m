Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab0BRS2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:28:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40376 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab0BRS2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:28:37 -0500
Message-ID: <4B7D86BC.10000@zytor.com>
Date: Thu, 18 Feb 2010 10:28:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Luca Barbieri <luca@luca-barbieri.com>
CC: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if available
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>	 <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>	 <87eikj54wp.fsf@basil.nowhere.org>	 <ff13bc9a1002180153g308b0f3dxb59959936d1e343b@mail.gmail.com>	 <20100218101156.GE5964@basil.fritz.box>	 <ff13bc9a1002180227j70e0748ag49d88c3034e3900d@mail.gmail.com>	 <4B7D5BB4.4000307@zytor.com> <ff13bc9a1002181014x5625f418j69f9702bc54c6381@mail.gmail.com>
In-Reply-To: <ff13bc9a1002181014x5625f418j69f9702bc54c6381@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2010 10:14 AM, Luca Barbieri wrote:
> 
>> I really feel that without a *strong* use case for this, there is
>> absolutely no point.
> For the specific 32-bit atomic64_t case, it is an improvement, but not
> necessarily significant in the big picture.
> Being able to efficiently use SSE in the kernel might however be more
> broadly useful.
> memcpy/memset/etc. (assuming SSE is the best option for these at least
> on some processors) and checksums come to mind.
> Also non-temporal SSE moves might be useful for things like memory
> compaction without clobbering caches.

We already do that kind of stuff, using
kernel_fpu_begin()..kernel_fpu_end().  We went through some pain a bit
ago to clean up "private hacks" that complicated things substantially.

	-hpa
