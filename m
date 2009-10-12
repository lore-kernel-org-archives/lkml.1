Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbZJLHPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbZJLHPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 03:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbZJLHPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 03:15:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38231 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbZJLHPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 03:15:09 -0400
Date: Mon, 12 Oct 2009 09:14:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz
Subject: Re: zaurus suspend saga: 2.6.32-rc3
Message-ID: <20091012071424.GE1765@elf.ucw.cz>
References: <20091011090423.GB1414@ucw.cz>
 <87skdpvs3y.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87skdpvs3y.fsf@free.fr>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-10-11 17:59:45, Robert Jarzmik wrote:
> Pavel Machek <pavel@ucw.cz> writes:
> 
> > Hi!
> >
> > I'm using patch similar to this for debugging:
> >
> > ...and good news is that it blinks after pressing of power button.
> >
> > ...core > pm_test also works.
> >
> > I also verified that end of pxa_pm_enter() is reached (with similar
> > blinking patch). End of corgi_pxa_pm_enter() seems to be reached, too.
> >
> > Any ideas what to try next?
> 
> For the Mitac MIO A701 board, with a similar problem, I had :
>  - removed almost all drivers (except screen and USB for control)
>  - realized that the culprit was amongst drivers (which resumed in a loop in
>  that time, should be the same now)

Seems like it is not that simple here;

suspend_enter():

	if (!error) {
		if (!suspend_test(TEST_CORE))
			error = suspend_ops->enter(state);
		sysdev_resume();
	}

[it reaches this point]
	arch_suspend_enable_irqs();
[but not this one]
	BUG_ON(irqs_disabled());

 Enable_cpus:
	enable_nonboot_cpus();

Do I have screaming irq or something?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
