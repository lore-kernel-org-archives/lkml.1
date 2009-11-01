Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbZKAWDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbZKAWDs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 17:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbZKAWDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 17:03:47 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57344 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbZKAWDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 17:03:44 -0500
Date: Sun, 1 Nov 2009 23:03:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-arm-kernel@lists.infradead.org, Eric <eric.y.miao@gmail.com>,
       Haojian Zhuang <haojian.zhuang@marvell.com>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@Opfer-Online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com, dbaryshkov@gmail.com, omegamoon@gmail.com,
       utx@penguin.cz, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Possible suspend/resume regression in .32-rc?
Message-ID: <20091101220341.GA16698@elf.ucw.cz>
References: <20091031013427.GL14091@buzzloop.caiaq.de>
 <20091101205449.GT14091@buzzloop.caiaq.de>
 <20091101213343.GA31345@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091101213343.GA31345@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi!
> 
> > > Is anyone using suspend/resume with a recent git mainline kernel on PXA
> > > or other ARM embedded boards? My platform used to suspend and resume
> > > just fine on 2.6.31 but now as I rebased it, it fails the resume part.
> > > 
> > > Unfortunately, I can't bisect it as the platform is not mainline yet and
> > > so I always have mandatory patches (without my platform won't do
> > > anything) on top of the git repository. Which breaks the bisect logic.
> > > 
> > > What puzzles me is that I see the current raising at wakeup time, so at
> > > least the processor seems to resume, but I can't see any serial console
> > > output, just like if the kernel crashed very early after wakeup.
> > > 'no_console_suspend' didn't help either.
> > 
> > Ok, got it. The culprit is commit d2c37068 ("[ARM] pxa: initialize
> > default interrupt priority and use ICHP for IRQ handling"). Reverting it
> > make suspend/resume work again on my board.
> > 
> > Haojian, Eric, could you have a look at this?
> 
> Okay, patch is this one: I'll test reverting it shortly.
> 
> commit d2c37068429b29d6549cf3486fc84b836689e122
> Author: Haojian Zhuang <haojian.zhuang@marvell.com>
> Date:   Wed Aug 19 19:49:31 2009 +0800
> 
>     [ARM] pxa: initialize default interrupt priority and use ICHP for IRQ handling
>     
>     Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
>     Signed-off-by: Eric Miao <eric.y.miao@gmail.com>

And yes, reverting it _does_ fix suspend on spitz.

									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
