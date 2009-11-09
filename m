Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbZKIMF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbZKIMF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 07:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbZKIMF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 07:05:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49729 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488AbZKIMFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 07:05:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Dasgupta, Romit" <romit@ti.com>
Subject: Re: [PATCH 1/1] PM: Thaws refrigerated and to be exited kernel threads
Date: Mon, 9 Nov 2009 13:06:38 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31.5-tst; KDE/4.3.1; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
References: <B85A65D85D7EB246BE421B3FB0FBB59301DE31F934@dbde02.ent.ti.com> <20091109083133.GB4818@elf.ucw.cz> <B85A65D85D7EB246BE421B3FB0FBB59301DE3B67A0@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB59301DE3B67A0@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911091306.38148.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 November 2009, Dasgupta, Romit wrote:
> > Really? I believe the "ktrhead_should_stop" is new rule, and code does
> > not seem to follow it. Actually, for example audit does not seem to
> > use kthread_should_stop() at all...
> > 
> > ./kernel/rtmutex-tester.c-
> > ./kernel/rtmutex-tester.c-		/* Wait for the next 
> > command to be executed */
> > ./kernel/rtmutex-tester.c-		schedule();
> > ./kernel/rtmutex-tester.c:		try_to_freeze();
> > ./kernel/rtmutex-tester.c-
> > ./kernel/rtmutex-tester.c-		if (signal_pending(current))
> > ./kernel/rtmutex-tester.c-			flush_signals(current);
> > --
> Not a new rule. For these threads you listed no one stops them by sending 
> 'kthread_stop' so the problem does not arise! But for the threads that are 
> stopped by invoking kthread_stop they do check kthread_should_stop. 

At the moment we don't have the rule that kernel threads should exit
immediately after kthread_stop() is called for them, which your patch implies
for freezable kernel threads.

Now, I think we might require the freezable kernel threads to exit as soon as
ktrhead_should_stop() is true for them, but (a) that needs to be documented
(please note it also applies to freezable workqueues) and (b) the existing
freezable kernel threads need to be audited, so we're sure they follow this
rule.  Also, it might lead to subtle problems if someone overlooks this
rule in the future.

So, I'd rather not introduce such a rule if there's no other way to fix the
problem at hand.

BTW, in future please describe the motivation for a change in the changelog
or people will wonder what the change is for.  In particular, if it fixes a
problem, please describe the problem and why you think your approach is
appropriate for fixing it.

Thanks,
Rafael
