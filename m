Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbZECJo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbZECJo0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 05:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbZECJoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 05:44:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40101 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbZECJoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 05:44:16 -0400
Date: Sun, 3 May 2009 11:47:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, alan-jenkins@tuffmail.co.uk,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 1/3] PM: Disable OOM killer during system-wide power
	transitions
Message-ID: <20090503094718.GB10278@elf.ucw.cz>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905020027.31244.rjw@sisk.pl> <20090501160931.1dbd2abc.akpm@linux-foundation.org> <200905021334.51261.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905021334.51261.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Does the same apply to suspending?  If so, why?
> 
> Because I think it doesn't work anyway.  User space processes are frozen and
> effectively in TASK_UNINTERRUPTIBLE, so they won't be killed.
> 
> > I think this is an OK change, as long as the only thing which is
> > allocating memory is hibernation itself.  If random processes are still
> > doing random memory allocations at this time then their failed memory
> > allocation could be just as fatal as an oom-killing.  Moreso if they're
> > s/bin/init or whatever.
> 
> At this point all of the user space tasks are frozen.

Well, many kernel threads still remain active. But it is true that OOM
killer is unlikely to help.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
