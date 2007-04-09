Return-Path: <linux-kernel-owner+w=401wt.eu-S932129AbXDIMIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbXDIMIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 08:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbXDIMIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 08:08:40 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4237 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753132AbXDIMIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 08:08:39 -0400
Date: Mon, 9 Apr 2007 14:03:52 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFD] CPU hotplug and suspend
Message-ID: <20070409140352.GB3864@ucw.cz>
References: <200704061732.32712.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704061732.32712.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Currently, we use the CPU hotplug to disable nonboot CPUs in the suspend code
> paths, but with the recent change of code ordering (ie. nonboot CPUs are
> disabled after freezing tasks _and_ devices) it has become quite troublesome.
> The reason of this is that there are some CPU hotplug notifiers registered and
> called on each run of cpu_up()/cpu_down() that assume the system to be fully
> functional, which is not the case during the suspend.  Moreover, at least some
> of them do things that are not really necessary for disabling or enabling the
> nonboot CPUs.

Right.

> The advantage of using the CPU hotplug (in its current form) for suspending is
> that if some CPUs don't reappear during the resume, we are safe.  Still, I
> think it would be more appropriate, and simpler in the long run, to notify the
> interested subsystems _only_ if one (or more) CPUs are not functional after the
> resume. 

I'm afraid that adding 'cpu not there so simulate unplug' path will
make it complex, and prone to failure, as _noone_ is going to test it.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
