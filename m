Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbXGGLzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbXGGLzk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 07:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbXGGLza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 07:55:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38261 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752890AbXGGLz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 07:55:29 -0400
Date: Sat, 7 Jul 2007 09:50:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oliver Neukum <oliver@neukum.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH -mm] Freezer: Handle uninterruptible tasks
Message-ID: <20070707075018.GB2638@elf.ucw.cz>
References: <200707061012.48998.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707061012.48998.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The main limitation of the freezer is that it cannot handle uninterruptible
> tasks.  Namely, if there are uninterruptible tasks in the system, the freezer
> returns an error, which makes it impossible to suspend the system.
...
> Unfortunately, this mechanism also leads to severe limitations, such as that it
> makes the freezer unable to handle systems using FUSE in a reliable way.
> 
> This patch makes the freezer skip uninterruptible user space tasks (ie. such
> that have an mm of their own) when counting the tasks to be frozen.  As a
> result, these tasks have the TIF_FREEZE and TIF_SIGPENDING flags set, but the
> freezer doesn't wait for them to enter the refrigerator.  Nevertheless, they
> will enter the refrigerator as soon as they change their state.

I don't think we can do that. I suspect rename looks like:

	write directory entry in source
A)	(uninterruptible wait for write)
	write directory entry in destination
	(uninterruptible wait for write)
	write something else

If we freeze some task in place "A)", we'll write to the disk when the
directory write is finished :-(.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
