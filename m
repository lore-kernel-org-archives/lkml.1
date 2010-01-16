Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab0APSMZ (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 13:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579Ab0APSMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 13:12:24 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34592 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab0APSMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 13:12:24 -0500
Date: Sat, 16 Jan 2010 19:12:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bart?omiej Zimo? <uzi18@o2.pl>, Andy Walls <awalls@radix.net>,
        Daniel Borkmann <danborkmann@googlemail.com>,
        linux-kernel@vger.kernel.org, rpurdie@rpsys.net, lenz@cs.wisc.edu,
        Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
        thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org
Subject: Re: [suspend/resume] Re: userspace notification from module
Message-ID: <20100116181211.GA1603@ucw.cz>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001091440.46434.rjw@sisk.pl> <20100115200310.GG1345@ucw.cz> <201001152314.30355.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001152314.30355.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I wasn't aware of this.
> > > 
> > > That may be a good reason for adding kernel-based suspend notification,
> > > although I'd prefer ARM to notify the user space about the critical battery
> > > status allowing it to decide what to do.
> > 
> > Hard to do, without breaking compatibility that goes down to 2.4.X.
> 
> Sending a battery-critical notification to the user space is not equivalent to
> removing the existing kernel-based mechanism.  They can exist both at the
> same time if the notification is sent earlier than the kernel suspends
> everything. 

Yes, and obviously sending notification early is ok with me.

> > It really makes sense on zaurus. Those machines are simple, no
> > smartbattery and no embedded controller subsystems. Battery will not
> > protect itself, and its kernel job. (Should work on init=/bin/bash).
> > 
> > As power-off consumption is same as suspend power consumption (I
> > beleive zaurus simply does not have true power off), suspend on
> > critical makes some sense. (Note that it is set lower than on pcs, and
> > that we declare battery critical sooner than that.)
> 
> The problem with that is it catches at least some applications unprepared and
> notifying them that "we're suspending right now" doesn't really help, because
> they won't have any time to react anyway.

Agreed, but so what? On PC, machine would power off at that
point. That would surprise the apps, too.

Basically new enough userland should not make battery run low enough
for either emergency power off or emergency suspend.

IOW "nothing to see here, problem does not exist".
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
