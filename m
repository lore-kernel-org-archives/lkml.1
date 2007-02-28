Return-Path: <linux-kernel-owner+w=401wt.eu-S932091AbXB1Woz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbXB1Woz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 17:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932089AbXB1Woz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 17:44:55 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58535 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932091AbXB1Woy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 17:44:54 -0500
Date: Wed, 28 Feb 2007 23:44:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, vatsa@in.ibm.com,
       Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem with freezable workqueues
Message-ID: <20070228224443.GC19542@elf.ucw.cz>
References: <200702272251.28844.rjw@sisk.pl> <200702282125.53318.rjw@sisk.pl> <20070228203515.GA145@tv-sign.ru> <200702282339.31234.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702282339.31234.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-02-28 23:39:30, Rafael J. Wysocki wrote:
> On Wednesday, 28 February 2007 21:35, Oleg Nesterov wrote:
> > On 02/28, Rafael J. Wysocki wrote:
> > > 
> > > Okay, but I've just finished the patch that removes the freezability of
> > > workqueues (appended), so can we please do this in a separate one?
> > 
> > Please, please, no. This patch is of course correct, but it breaks _a lot_
> > of patches in -mm tree.
> > 
> > May I ask you to send just
> > 
> > > ===================================================================
> > > --- linux-2.6.21-rc2.orig/fs/xfs/linux-2.6/xfs_buf.c
> > > +++ linux-2.6.21-rc2/fs/xfs/linux-2.6/xfs_buf.c
> > > @@ -1829,11 +1829,11 @@ xfs_buf_init(void)
> > >  	if (!xfs_buf_zone)
> > >  		goto out_free_trace_buf;
> > >  
> > > -	xfslogd_workqueue = create_freezeable_workqueue("xfslogd");
> > > +	xfslogd_workqueue = create_workqueue("xfslogd");
> > >  	if (!xfslogd_workqueue)
> > >  		goto out_free_buf_zone;
> > >  
> > > -	xfsdatad_workqueue = create_freezeable_workqueue("xfsdatad");
> > > +	xfsdatad_workqueue = create_workqueue("xfsdatad");
> > >  	if (!xfsdatad_workqueue)
> > >  		goto out_destroy_xfslogd_workqueue;
> > >  
> > > 
> > 
> > this bit?
> > 
> > After that, we can do the "removes the freezability of workqueues" patch
> > against -mm tree.
> 
> Okay, if that's better.
> 
> Pavel, is that acceptable to you?

No problem, but get that acked-by: from XFS people ;-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
