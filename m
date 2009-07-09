Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbZGJMGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbZGJMGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbZGJMFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:05:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53411 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850AbZGJMFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:05:45 -0400
Date: Fri, 10 Jul 2009 01:20:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, a.p.zijlstra@chello.nl,
       oleg@redhat.com, avorontsov@ru.mvista.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] sched: Remove SYSTEM_RUNNING checks from
	cond_resched*()
Message-ID: <20090709232021.GD1469@ucw.cz>
References: <20090707235812.GA12824@oksana.dev.rtsoft.ru> <20090708005000.GA12380@redhat.com> <1247034263.9777.24.camel@twins> <alpine.LFD.2.01.0907080907210.3210@localhost.localdomain> <20090708141024.f8b581c5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708141024.f8b581c5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > That said, I do agree that maybe SYSTEM_RUNNING isn't the right check. 
> > Testing that the scheduler is initialized may be the more correct one. I 
> > think the SYSTEM_RUNNING one just comes from that being used for other 
> > debug issues.
> 
> Agreed.  system_state is too general.
> 
> If we specifically want to know whether it is safe to call schedule() then
> let's create a global boolean it_is_safe_to_call_schedule and test that,
> rather than testing something which indirectly and unreliably implies "it
> is safe to call schedule".  If that boolean already exists then no-brainer.

or maybe we could embed that check into schedule(), just returning
when scheduler is not ready?

And I always wondered... system_state is not protected by any kind of
lock and is not atomic_t... Does it all work by mistake?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
