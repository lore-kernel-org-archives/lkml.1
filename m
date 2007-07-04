Return-Path: <linux-kernel-owner+w=401wt.eu-S1758302AbXGDXpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302AbXGDXpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 19:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbXGDXpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 19:45:45 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55903 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754841AbXGDXpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 19:45:44 -0400
Date: Thu, 5 Jul 2007 01:45:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, rjw@sisk.pl, benh@kernel.crashing.org,
       mjg59@srcf.ucam.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, nigel@nigel.suspend2.net
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Message-ID: <20070704234523.GC2719@elf.ucw.cz>
References: <20070703042916.GA17240@srcf.ucam.org> <200707032026.34649.oliver@neukum.org> <E1I5no4-0004fU-00@dorka.pomaz.szeredi.hu> <200707032132.20731.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707032132.20731.oliver@neukum.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-07-03 21:32:20, Oliver Neukum wrote:
> Am Dienstag, 3. Juli 2007 schrieb Miklos Szeredi:
> > > And a further question. The freezer is not atomic. What do you do
> > > if a task not yet frozen calls sys_sync(), but fuse is already frozen?
> > 
> > What do you do if a task not yet frozen writes to a pipe, on the other
> > end of which is a task already frozen?

There's some difference between uninterruptible and interruptible
sleep I'd say.

> > It doesn't matter.  The only thing that should matter during suspend
> > (not hibernate) is saving the state of devices to ram, and putting the
> > devices to sleep.
> 
> Well, but you did remove sys_sync() from the freezer, which is
> and must be called in the hibernate path.

Not "must". In fact, hibernation should be safe without sys_sync(). It
is just user un-friendly.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
