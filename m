Return-Path: <linux-kernel-owner+w=401wt.eu-S1761117AbXHGKkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761117AbXHGKkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 06:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbXHGKkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 06:40:47 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:7368 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbXHGKkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 06:40:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ji9mOzlC0WANClCMGspOF0Mnt7HGHtVQnQxiWgCbtnSjU3fQJV/WQvDqDnnVLaObdvL0ru0mXZLESzhOfnN5mC+Vsn9imFpzYBOa4HiRovN3RgbkPk+OAt+ncvWAZ6z/qBamGnqB0C+IY4OVOvOrTBZYPaADga8dstBADKbvz4s=
Message-ID: <1a297b360708070340i1096a64bp3390aa7272ce9bba@mail.gmail.com>
Date: Tue, 7 Aug 2007 14:40:45 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH] msleep() with hrtimers
Cc: "Roman Zippel" <zippel@linux-m68k.org>, "Jonathan Corbet" <corbet@lwn.net>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       akpm@linux-foundation.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1186415621.2706.4.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <15327.1186166232@lwn.net>
	 <1186185229.3153.11.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708040345530.1817@scrub.home>
	 <1186255149.2777.3.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708060150270.1817@scrub.home>
	 <1186360983.2697.8.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708060257010.1817@scrub.home>
	 <1186378798.2697.10.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708061159370.1817@scrub.home>
	 <1186415621.2706.4.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

On 8/6/07, Arjan van de Ven <arjan@infradead.org> wrote:
> On Mon, 2007-08-06 at 12:03 +0200, Roman Zippel wrote:
> > Hi,
> >
> > On Sun, 5 Aug 2007, Arjan van de Ven wrote:
> >
> > > > There's no problem to provide a high resolution sleep, but there is also
> > > > no reason to mess with msleep, don't fix what ain't broken...
> > >
> > > John Corbet provided the patch because he had a problem with the current
> > > msleep... in that it didn't provide as good a common case as he
> > > wanted... so I think your statement is wrong ;)
> >
> > Only under the assumptation, that msleep _must_ be "fixed" for all other
> > current users too.
> > Give users a choice to use msleep or nanosleep, how do you know what's
> > "best" for them?
>
> do you have any actual technical objections, or do you just hate
> hrtimers in general?
>
> I really don't see what you hate so much about making the msleep()
> implementation provide a more precise (typical sleep time of 1msec
> rather than 20msec) behavior than the current one. Trying to distract
> that by proposing a very different API (working on a totally different
> time unit, while a lot of kernel users are using miliseconds; don't get
> me wrong, a usleep() and nsleep() might be useful if there's users that
> want to sleep in such times) is just trying to distract the issue.
>
> So, let me ask a direct question: What do you think is specifically
> wrong about changing the msleep() implementation as is done here? The
> behavior is clearly an improvement, so what is your objection on the
> flipside?
>

I think there could be a flipside based on what Roman said, but it is
my guess only.
currently wherever msleep is used now it sleeps with an ambiguous amount.

Eventhough the ambiguous sleep period is not appreciable, fixing
msleep might have a bad side effect. ie, drivers which would be
sleeping for a specified period would sleep less, just as compared to
the more precise sleep.

I think, it would be hard to fix, such breakages. Maybe a newer sleep
method would be much better, such that it doesn't cause any breakage.
