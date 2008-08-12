Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbYHLRiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbYHLRiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 13:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbYHLRiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 13:38:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:5252 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbYHLRiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 13:38:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Pm77Uon+Sn80C6Yl2QHo9mtPAfc6JaPBiAKwdC8mFh1NnVtoYRfPwkwz3F33iT3SOt
         /9vhLKoo9Qnsjk2wcDj5nwKojatntzZsQazn8r7NtQk04xWKfc5VL8gZV6LyfzXD5fSn
         6+7RPxvgqYAq/aySJhSiMLCMMDelR27Oo85p0=
Message-ID: <2c0942db0808121038w1e049e6bw279af5448b8bab92@mail.gmail.com>
Date: Tue, 12 Aug 2008 10:38:04 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- RCU problem
Cc: linux-kernel@vger.kernel.org, "Peter Zijlstra" <peterz@infradead.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       netdev <netdev@vger.kernel.org>
In-Reply-To: <151835.36545.qm@web82108.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <151835.36545.qm@web82108.mail.mud.yahoo.com>
X-Google-Sender-Auth: 7690113887b6371e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 10:29 AM, David Witbrodt <dawitbro@sbcglobal.net> wrote:
> Since this _feels_ like my problem alone, then it _feels_ like I
> should have to be the one to fix it.

Hard data first, and then there will be plenty of time for blame
later. Not that there's any real blame for anyone here, we just have a
bug that needs to be found and fixed.

> I hate having to throw my arms
> up and admit I am unable to do something about it....

Finding the problem is over half the battle, so you *are* doing something.

>> Can you try reverting that commit against the top of the latest tree,
>> and see if the revert applies correctly? If it does, compile and boot
>> and see if it works.
>
> OK, I can give it a try.  I probably would have tried it already but I
> noticed that the file(s) touched by the commit had been merged with one
> or more other files in the meantime, so I decided to leave it alone.  But
> now that I think about it, what is the worst that can happen?  The kernel
> will fail to build?  It will build, but it won't run?  That's happening
> already, so I have nothing to lose.

Right.

>> If it does, it'll be Yinghai's job to figure out
>> what went wrong, not yours (unless you're a real gluton for
>> punishment, and happen to know what was going on in Yinghai's head
>> when he decided that it was safe to make those changes).
>
> Well, it's his job only if his commit broke something.

His commit may have uncovered a latent problem somewhere else, that
happens often. But if the commit really is the trouble one, then two
things happen: It's rc3 or rc4 now, so we just revert the damn thing,
and then (secondly) he works with you (by adding debugging or
whatever) to figure out where the problem actually is.

The point I'm trying to make here is when you take on too much for
yourself, then it slows down debugging the problem, and means whatever
issue is in the code will be in there longer, affecting more people.

> Is 2.6.2[67] broken on your machine?

2.6.26-rc9+ seems to work fine on my system. I haven't tried 2.6.26.0
or 2.6.27-rcX yet, I'm overloaded with actual work and other things
right now. But no one is ever alone in problems with the kernel, only
alone in reporting them. You're a canary in the coal mine.

> Or on anyone's machine on LKML?
> These kernels even work on one of my machines!  So it's not clear that
> Yinghai's commit is to blame:  maybe it is, maybe it isn't.  All that
> we know is that commit triggered the problem, and we don't even know
> whether the problem will affect a lot of hardware or just mine!

Yes, all of that is true, but changes nothing.

> Anyway, I think you were really just trying to be nice, and I thank you
> for it.  I do feel marginally better.  ;)

I *am* nice :-). Email is tricky sometimes, y'know?

> I'll really feel better if the reverting experiment works.

Good luck.
