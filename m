Return-Path: <linux-kernel-owner+w=401wt.eu-S933168AbXEEQBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbXEEQBd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933174AbXEEQBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:01:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60649 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933168AbXEEQB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:01:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: [RFT][PATCH] swsusp: Change code ordering related to ACPI
Date: Sat, 5 May 2007 11:50:21 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Marcus Better" <marcus@better.se>, "Pavel Machek" <pavel@ucw.cz>,
       "Tobias Diedrich" <ranma+kernel@tdiedrich.de>,
       "pm list" <linux-pm@lists.linux-foundation.org>
References: <200705041143.02451.rjw@sisk.pl> <2c0942db0705041611u2d82fbb7m4719c1bcf8bcdbf7@mail.gmail.com>
In-Reply-To: <2c0942db0705041611u2d82fbb7m4719c1bcf8bcdbf7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705051150.22108.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 5 May 2007 01:11, Ray Lee wrote:
> On 5/4/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > The change of the hibernation/suspend code ordering made before 2.6.21 has
> > caused some systems to have problems related to ACPI.  In particular, the
> > 'platform' hibernation mode doesn't work any more on some systems.
> 
> It seems that somewhere between 2.6.21-rc4 and 2.6.21 final my laptop
> stopped being able to come out of suspend to RAM. Before I start
> bisecting (again, sigh), is this ringing any bells for anyone? In
> particular your, patch (snipped) that deals with hibernation, would it
> also affect suspend to RAM?

Not this particular one, but you may try to move pm_finish() after
resume_console() in kernel/power/main.c:suspend_prepare() and see if that
helps.

If it doesn't help, then try to compile the kernel with NO_HZ and
HIGH_RES_TIMERS unset.  If that doesn't help, you may try with HPET_TIMER
unset additionally.

Greetings,
Rafael 
