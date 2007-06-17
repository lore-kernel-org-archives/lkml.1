Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbXFQVgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbXFQVgF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 17:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbXFQVfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 17:35:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36366 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755382AbXFQVfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 17:35:53 -0400
Date: Sun, 17 Jun 2007 23:35:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Frank Seidel <fseidel@suse.de>, Stefan Seyfried <seife@suse.de>,
       linux-kernel@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       akpm@linux-foundation.org, nigel@nigel.suspend2.net
Subject: Re: [PATCH, 3rd try] make disable_console_suspend runtime configurable
Message-ID: <20070617213530.GE1803@elf.ucw.cz>
References: <20070613200303.GB11437@suse.de> <200706141414.22152.rjw@sisk.pl> <200706141559.54242.fseidel@suse.de> <200706150020.29189.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706150020.29189.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-06-15 00:20:28, Rafael J. Wysocki wrote:
> On Thursday, 14 June 2007 15:59, Frank Seidel wrote:
> > From: Stefan Seyfried <seife@suse.de>
> > 
> > I hate having to recompile the kernel, just to be able to debug suspend.
> > Remove CONFIG_DISABLE_CONSOLE_SUSPEND, replace it by a tunable in
> > /sys/power/disable_console_suspend.
> > 
> > 
> > Signed-off-by: Stefan Seyfried <seife@suse.de>
> > Signed-off-by: Frank Seidel <fseidel@suse.de>
> > ---
> > Third try, renamed sysfs interface to console_suspend 
> > reporting and expecting either "enabled" or "disabled"
> 
> Thanks a lot for redoing it.
> 
> I have no objections.  Pavel?

I still think that patch is bad. I should have screamed when
CONFIG_DISABLE_CONSOLE_SUSPEND went into kernel. That beast should
_not_ be configurable, it should just do the right thing.

But I realized that too late. And this only makes it works, making
that mistake part of user-kernel interface.

Sorry for not screaming when CONFIG_DISABLE_CONSOLE_SUSPEND went in,
but please lets solve this correctly....

Like every console says if it needs to  be disabled during suspend,
and if at least one active console says so, we disable. Nothing to
configure, we just do the right thing. And it should not be that much
work, either.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
