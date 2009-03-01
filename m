Return-Path: <linux-kernel-owner+w=401wt.eu-S1756269AbZCAAdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbZCAAdO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 19:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbZCAAc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 19:32:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56080 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbZCAAc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 19:32:57 -0500
Message-ID: <49A9D6CA.30906@zytor.com>
Date: Sat, 28 Feb 2009 16:28:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       arjan@infradead.org, mingo@elte.hu, nickpiggin@yahoo.com.au,
       sqazi@google.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
References: <alpine.LFD.2.00.0902280904271.3111@localhost.localdomain> <20090228092450.3ded2db5@infradead.org> <alpine.LFD.2.00.0902280935010.3111@localhost.localdomain> <20090228.160651.228301019.davem@davemloft.net> <20090301004003.GF26292@one.firstfloor.org>
In-Reply-To: <20090301004003.GF26292@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> I think this is an accurate analysis as well, it's really unfortunate
>> the non-temporal stuff on x86 doesn't preserve existing cache lines
>> when present.
>>
>> I thought that was the whole point.  Don't pollute the caches, but
>> if cache lines are already loaded there, use them and don't purge!
> 
> x86 actually supports that, it's just not done through movnt.
> 
> You can do that on x86 by using PREFETCHNTA (or T0/T1/T2 for specific
> cache levels). Typically this is implemented by forcing the cache line 
> to only a single way of the cache (so only using max 1/8 or so of your last 
> level cache) 
> 
> I'm not sure how it interacts with REP MOVS* though, this internally
> tends to do additional magic for larger copies.

The PREFETCHNTA stuff is really for reads rather than writes, however.
Yes, you can prefetch the cache line you're about to overwrite, but I
suspect (I haven't verified) that you lose out on whole-line
optimizations that way.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

