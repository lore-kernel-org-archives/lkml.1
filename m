Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbYIAPBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbYIAPBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 11:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYIAPBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 11:01:43 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:20556 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751457AbYIAPBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 11:01:42 -0400
Message-ID: <48BC037F.5010305@panasas.com>
Date: Mon, 01 Sep 2008 18:00:15 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Rusty Russell <rusty@rustcorp.com.au>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] debug: BUILD_BUG_ON: error on non-const		 expressions
References: <48BBE77D.7070007@panasas.com> <48BBEE04.30903@panasas.com> <48BC1065.76E4.0078.0@novell.com> <48BBFA67.9070305@panasas.com> <48BC1A10.76E4.0078.0@novell.com>
In-Reply-To: <48BC1A10.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Sep 2008 14:59:33.0008 (UTC) FILETIME=[57AD3100:01C90C43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>>>> Boaz Harrosh <bharrosh@panasas.com> 01.09.08 16:21 >>>
>>> I have to admit that I'm surprise this compiles: You replace an expression
>>> with a statement, and hence you reduce the places where BUILD_BUG_ON()
>>> can validly be used. 
>> it is only an expression because of the (void)() cast, which is what
>> I'm trying to avoid.
> 
> No, sizeof() alone is an expression, too. 

Using only sizeof() produces tons of "expression has no effect" warning
all over the place.

> Also, by using a statement you'll
> have more problems with fixing BUILD_BUG_ON_ZERO(), which must be
> an expression.
> 

What is broken with my BUILD_BUG_ON_ZERO(). I tried all tests and
it works fine. Do you have a test with unwanted results?
(Actually it's the original one I have not touched it).

>>> Of course you could wrap the whole thing in ({}),
>> "do{}while(0)" is effectively an "{}" plus the added bonus
>> of demanding an ";" ;-)
> 
> An expression likewise demands a terminating ; (or a continuation of the
> expression, i.e. by using an operator)
> 

I was not criticizing your approach, I was commenting on:
"{}" vs. do{}while(0) 

>>> Also, are you sure the compiler will eliminate the dead variable in all
>>> cases?
>>>
>>> Finally, using as common a variable as 'x' here seems dangerous, too:
>>> What if somewhere x is #define-d to something more complex than a
>>> simple identifier?
>> No it is scoped in a dead do{}while(0). What gets optimized out most
>> is the do nothing do{}while(0). The inside is just ignored.
> 
> I don't think compilers in general and gcc in particular work this way
> (i.e. automatically throwing away everything included in a dead block).
> 

I've tested and nothing is produced, even without any optimization.
But I'm not an expert.

> Jan
> 

Boaz
