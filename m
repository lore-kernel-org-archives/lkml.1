Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbXGXFRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbXGXFRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 01:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbXGXFRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 01:17:09 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:27753 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751135AbXGXFRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 01:17:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=6YSZSPus70OHnaPhIZ1oywHoWGuWmkYJwfPob7pQkkm14l1Fx9Lk8YgWh3vbbOHvju/03pB58JsgIrgZi8DYb+2cRo6Ut8E1qUDuaVVusX0OUahHewBCouWNNzzQb3sL7ClcuOXP2vyNdWcTQqIc07mOTn9O4W6T7i4oSF23ECY=  ;
X-YMail-OSG: RC8x0e4VM1mIX7FTyaOm33AzwMK37oVUsQ1w2MJivpe7r4t1046sR3yCUpyONzCJcAGqXhM3Jw--
Message-ID: <46A58B49.3050508@yahoo.com.au>
Date: Tue, 24 Jul 2007 15:16:57 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Jesper Juhl <jesper.juhl@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>	 <200707102015.44004.kernel@kolivas.org>	 <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>	 <46A57068.3070701@yahoo.com.au> <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>
In-Reply-To: <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> On 7/23/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> That said, I'm willing to run my day to day life through both a swap
> prefetch kernel and a normal one. *However*, before I go through all
> the work of instrumenting the damn thing, I'd really like Andrew (or
> Linus) to lay out his acceptance criteria on the feature. Exactly what
> *should* I be paying attention to? I've suggested keeping track of
> process swapin delay total time, and comparing with and without. Is
> that reasonable? Is it incomplete?

I don't feel it is so useful without more context. For example, in
most situations where pages get pushed to swap, there will *also* be
useful file backed pages being thrown out. Swap prefetch might
improve the total swapin delay time very significantly but that may
be just a tiny portion of the real problem.

Also a random day at the desktop, it is quite a broad scope and
pretty well impossible to analyse. If we can first try looking at
some specific problems that are easily identified.

Looking at your past email, you have a 1GB desktop system and your
overnight updatedb run is causing stuff to get swapped out such that
swap prefetch makes it significantly better. This is really
intriguing to me, and I would hope we can start by making this
particular workload "not suck" without swap prefetch (and hopefully
make it even better than it currently is with swap prefetch because
we'll try not to evict useful file backed pages as well).

After that we can look at other problems that swap prefetch helps
with, or think of some ways to measure your "whole day" scenario.

So when/if you have time, I can cook up a list of things to monitor
and possibly a patch to add some instrumentation over this updatedb
run.

Anyway, I realise swap prefetching has some situations where it will
fundamentally outperform even the page replacement oracle. This is
why I haven't asked for it to be dropped: it isn't a bad idea at all.

However, if we can improve basic page reclaim where it is obviously
lacking, that is always preferable. eg: being a highly speculative
operation, swap prefetch is not great for power efficiency -- but we
still want laptop users to have a good experience as well, right?

-- 
SUSE Labs, Novell Inc.
