Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbZJGVNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbZJGVNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZJGVNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:13:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56829 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbZJGVNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:13:08 -0400
Date: Wed, 7 Oct 2009 23:12:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       linux-input@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 32-rc1 aka 32-rc2: warning at manage.c:361 (set_irq_wake),
	matrix-keypad related?
Message-ID: <20091007211225.GB17805@elf.ucw.cz>
References: <20090930200746.GA1384@ucw.cz> <20091006050649.GH27881@core.coreip.homeip.net> <20091006075816.GA1362@ucw.cz> <20091007043603.GC10204@core.coreip.homeip.net> <f17812d70910070742y5e27f9c3u38e3299b94f33613@mail.gmail.com> <20091007163327.GA12053@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007163327.GA12053@core.coreip.homeip.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > OK, so it looks like your box refuses to set up one of the GPIOs as a
> > > wakeup source... Hmm, either your box is wrong ;) or matrix_keypad
> > > driver needs to maintain a separate list of wakeup GPIOs.
> > >
> > 
> > This is due to the nature of PXA processor, where not every GPIO can
> > be configured as a wakeup source. Mmm.... we can either return a
> > pseudo value indicating setting wakeup on that GPIO is OK (which
> > doesn't sound like a good idea), or we can just ignore the failure of
> > enable_irq_wake() in matrix_keypad?
> 
> We ignore the failure right now in the mainline but that causes stack
> traces on resume as we trying to disable not enabled wakeup GPIOs. That
> was original Pavel's complaint.

Yep...

I'd say that BUG() simply should not trigger if wakeup can not be
enabled/disabled for particular source...?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
