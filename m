Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbXHBPsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbXHBPsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 11:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbXHBPsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 11:48:16 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4336 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754052AbXHBPsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 11:48:15 -0400
Date: Wed, 1 Aug 2007 09:19:50 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, rjw@sisk.pl, miltonm@bga.com,
       stern@rowland.harvard.edu, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, david@lang.hm,
       linux-pm@lists.linux-foundation.org, jbms@cmu.edu
Subject: Re: [linux-pm] Re: Hibernation considerations
Message-ID: <20070801091949.GA4808@ucw.cz>
References: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm> <200707202302.07116.rjw@sisk.pl> <E1ICDNw-0008HC-00@dorka.pomaz.szeredi.hu> <200707212243.35602.nigel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707212243.35602.nigel@nigel.suspend2.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > The problem with FUSE is related to the fact that the freezer can't
> > > freeze uninterruptible tasks and we said that perhaps we might avoid
> > > it if FUSE was made freezing-aware.  Still, no one has gone in this
> > > direction and I don't know of any plans to do that.
> > 
> > I thought we have fully explored this direction.  Lots of emails, and
> > an IRC session with Pavel.  Conclusion:
> 
> What am I missing in the following suggested solution?
> 
> 1) In the freezer code, we implement a new TIF_LATEFREEZE process flag, which, 
> when set, causes a  userspace process to be frozen with kernel threads 
> instead of with userspace ones. When freezing, we freezing !TIF_LATEFREEZE, 
> sync and then freeze TIF_LATEFREEZE and freezable kernel threads.
> 
> 2) In the fuse code, the PID of the process that will do the work gets passed 

The list of neccessary PIDs is not known to the kernel. FUSE servers
may depend on another parts of userland.



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
