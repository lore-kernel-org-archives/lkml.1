Return-Path: <linux-kernel-owner+w=401wt.eu-S1759158AbZDFWsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158AbZDFWsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758097AbZDFWsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:48:19 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:63018 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676AbZDFWsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:48:17 -0400
MIME-Version: 1.0
In-Reply-To: <003401c9b706$9c4c1b50$d4e451f0$@com>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com> 
	<20090406151054.GD5178@kernel.dk> <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain> 
	<20090406183157.GD7376@mit.edu> <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain> 
	<002501c9b6f3$f85b4910$e911db30$@com> <20090406211931.GB8586@mit.edu> 
	<003001c9b6ff$a9259ce0$fb70d6a0$@com> <2c0942db0904061504l6504934bi446f7425fcd38470@mail.gmail.com> 
	<003401c9b706$9c4c1b50$d4e451f0$@com>
Date: Mon, 6 Apr 2009 15:48:00 -0700
Message-ID: <2c0942db0904061548x2d34eff7g9b5332826509da53@mail.gmail.com>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
From: Ray Lee <ray-lk@madrabbit.org>
To: Hua Zhong <hzhong@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 6, 2009 at 3:25 PM, Hua Zhong <hzhong@gmail.com> wrote:
> You are implying that if someone upgrades their kernel, then he must
> 1) upgrade it continuously and 2) without any scrutiny. Both are untrue.

Great, then they'll notice the default ext3 data mode changed, and
adjust their scripts accordingly. Problem solved.

> There are certain things people expect from the kernel, such as
> no ABI changes. To me ext3 default option falls into this category.

As the past several hundred messages on this topic has just shown,
while people may expected metadata vs data ordering to be a guarantee,
apparently it never was unless you specifically mounted your ext3
filesystem with data=ordered. The default was only that, a default,
and one that can still be specified explicitly.

> And even if they are nuts, you can't prove they don't exist, especially
> given how many software already depends on the ordered mode.

There are an unbounded number of possible incorrect setups in the
world. Should we live in fear of their existence without any proof?

> You also conveniently forgot to quote my question about security. Both
> are valid questions, not something I just totally made up.

Security on an embedded device starts with controlling physical
access. If they have access to the storage media all bets are off,
whether it's data=ordered or not. (Access to the storage media is
really what we're talking about here -- medical data, for example,
hitting the platter before the metadata updates that then make that
data unaccessible to other userspace processes.)

Because *if* they have access to the media, they can replace any
running code on that box, and your security is worthless.

So no, I don't see how that's a valid argument.

>> If they're willing to upgrade their kernel blindly, then they
>> shouldn't be doing embedded development.
>
> Linus once said that if you don't understand "not breaking user space" then
> you should not be doing kernel development. Or something to that extent.

Luckily, I do understand, and have argued on user-space's behalf for
years now. But your argument was hypothetical embedded developers who
upgrade their kernels without seeing what defaults changed, and then
getting burned by the different semantics. I can't muster up enough
give-a-damn to care about a minute percentage of the population (us
embedded developers) who aren't doing their job of reading
kernelnewbies to see what changed.

I accept Linus' argument that the change in crash behavior for random
folk is going to be very different, and that perhaps that alone should
drive keeping the default as it is today, but now we're talking about
the desktop space.
