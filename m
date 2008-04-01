Return-Path: <linux-kernel-owner+w=401wt.eu-S1757851AbYDAIpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbYDAIpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 04:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbYDAIp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 04:45:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:54092 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897AbYDAIpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 04:45:24 -0400
Date: Tue, 1 Apr 2008 10:45:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Shaohua Li <shaohua.li@intel.com>, Felix M?ller <fm@opensuse.org>,
       Arthur Erhardt <erhardt@pit.physik.uni-tuebingen.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] ACPI PM: Restore the 2.6.24 suspend ordering
Message-ID: <20080401084523.GA25278@atrey.karlin.mff.cuni.cz>
References: <200803300319.08398.rjw@sisk.pl> <200803301358.39831.rjw@sisk.pl> <20080330122838.GA7093@elf.ucw.cz> <200803301515.33922.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803301515.33922.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > For the reasons outlined above, the change of the suspend ordering
> > > > > should be reverted, which is done by the patch below.
> > > > 
> > > > But this will break those few nvidia-based systems, no?
> > > > 
> > > > this may have been a good idea in -rc1 days, but we are in -rc7
> > > > now... and the patch is slightly big.
> > > 
> > > It's quite obvious, though.
> > 
> > Yes, but breaking systems between -rc7 and final is _very_ unnice.
> 
> Breaking systems between 2.6.24 and 2.6.25 is even worse, which is why
> I've posted this patch.
> 
> IOW, we tried to fix systems that were broken with 2.6.24, but it didn't work,
> because our "fix" broke systems that were OK with 2.6.24.  Solution: revert
> the "fix" and go back to the design board.  That's all we can do so late in
> the release cycle, IMO.

Well, I agree that regression from 2.6.24 is worse, but it is
_slightly_ worse... -rcs are really expected to improve...

...plus it no longer looks like macbook regression is caused by _PTS
ordering?

> > > I think we _can_ do something about the failing NVidia systems in the 2.6.26
> > > time frame, but that will require some more consideration.
> > 
> > We could simply blacklist them, no?
> 
> Yes, but for this purpose we'll have to redesign the core so that everything
> (including debugging and the error paths) works if _PTS is executed before
> suspending devices.  _That_, however, is not a 2.6.25 thing.

So we have solution that fixes 2.6.24 systems, makes system that
worked in 2.6.25-rc5 work with command line option, but gets error
handling wrong.

I guess we could use that?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
