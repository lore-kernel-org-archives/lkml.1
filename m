Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770Ab0APWHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab0APWHL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 17:07:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398Ab0APWHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 17:07:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39145 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab0APWHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 17:07:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [suspend/resume] Re: userspace notification from module
Date: Sat, 16 Jan 2010 23:07:48 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: "Bart?omiej Zimo?" <uzi18@o2.pl>, Andy Walls <awalls@radix.net>,
       Daniel Borkmann <danborkmann@googlemail.com>,
       linux-kernel@vger.kernel.org, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, zaurus-devel@www.linuxtogo.org
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001152314.30355.rjw@sisk.pl> <20100116181211.GA1603@ucw.cz>
In-Reply-To: <20100116181211.GA1603@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001162307.48085.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 January 2010, Pavel Machek wrote:
> Hi!
> 
> > > > I wasn't aware of this.
> > > > 
> > > > That may be a good reason for adding kernel-based suspend notification,
> > > > although I'd prefer ARM to notify the user space about the critical battery
> > > > status allowing it to decide what to do.
> > > 
> > > Hard to do, without breaking compatibility that goes down to 2.4.X.
> > 
> > Sending a battery-critical notification to the user space is not equivalent to
> > removing the existing kernel-based mechanism.  They can exist both at the
> > same time if the notification is sent earlier than the kernel suspends
> > everything. 
> 
> Yes, and obviously sending notification early is ok with me.
> 
> > > It really makes sense on zaurus. Those machines are simple, no
> > > smartbattery and no embedded controller subsystems. Battery will not
> > > protect itself, and its kernel job. (Should work on init=/bin/bash).
> > > 
> > > As power-off consumption is same as suspend power consumption (I
> > > beleive zaurus simply does not have true power off), suspend on
> > > critical makes some sense. (Note that it is set lower than on pcs, and
> > > that we declare battery critical sooner than that.)
> > 
> > The problem with that is it catches at least some applications unprepared and
> > notifying them that "we're suspending right now" doesn't really help, because
> > they won't have any time to react anyway.
> 
> Agreed, but so what? On PC, machine would power off at that
> point. That would surprise the apps, too.
> 
> Basically new enough userland should not make battery run low enough
> for either emergency power off or emergency suspend.

I wonder how it is supposed to achieve that without knowing the current battery
status.  Do you mean it should poll the battery driver?

Rafael
