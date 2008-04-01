Return-Path: <linux-kernel-owner+w=401wt.eu-S1759665AbYDAT4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759665AbYDAT4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 15:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754626AbYDAT4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 15:56:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48041 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbYDAT4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 15:56:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] ACPI PM: Restore the 2.6.24 suspend ordering
Date: Tue, 1 Apr 2008 21:55:51 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
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
References: <200803300319.08398.rjw@sisk.pl> <200803301515.33922.rjw@sisk.pl> <20080401084523.GA25278@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20080401084523.GA25278@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804012155.52547.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 1 of April 2008, Pavel Machek wrote:
> Hi!

Hi,

> > > > > > For the reasons outlined above, the change of the suspend ordering
> > > > > > should be reverted, which is done by the patch below.
> > > > > 
> > > > > But this will break those few nvidia-based systems, no?
> > > > > 
> > > > > this may have been a good idea in -rc1 days, but we are in -rc7
> > > > > now... and the patch is slightly big.
> > > > 
> > > > It's quite obvious, though.
> > > 
> > > Yes, but breaking systems between -rc7 and final is _very_ unnice.
> > 
> > Breaking systems between 2.6.24 and 2.6.25 is even worse, which is why
> > I've posted this patch.
> > 
> > IOW, we tried to fix systems that were broken with 2.6.24, but it didn't work,
> > because our "fix" broke systems that were OK with 2.6.24.  Solution: revert
> > the "fix" and go back to the design board.  That's all we can do so late in
> > the release cycle, IMO.
> 
> Well, I agree that regression from 2.6.24 is worse, but it is
> _slightly_ worse... -rcs are really expected to improve...
> 
> ...plus it no longer looks like macbook regression is caused by _PTS
> ordering?
> 
> > > > I think we _can_ do something about the failing NVidia systems in the 2.6.26
> > > > time frame, but that will require some more consideration.
> > > 
> > > We could simply blacklist them, no?
> > 
> > Yes, but for this purpose we'll have to redesign the core so that everything
> > (including debugging and the error paths) works if _PTS is executed before
> > suspending devices.  _That_, however, is not a 2.6.25 thing.
> 
> So we have solution that fixes 2.6.24 systems, makes system that
> worked in 2.6.25-rc5 work with command line option, but gets error
> handling wrong.
> 
> I guess we could use that?

IMO we should not use that, because it's broken.  That's why I posted the
patch.

Thanks,
Rafael
