Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbZGVVDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbZGVVDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 17:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZGVVDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 17:03:10 -0400
Received: from n20.bullet.mail.mud.yahoo.com ([68.142.206.147]:24115 "HELO
	n20.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752489AbZGVVDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 17:03:09 -0400
X-Yahoo-Newman-Id: 206686.21694.bm@omp409.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gsyvq0eG6aLpf7psRzpswY+mtuNB5iR7+Vo1nEjBtHV2TiYdHlsB69YYcVZyOMvq/4KLDRAmoX+Ks+QB9/fUWVYGLK+bLMIBh8VYfzfSxJ6N8FJrTIphI8FpHSvS6IgjAPs6fgapU0sBCubGrbwzUWvXZrCHcykG2HJcy4bTqhU=  ;
X-YMail-OSG: 0l5BJpUVM1n1umCT.sm3kcJhyx1oYuXqXlUPkaMDiUQZZY4hZN1.uMTDkq0RcxopghXWxe458s3PSog0uxQe8lPv7GhNvkOUYuI39CAqzdHbjmEhKMmGRR3rxG5lBNuWQkwvSDGcNBSwKtWjxw68P3DMzL99Z8KXkSiQbeWOkBHUW.GpuZZSf6_B6Xwee4GX1qdwH26WHcCpU0xVU1ze8MhD6uEzCuaZD8OzhVkqb4zJNssvFx6TJKN9vVi4iUDxlomGwtacQvgPZUI8oc7jGmtzCFt6cNsdOtBKLRtSr4bh5RcZ2g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/2] MMC/pxamci: workaround regulator framework bugs
Date: Wed, 22 Jul 2009 14:03:07 -0700
User-Agent: KMail/1.9.10
Cc: Eric Miao <eric.y.miao@gmail.com>, Daniel Ribeiro <drwyrm@gmail.com>,
       Pierre Ossman <pierre@ossman.eu>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "openezx-devel" <openezx-devel@lists.openezx.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       "linux-arm-kernel" <linux-arm-kernel@lists.arm.linux.org.uk>
References: <1246057668.10360.316.camel@brutus> <200906301936.20818.david-b@pacbell.net> <20090701114603.GA22063@rakim.wolfsonmicro.main>
In-Reply-To: <20090701114603.GA22063@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907221403.07985.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 July 2009, Mark Brown wrote:
> On Tue, Jun 30, 2009 at 07:36:20PM -0700, David Brownell wrote:
> > On Monday 29 June 2009, Mark Brown wrote:
> 
> > > At the minute the regulator API actually copes pretty well with this -
> > > the only problem I'm aware of is with drivers like the MMC driver which
> > > require exclusive control of the regulator.
> 
> > Which is a fairly typical situation for power-aware drivers.
> 
> As has been mentioned a number of times in previous discussions of this
> there is a very large class of devices which do not *require* any power
> control at all but which can usefully switch their supplies on and off.

Which I never argued with.  My comment was about their drivers.

Power-aware drivers may *require* that they can actually reduce
system power consumption ... else what's the point?  Likewise,
switching voltages needs care, and sometimes ability to switch
power on and off.


> > Which belies your claim that the regulator API "copes pretty well".
> > It'd be more accurate to say "broken-as-designed", since you have
> > rejected numerous attempts to fix this, yet not fixed it yourself.
> 
> You've suggested variations of essentially one approach, forcing the
> regulator to be off while the use count is zero.

For the record, that's simply not true.  The patches I sent tried
a variety of approaches, and I don't recall that ever being one of
them ... since that is in fact a fair description of what needed to
be FIXED.  The property my patches shared was:

	/* that this simple idiom would finally work */
	if (regulator_is_enabled(r))
		regulator_disable(r);

It's *your* proposals which preserved the property that the above
lines of code could fail (often rudely at boot time).  Until just
yesterday... when you posted

  http://marc.info/?l=linux-kernel&m=124818844611060&w=2

which is intended to provide a new mechanism, the only way to
ensure the above idiom can always work.  It looks like that will
work for $SUBJECT (MMC/SD drivers) and some similar cases.


> I have previously had to ask you to try to approach discussions on the
> regulator API in a more constructive fashion, please let me renew that
> request.  Doing so would be much less time consuming and for that reason
> if nothing else would be very helpful in progressing things.

I've previously had to ask you to respond to **what I said** not
to something you merely imagined I had said.  Don't pretend that
you were blameless.  Your approach was highly confrontational,
and rejected many constructive suggestions.  At one point you
flamed me for disagreeing ... with the point *I* was making, as
eventually became clear.

If you felt my responses were sufficiently non-constructive as to
deserve a lecture on courtesy ... you ought to have considered your
own participation.  What you saw was a rising tide of frustration
caused by (a) your refusal to address what I was actually saying,
(b) your falsely attributing statements and viewpoints to me, and
(c) rejecting around half a dozen patches to solve a problem, all
of which were within (d) an ever-increasing number of constraints
you grew with each new iteration.  I had to try so many different
approaches since nothing seemed to be getting through.  The lack
of constructive behavior was mostly on *your* part ... but when I
finally called you on that, I got a lecture back!!  Feh.  I don't
need to let such crap stand; but decided to wait until the anger
went away.

So it's no surprise I would conclude the only solution was to wait
for you to write a patch, which you would then accept.  And you
have now done that; thanks.

- Dave


