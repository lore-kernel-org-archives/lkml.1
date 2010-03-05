Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab0CEJXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 04:23:42 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:50606 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751924Ab0CEJXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 04:23:39 -0500
Date: Fri, 5 Mar 2010 10:23:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: dtor@mail.ru, linux-input@vger.kernel.org, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       zaurus-devel@www.linuxtogo.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: sharp c-3000 aka spitz: fix warn_on introduced in 2.6.32-rc1
Message-ID: <20100305092338.GA32433@atrey.karlin.mff.cuni.cz>
References: <20100106071026.GD1382@ucw.cz> <f17812d71001052317h2bf25fady6bd729b35ef6db63@mail.gmail.com> <20100107065230.GA1303@ucw.cz> <f17812d71001062333y2e49fa21scf91718da9ae3091@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d71001062333y2e49fa21scf91718da9ae3091@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> > Sharp-SL code uses strange, complex grouping of gpios for wakeups
> >> > toggling. Fortunately, it is unneeded in recent kernels (and actually
> >> > provokes WARN_ONs during resume). Remove it.
> >> >
> >> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> >>
> >> Pavel,
> >>
> >> The code to be removed below is used to support pxa27x_keypad
> >> to be able to resume from sleep. What's the exact reason to remove
> >> this on spitz?
> >
> > Well, otherwise I get this during resume: (2.6.32 regression)
> >
> > (and similar for matrix-keypad, but dmitry worked around that
> > already).
> >
> > Problem is that gpio-keys and matrix-keypad want to set_wake for each
> > gpio individually, hw can do that, but pxa27x.c breaks it.
> >
> > I don't get it; what is pxa27x_keypad used on? It looks like
> > matrix-keypad subset.
> 
> pxa27x has its own specific keypad controller. And since we now
> use enable_irq_wake, and the keypad controller has only one
> such IRQ_KEYPAD, will have to setup the keypad GPIO wakeup
> as a whole.

But pxa27x keypad controlled is not used on spitz, right? So why do we
break spitz by tying GPIO wakeup settings together?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
