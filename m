Return-Path: <linux-kernel-owner+w=401wt.eu-S1755656AbZGCNgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbZGCNgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 09:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbZGCNge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 09:36:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41244 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752548AbZGCNgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 09:36:33 -0400
Date: Fri, 3 Jul 2009 14:37:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090703143746.0379b2ee@lxorguk.ukuu.org.uk>
In-Reply-To: <20090703131727.GA3207@elte.hu>
References: <20090702113529.4896.2321.stgit@t61.ukuu.org.uk>
	<20090703064518.GA30674@elte.hu>
	<20090703100834.6cb241b6@lxorguk.ukuu.org.uk>
	<20090703091655.GB3902@elte.hu>
	<20090703104459.1d9d0bbf@lxorguk.ukuu.org.uk>
	<20090703095432.GC21141@elte.hu>
	<20090703110620.64fd1283@lxorguk.ukuu.org.uk>
	<20090703102234.GA32128@elte.hu>
	<20090703114431.37abd528@lxorguk.ukuu.org.uk>
	<20090703131727.GA3207@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Its called engineering and good practice. The old code was 
> > correct. The paste of it is therefore most likely to be correct. 
> > Furthermore patches shouldn't mix clean up with other changes. So 
> > doing it as one is most definitely bad practice.
> 
> So you cannot do such trivial cleanups safely and validate the 
> result?

What part of not mixing clean-up with other changes didn't you
understand ?

I'll do them when I am doing the cleanups not midstream. Thats how the
tty layer work has been done so far and I don't plan to change policy now
because the policy is working well with entire files getting shifted to
coding style not just patches of them. It keeps the code consistently
styled.

> I came across this patch of yours on lkml and noticed a few problems 
> - checkpatch noticed a few more. Is the reviewing of patches and the 
> commenting on unclean patches a 'bogus standard'? Do we have some 
> separate standard just for you?

checkpatch is a tool, not a religion. Quite frankly the way some people
behave with it is a disgrace and it puts people off contributing to the
kernel when their 500 line driver gets nothing but emails from people
saying "that space is wrong". At least in your case you can actually
program and your opinion comes from real practise and experience - which
is more than a lot of the self appointed codingstyle police can say.

> Or to advance your bike-shed metaphor some more: today's rusty and 
> corroded items are the result of missing anti-corrosion efforts in 
> the past ...

So you want to paint it first and then do the engineering ? To give you a
simple example - the tty layer uses pr_warning/pr_err etc *nowhere*. Not
one. I could spend a day changing them all but it would be a stupid
project because many of those printk calls will change by the time we are
finished and don't you think it would be a lot saner if tty_port
structures grew a device pointer and errors at the physical side got
reported with dev_err and friends ?

So I have no time for makework. It might be a good way to get top of the
"patches commited this month" game but it doesn't fix the real problems.

There is a start and an end, and doing things in the wrong order is just
sloppy.

> Anyway ... all i did was to comment on a somewhat deficient patch 
> that you submitted to lkml. If you dont want review feedback and if 
> you feel embarrased and defensive by getting it then please dont 
> send out slightly-messy signed-off patches to lkml, it's simple as 
> that.

The message I thought was quite clear about what I was asking for. The
fact you complained about spaces and missed the fact it couldn't even
work was "enlightening" in terms of code review.

Alan
