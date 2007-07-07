Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbXGGL4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbXGGL4z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 07:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbXGGL4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 07:56:08 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38262 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753037AbXGGL4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 07:56:06 -0400
Date: Sat, 7 Jul 2007 13:31:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: nigel@suspend2.net
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, Oliver Neukum <oliver@neukum.org>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH -mm] Freezer: Handle uninterruptible tasks
Message-ID: <20070707113118.GA2789@elf.ucw.cz>
References: <200707061012.48998.rjw@sisk.pl> <20070707075018.GB2638@elf.ucw.cz> <200707071913.43482.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707071913.43482.nigel@nigel.suspend2.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I don't think we can do that. I suspect rename looks like:
> > 
> > 	write directory entry in source
> > A)	(uninterruptible wait for write)
> > 	write directory entry in destination
> > 	(uninterruptible wait for write)
> > 	write something else
> > 
> > If we freeze some task in place "A)", we'll write to the disk when the
> > directory write is finished :-(.
> 
> Renaming is a single syscall, so won't the process get frozen when the syscall 
> finishes? 

It would be frozen when syscall finishes. But if we freeze it at A)
point, we have a problem.

> Perhaps you've just found more logic for keeping the sys_sync there?

No, I don't think so.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
