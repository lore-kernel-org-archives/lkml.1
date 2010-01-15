Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab0AOWOL (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 17:14:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755802Ab0AOWOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 17:14:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37156 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052Ab0AOWOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 17:14:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [suspend/resume] Re: userspace notification from module
Date: Fri, 15 Jan 2010 23:14:30 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: "Bart?omiej Zimo?" <uzi18@o2.pl>, Andy Walls <awalls@radix.net>,
        Daniel Borkmann <danborkmann@googlemail.com>,
        linux-kernel@vger.kernel.org, rpurdie@rpsys.net, lenz@cs.wisc.edu,
        Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
        thommycheck@gmail.com,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001091440.46434.rjw@sisk.pl> <20100115200310.GG1345@ucw.cz>
In-Reply-To: <20100115200310.GG1345@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001152314.30355.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 January 2010, Pavel Machek wrote:
> On Sat 2010-01-09 14:40:46, Rafael J. Wysocki wrote:
> > On Saturday 09 January 2010, Pavel Machek wrote:
> 
> > > > Perhaps I don't understand correctly what you're trying to achieve, but at the
> > > > moment suspend is always started from user space, this way or another, and on
> > > 
> > > At least zaurus (arm) suspends from kernel on battery critical.
> > 
> > I wasn't aware of this.
> > 
> > That may be a good reason for adding kernel-based suspend notification,
> > although I'd prefer ARM to notify the user space about the critical battery
> > status allowing it to decide what to do.
> 
> Hard to do, without breaking compatibility that goes down to 2.4.X.

Sending a battery-critical notification to the user space is not equivalent to
removing the existing kernel-based mechanism.  They can exist both at the
same time if the notification is sent earlier than the kernel suspends
everything. 

> > IMhO automatic suspend without something like the Android's wakelocks hurts
> > more than it helps.
> 
> It really makes sense on zaurus. Those machines are simple, no
> smartbattery and no embedded controller subsystems. Battery will not
> protect itself, and its kernel job. (Should work on init=/bin/bash).
> 
> As power-off consumption is same as suspend power consumption (I
> beleive zaurus simply does not have true power off), suspend on
> critical makes some sense. (Note that it is set lower than on pcs, and
> that we declare battery critical sooner than that.)

The problem with that is it catches at least some applications unprepared and
notifying them that "we're suspending right now" doesn't really help, because
they won't have any time to react anyway.

Rafael
