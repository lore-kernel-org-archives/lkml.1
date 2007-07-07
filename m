Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbXGGH4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbXGGH4k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 03:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbXGGH4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 03:56:31 -0400
Received: from ip-85-160-88-136.eurotel.cz ([85.160.88.136]:59395 "EHLO
	amd.ucw.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751033AbXGGH4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 03:56:30 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Jul 2007 03:56:26 EDT
Date: Sat, 7 Jul 2007 09:56:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Paul Mackerras <paulus@samba.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Message-ID: <20070707075630.GC2638@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0707051014180.3728-100000@iolanthe.rowland.org> <1183676393.3388.89.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183676393.3388.89.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > How will that help?  Block the kernel thread in the freezer or block it 
> > in the driver -- either way it is blocked.  So how do your deadlocks 
> > get resolved?
> 
> Because nobody is waiting on that kernel thread anyway without a freezer
> so there is no deadlock anymore.

In the deadlock we are seeing, _someone_ is waiting on userspace
thread, that leads to deadlock with freezer. We don't know who,
because we have not seen the sysrq-t dumps.

The "unknown who" will deadlock on fused frozen by driver, too. We
really need to fix the "unknown who" here.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
