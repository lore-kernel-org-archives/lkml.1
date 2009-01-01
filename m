Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbZAAAP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbZAAAP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 19:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757278AbZAAAOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 19:14:47 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:51356 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262AbZAAAOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 19:14:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=N+7bLmzLuc2lYBSXT6w0yOTNGxpqxAoM64JIgh2kVWRiNz94BYJYWiAI8PV2R8Nts+
         LvN8tkyhxjif5JwT2IKyFqopu/71BcdzewMQl90V9HBbZl6XB9wkmFz2m2qXqgG8Dkti
         pxyRwfCy3vOKHA6QuUexQz2jqTxw7Ed6lWfjo=
Message-ID: <86802c440812311614n4a0ef459u4bb8be65d33994a@mail.gmail.com>
Date: Wed, 31 Dec 2008 16:14:44 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: random.c changes for sparse irq_desc are crap
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@osdl.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1230766826.19620.150.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1230748169.19620.132.camel@calx> <495BFB48.8080506@kernel.org>
	 <1230766826.19620.150.camel@calx>
X-Google-Sender-Auth: a5d013722b88b6c2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 3:40 PM, Matt Mackall <mpm@selenic.com> wrote:
> On Wed, 2008-12-31 at 15:07 -0800, Yinghai Lu wrote:
>> Matt Mackall wrote:
>> > I just noticed you merged a change that pointlessly converts two
>> > random.c functions into ugly random.h inlines without going through the
>> > maintainer.
>> >
>> > I also don't like the look of the newly-introduced sparse variants of
>> > these functions. Failure to find an irq descriptor in
>> > get_timer_rand_state is a BUG_ON should-never-happen sort of condition,
>> > not something to silently ignore. Letting the code try to dereference
>> > NULL is preferred here: we'll actually be able to find and fix the
>> > broken driver that's throwing around meaningless irq vectors.
>> >
>> > Throwing away the timer_state pointer in the set_timer_rand_state
>> > function is similarly bogus in addition to being a memory leak.
>> >
>> > Please fix this up.
>> >
>>
>> want something like this?
>
> Not quite.
>
> First, please turn these back into normal functions in random.c.
> Inlining functions is generally discouraged these days unless you have a
> good reason and numbers to back it up.

Ingo wanted to hide that #ifdef to .h

>
> Second, as I tried to explain above, BUG_ON(!desc) is doing very little
> that the subsequent desc->timer_rand_state wouldn't already do
> (generating a traceback). In cases where dereferencing NULL should never
> happen, it's preferable to not add the extra check and just let the oops
> happen. We'll still get a backtrace if anything ever goes wrong, but we
> won't have wasted any code space or CPU cycles when it doesn't.

ok

YH
