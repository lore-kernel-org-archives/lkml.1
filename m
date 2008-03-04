Return-Path: <linux-kernel-owner+w=401wt.eu-S1761277AbYCDWS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761277AbYCDWS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 17:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbYCDWSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 17:18:51 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52976 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbYCDWSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 17:18:50 -0500
Date: Tue, 4 Mar 2008 23:19:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] freezer vs stopped or traced
Message-ID: <20080304221920.GB7646@elf.ucw.cz>
References: <20080304042205.4DA9F2700FB@magilla.localdomain> <200803042302.44828.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803042302.44828.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > This changes the "freezer" code used by suspend/hibernate in its treatment
> > of tasks in TASK_STOPPED (job control stop) and TASK_TRACED (ptrace) states.
> > 
> > As I understand it, the intent of the "freezer" is to hold all tasks
> > from doing anything significant.  For this purpose, TASK_STOPPED and
> > TASK_TRACED are "frozen enough".  It's possible the tasks might resume
> > from ptrace calls (if the tracer were unfrozen) or from signals
> > (including ones that could come via timer interrupts, etc).  But this
> > doesn't matter as long as they quickly block again while "freezing" is
> > in effect.  Some minor adjustments to the signal.c code make sure that
> > try_to_freeze() very shortly follows all wakeups from both kinds of
> > stop.  This lets the freezer code safely leave stopped tasks unmolested.
> > 
> > Changing this fixes the longstanding bug of seeing after resuming from
> > suspend/hibernate your shell report "[1] Stopped" and the like for all
> > your jobs stopped by ^Z et al, as if you had freshly fg'd and ^Z'd them.
> > It also removes from the freezer the arcane special case treatment for
> > ptrace'd tasks, which relied on intimate knowledge of ptrace
> > internals.

I'm glad someone who actually understands signal code got to look at
this ;-). The patch looks okay to me, but I can't say I'm too
qualified in this area.

...but this is 2.6.26 material, right?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
