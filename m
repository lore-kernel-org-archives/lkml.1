Return-Path: <linux-kernel-owner+w=401wt.eu-S938008AbXG0Vv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938008AbXG0Vv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 17:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760603AbXG0Vvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 17:51:49 -0400
Received: from neon.samage.net ([85.17.153.66]:54528 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760212AbXG0Vvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 17:51:47 -0400
Message-ID: <52449.81.207.0.53.1185573103.squirrel@secure.samage.net>
In-Reply-To: <1185568498.2711.5.camel@laptopd505.fenrus.org>
References: <200707272243.02336.a1426z@gawab.com>
    <1185568498.2711.5.camel@laptopd505.fenrus.org>
Date: Fri, 27 Jul 2007 23:51:43 +0200 (CEST)
Subject: Re: swap-prefetch:  A smart way to make good use of idle resources 
     (was: updatedb)
From: "Indan Zupancic" <indan@nul.nu>
To: "Arjan van de Ven" <arjan@infradead.org>
Cc: "Al Boldi" <a1426z@gawab.com>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 76f3589a93270604ea078d468a2051b3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, July 27, 2007 22:34, Arjan van de Ven wrote:
> On Fri, July 27, 2007 21:43, Al Boldi wrote:
>> IMHO, what everybody agrees on, is that swap-prefetch has a positive effect
>> in some cases, and nobody can prove an adverse effect (excluding power
>> consumption).  The reason for this positive effect is also crystal clear:
>> It prefetches from swap on idle into free memory, ie: it doesn't force
>
> the fact that there is free memory is ... strange. IN principle, Linux
> keeps almost no memory free (except some emergency buffers) so that
> things you swap in prematurely will BY DEFINITION go at the expense of
> other things that could be there....

It's not strange, the use case here is if something memory hungry process
is shut down it leaves behind a lot of free memory. Having things swapped
out while there's free memory is strange, so swap prefetch fills it up again.

> also, they take up seek time (5 to 10 msec), so if you were to read
> something else at the time you get additional latency.

If there's other disk activity swap prefetch shouldn't do much, so this isn't
really true.

>> Conclusion:  Either prove swap-prefetch is broken, or get this merged quick.

There are a whole lot of other requirements too than that it isn't broken (of
which most are fulfilled, but anyway). One reason could be that there's a
better solution out there for the problem swap prefetch tries to solve. That
said, as swap prefetch is here now for a while and that other solution not it's
not such a great argument.

Personally I think that a more generic solution would be better, one that
prefetches the lastly evicted pages back in, not favouring either of swap or
file data, like swap prefetch does now.

Greetings,

Indan


