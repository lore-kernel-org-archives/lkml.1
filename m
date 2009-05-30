Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbZE3WK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbZE3WK6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbZE3WKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:10:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59004 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbZE3WKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:10:49 -0400
Date: Sun, 31 May 2009 00:10:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rik van Riel <riel@redhat.com>
Cc: "Larry H." <research@subreption.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090530221024.GA23204@elte.hu>
References: <84144f020905300035g1d5461f9n9863d4dcdb6adac0@mail.gmail.com> <20090530075033.GL29711@oblivion.subreption.com> <4A20E601.9070405@cs.helsinki.fi> <20090530082048.GM29711@oblivion.subreption.com> <20090530173428.GA20013@elte.hu> <20090530180333.GH6535@oblivion.subreption.com> <20090530182113.GA25237@elte.hu> <20090530184534.GJ6535@oblivion.subreption.com> <20090530190828.GA31199@elte.hu> <4A21999E.5050606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A21999E.5050606@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rik van Riel <riel@redhat.com> wrote:

> Ingo Molnar wrote:
>> * Larry H. <research@subreption.com> wrote:
>>> On 20:21 Sat 30 May     , Ingo Molnar wrote:
>
>>>> Freeing keys is an utter slow-path (if not then the clearing is  
>>>> the least of our performance worries), so any clearing cost is in 
>>>> the noise. Furthermore, kzfree() is an existing facility already in 
>>>> use. If it's reused by your patches that brings further advantages: 
>>>> kzfree(), if it has any bugs, will be fixed. While if you add a 
>>>> parallel facility kzfree() stays broken.
>>> Have you benchmarked the addition of these changes? I would like to 
>>> see benchmarks done for these (crypto api included), since you are 
>>> proposing them.
>>
>> You have it the wrong way around. _You_ have the burden of proof here 
>> really, you are trying to get patches into the upstream kernel. I'm not 
>> obliged to do your homework for you. I might be wrong, and you can 
>> prove me wrong.
>
> Larry's patches do not do what you propose they should do, so why 
> would he have to benchmark your idea?

My (and AFAICT Pekka's) suggestion was to use unconditional kzfree() 
in the few places where it matters: crypto/WEP key and input stream 
freeing.

His counter-argument was that it is unacceptable overhead - without 
any supporting data. I dont think the overhead is a problem in those 
cases (without any supporting data either).

Obviously the argument is best settled by measurements. Done by 
whoever wants to push this code.

	Ingo
