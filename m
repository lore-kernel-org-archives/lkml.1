Return-Path: <linux-kernel-owner+w=401wt.eu-S1762943AbXGYLBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762943AbXGYLBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 07:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758803AbXGYLBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 07:01:00 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:37421 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639AbXGYLA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 07:00:59 -0400
Message-ID: <46A72CEB.7050101@gmail.com>
Date: Wed, 25 Jul 2007 12:58:51 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: david@lang.hm
CC: Ray Lee <ray-lk@madrabbit.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>  <200707102015.44004.kernel@kolivas.org>  <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>  <46A57068.3070701@yahoo.com.au>  <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>  <46A58B49.3050508@yahoo.com.au> <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com> <Pine.LNX.4.64.0707242130470.2229@asgard.lang.hm> <46A7031D.5080300@gmail.com> <Pine.LNX.4.64.0707250104180.2229@asgard.lang.hm> <46A709DC.4080501@gmail.com> <Pine.LNX.4.64.0707250130200.18679@asgard.lang.hm> <Pine.LNX.4.64.0707250132520.18679@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707250132520.18679@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2007 10:33 AM, david@lang.hm wrote:

>> I haven't used swap prefetch either, the call was put out for what 
>> could be used to test the performance, and I was suggesting a test.
>>
>> if nobody else follows up on this I'll try to get some time to test it 
>> myself in a day or two.
> 
> this assumes that this isn't ruled an invalid test in the meantime.

Let's save a little time and guess. While two instances of the hog are 
running no physical memory is free (as together they take up 1.5x physical) 
meaning that swap-prefetch wouldn't get a change to do anything and wouldn't 
make a difference. As such, the two instances test as you suggested would in 
fact not be testing anything it seems.

However, if you quit one, and idle long enough to continue with the other 
one until swap-prefetch prefetched all its memory back in, it should be a 
difference on the order of minutes, even total if swap prefetch fetched it 
back in without seeking al over swap-space, and "total" isn't applicable if 
the idle time really is free.

A program randomly touching single pages all over memory is a contrived 
worst case scenario and not a real-world issue. It is a boundary condition 
though, and it's simply quite impossible to think of any example where 
swap-prefetch would _not_ give you a snappier feeling machine after you've 
been idling.

So really the only question would seem to be -- does it hurt any if you have 
_not_ been?

Rene.

