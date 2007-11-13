Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbXKNJMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbXKNJMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 04:12:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbXKNJLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 04:11:48 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:36527 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753087AbXKNJLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 04:11:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RPUE516IntlaNepw2BurNsESVr+z78fLjV6u1gtbSbFBFrWIuaZ0tgwHNJIYH/hYdokHfQ1Zrqos3B7Ykfmm0VGdHgbui74FTJt0gWdwyde/1gY4+EDq3Oeh8ss5xkk0ewAhKTv9wgTIdUqBepFRlBiP127yrK5CIjXGr/taH/c=  ;
X-YMail-OSG: rBmfcGMVM1mTVZ4csI9caPuTOlIawOPAe0VBLQ5d4CFPHFH2HoBVYj2jN43VhwE9pAx0t8SghQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Date: Wed, 14 Nov 2007 08:08:24 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
References: <200711091136.20051.david-b@pacbell.net> <200711140645.26363.nickpiggin@yahoo.com.au> <200711140037.58049.david-b@pacbell.net>
In-Reply-To: <200711140037.58049.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711140808.24994.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2007 19:37, David Brownell wrote:
> On Tuesday 13 November 2007, Nick Piggin wrote:

> > Upstream, all spinlocks prevent preemption.
>
> I chose my wording carefully though.  A preemption point is
> more than just a small region where preemption isn't allowed.
>
> It's one of those where preemption is *INVITED* ...

With CONFIG_PREEMPT upstream, that's exactly the same (unless
you're considering preempt breaking points, which you don't
seem t obe).


> Now, in the RT case, I believe the rationale for inviting
> preemption when dropping a lock is largely related to the
> way priority inversion is handled.  When lock contention can
> block higher priority activities, dropping the lock must
> be able to trigger the relevant activity switch.

There is no specific inviting of preemption. The locks are
preemptible -- they can be preempted even while being *held*


> ... and the raw spinlocks don't support that machinery,
> while "normal" spinlocks become inversion-aware mutexes.
>
> > But these ones
> > are raw locks rather than normal locks probably because that
> > they are trivially an innermost and correct lock.
>
> As in the $SUBJECT case, I'd say.
>
> Although another point is related to "trivial":  the data
> is being protected through an operation too trivial to be
> worth paying for any of that priority logic.

A driver shouldn't get to decide that, IMO. And if there is
some policy in the -rt tree allowing these decisions, then
it's exactly the kind of thing we don't want upsream.
