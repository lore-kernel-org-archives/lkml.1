Return-Path: <linux-kernel-owner+w=401wt.eu-S1753657AbYEDHVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbYEDHVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 03:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750698AbYEDHVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 03:21:09 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:58173 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbYEDHVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 03:21:07 -0400
Date: Sun, 4 May 2008 09:21:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] fix rebuild of wakeup.bin
Message-ID: <20080504072114.GB15315@uranus.ravnborg.org>
References: <20080501010516.DD2FE26FA05@magilla.localdomain> <20080501093107.GA2392@uranus.ravnborg.org> <200805011248.53295.rjw@sisk.pl> <20080503180612.GD5292@elte.hu> <20080503181503.GB17990@uranus.ravnborg.org> <20080503194149.GC25097@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503194149.GC25097@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 09:41:49PM +0200, Ingo Molnar wrote:
> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Sat, May 03, 2008 at 08:06:12PM +0200, Ingo Molnar wrote:
> > > 
> > > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > 
> > > > > Add wakeup.lds to list af targets to avoid rebuilding wakeup.bin - 
> > > > > from Roland McGrath.
> > > > 
> > > > Thanks for fixing this!
> > > > 
> > > > Ingo, please merge.
> > > 
> > > applied - thanks all!
> > 
> > Just a note - I do not think this solves the problem Daniel has 
> > reported with respect to first build of -next. I am awaiting more data 
> > before I can analyse it further.
> 
> yeah, i suspected that - that appears to be a race of some sort, i.e. a 
> missing dependency coupled with parallelizable rules, not an over-eager 
> dependency as fixed by this patch, right?

In the end it should be fixed by this patch.
It turned out to be a user rights issue where I assume
wakeup-lds were owned by root because we created it
despite have a fully build kernel.

This also explains why we did not see more reports on the subject.

So please push this fix towards linus soonish.

Thanks,
	Sam
