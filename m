Return-Path: <linux-kernel-owner+w=401wt.eu-S965696AbXAZP5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965696AbXAZP5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 10:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965708AbXAZP5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 10:57:48 -0500
Received: from smtpout.mac.com ([17.250.248.178]:59155 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965696AbXAZP5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 10:57:48 -0500
In-Reply-To: <Pine.LNX.4.64.0701260219040.17773@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0701250426400.7715@CPE00045a9c397f-CM001225dbafb6> <20070125192044.c9c2a093.akpm@osdl.org> <Pine.LNX.4.64.0701260219040.17773@CPE00045a9c397f-CM001225dbafb6>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <0A70B252-C11C-4A5C-93B3-AEF820C9D284@mac.com>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       dhowells@redhat.com
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Add a rounddown_pow_of_two() macro to log2.h.
Date: Fri, 26 Jan 2007 10:57:30 -0500
To: "Robert P. J. Day" <rpjday@mindspring.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 26, 2007, at 02:24:35, Robert P. J. Day wrote:
> On Thu, 25 Jan 2007, Andrew Morton wrote:
>> On Thu, 25 Jan 2007 04:32:12 -0500 (EST)
>> "Robert P. J. Day" <rpjday@mindspring.com> wrote:
>>> +/*
>>> + * round down to nearest power of two
>>> + */
>>> +static inline __attribute__((const))
>>> +unsigned long __rounddown_pow_of_two(unsigned long n)
>>> +{
>>> +	return 1UL << (fls_long(n) - 1);
>>> +}
>>
>> So __rounddown_pow_of_two(16) returns 8?
>
> it does?  but if that was true, so would 17, and 18, and 19 ...  i  
> didn't actually test this since it seemed so straightforward.  
> doesn't fls_long() return the most significant bit?  oh, wait ...  
> reading further ...

The way that "ilog2" is defined this should be really  
straightforward, I dunno why those functions seem so
overly complicated:
   roundup_pow_of_two(x) := 1 << ilog2(2*x - 1)
   rounddown_pow_of_two(x) := 1 << ilog2(x)

Where ilog2(x) simply returns the first bit set in the word:
   ilog2(0) => undefined or -1 or something
   ilog2(1) => 0
   ilog2(2) => 1
   ilog2(3) => 1
   ilog2(4) => 2
   [...]

The results:
   roundup_pow_of_two(1) = 1    rounddown_pow_of_two(1) = 1
   roundup_pow_of_two(2) = 2    rounddown_pow_of_two(2) = 2
   roundup_pow_of_two(3) = 4    rounddown_pow_of_two(3) = 2
   roundup_pow_of_two(4) = 4    rounddown_pow_of_two(4) = 4
   roundup_pow_of_two(5) = 8    rounddown_pow_of_two(5) = 4
   [...]

Cheers,
Kyle Moffett

