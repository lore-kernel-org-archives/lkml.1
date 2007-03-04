Return-Path: <linux-kernel-owner+w=401wt.eu-S1752422AbXCDTVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422AbXCDTVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 14:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbXCDTVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 14:21:42 -0500
Received: from hot.fatooh.org ([63.99.9.127]:49806 "EHLO hot.fatooh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbXCDTVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 14:21:42 -0500
Message-ID: <45EB1C44.1000702@fatooh.org>
Date: Sun, 04 Mar 2007 11:21:40 -0800
From: Corey Hickey <bugfood-ml@fatooh.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Nix <nix@esperi.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_PREEMPT -> crash under load in 2.6.20?
References: <87d53qxbzi.fsf@hades.wkstn.nix>
In-Reply-To: <87d53qxbzi.fsf@hades.wkstn.nix>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nix wrote:
> The lockups are almost total: network traffic ceases, the keyboard goes
> dead, nothing hits the disk. Once, however, it locked up while I was
> playing an ogg (emu10k1 / SB Live), and the sound did *not* die, but
> instead went into a ~1.5s-long tight loop. (Perhaps this was the card
> running on its own with no CPU assistance: I don't know enough about
> emu10k1 to know if that's plausible.)

I've seen the same thing. As I understand it, that's just the card
looping through its buffer repeatedly, which isn't getting changed when
the software is locked up.

> I can't tell if magic sysrq dies, because as far as I know there's no
> way to get magic sysrq to do much visible when you're in X, and I can't
> get anything to go over the network kernel syslog because the network is
> dead.

You should still be able to use SysRQ even in X. I tested right now.
1. Have X running already and then start X in another VT
   $ X :2 vt10
2. Hit Alt+SysRQ+K
   ---> X dies, display gets corrupted, and keyboard input ignored
3. ssh in from another machine and switch back to the running X instance
   # chvt 7

> I could begin a (really laborious, ~1 day per iteration) bisection to
> try to track this down, but before I start, has anyone seen this before? 
> Is its cause known?

I've been seeing the same behavior under different circumstances; I
don't know if it's related.

http://www.uwsg.iu.edu/hypermail/linux/kernel/0703.0/1147.html

For me, though, CONFIG_PREEMPT doesn't seem to have an effect. One thing
I had noticed, however, is that with the problem I'm experiencing,
changing some config options inexplicably delayed the onset of the
lockup, but the lockup occurred nonetheless. Have you been running with
CONFIG_PREEMPT_VOLUNTARY for a while now and not seen any problems at all?

It might be helpful if you reported your hardware information; I'd be
interested in seeing if there's much in common with my own machine.

-Corey
