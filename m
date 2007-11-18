Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbXKRWFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbXKRWFZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 17:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbXKRWFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 17:05:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35905 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbXKRWFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 17:05:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Subject: Re: apm emulation driver broken ?
Date: Sun, 18 Nov 2007 23:22:40 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-pm@lists.linux-foundation.org, lkml <linux-kernel@vger.kernel.org>
References: <cda58cb80711160706l2cfac2b1p81c7a1090f228f2e@mail.gmail.com> <200711171346.51363.rjw@sisk.pl> <4740992D.9030906@gmail.com>
In-Reply-To: <4740992D.9030906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711182322.41354.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 18 of November 2007, Franck Bui-Huu wrote:
> Rafael J. Wysocki wrote:
> > On Saturday, 17 of November 2007, Franck Bui-Huu wrote:
> >> ok so now we agreed on this point, can we assert that a user
> >> land thread waiting for an event in an UNINTERRUPTIBLE state
> >> will prevent a suspend to happen ?
> > 
> > Yes.
> > 
> 
> So this driver seems really broken and actually I'm wondering if
> it's used by anyone...

Well, it doesn't seem so.

> See the call to wait_even() made by apm_ioctl(). If any processes
> run this, it will prevent the system to suspend...

True, but does it actually happen in practice?

> And no, I don't know why call wait_event() is called.

I hope somebody knows. :-)

At this point the second branch of the "if (as->suspend_state == SUSPEND_READ)"
can be fixed by replacing wait_event_interruptible() with
wait_event_freezable(), but the fix for the first branch depends on whether or
not the wait_event() is really necessary.

If it can be replaced with an interruptible sleep, we can use
wait_event_freezable() in this case too.  Otherwise, the only woking fix would
be to reintroduce the PF_NOFREEZE in there.

Honestly, I'm leaning towards replacing wait_event() in apm_ioctl() with
wait_event_freezable() and seeing what happens ...

Greetings,
Rafael
