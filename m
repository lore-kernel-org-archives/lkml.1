Return-Path: <linux-kernel-owner+w=401wt.eu-S1757051AbYDLJul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051AbYDLJul (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 05:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758479AbYDLJuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 05:50:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:46031 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857AbYDLJub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 05:50:31 -0400
Date: Sat, 12 Apr 2008 11:51:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Kosina <jkosina@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andi Kleen <andi@firstfloor.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
Message-ID: <20080412095112.GB1597@elf.ucw.cz>
References: <Pine.LNX.4.64.0804080008420.3896@jikos.suse.cz> <20080407222352.GG16647@one.firstfloor.org> <200804080029.31102.rjw@sisk.pl> <Pine.LNX.4.64.0804080030500.3896@jikos.suse.cz> <20080410094554.GA10321@ucw.cz> <Pine.LNX.4.64.0804110122470.3896@jikos.suse.cz> <20080411104902.GA8734@elf.ucw.cz> <20080411105108.GA1844@elte.hu> <20080411105445.GB18770@elf.ucw.cz> <20080411110939.GB9205@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411110939.GB9205@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-04-11 13:09:39, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > (I just want to fix the underlying problem in suspend, too. I guess
> > I'll just do something like
> 
> >  				if (drv->suspend) {
> > +					BUG_ON(!in_interrupt());
> >  					ret = drv->suspend(sysdev, state);
> 
> >  			pr_debug(" %s\n", kobject_name(&sysdev->kobj));
> >  
> > +			BUG_ON(!in_interrupt());
> >  			__sysdev_resume(sysdev);
> 
> small note: please always use WARN_ON_ONCE() in such cases. That way 
> people's boxes dont blow up and the problem will be debuggable if the 
> box survives despite the error condition. (and thus it can be relayed to 
> kerneloops.org - all major distros have the package included already and 
> Fedora enables the client by default)

Agreed, BUG_ON() was bad idea and I got the condition wrong.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
