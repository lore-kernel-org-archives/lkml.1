Return-Path: <linux-kernel-owner+w=401wt.eu-S1751278AbXB1Wgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbXB1Wgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 17:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbXB1Wgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 17:36:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44817 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbXB1Wgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 17:36:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>
Subject: Re: Problem with freezable workqueues
Date: Wed, 28 Feb 2007 23:39:30 +0100
User-Agent: KMail/1.9.5
Cc: vatsa@in.ibm.com, Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <200702272251.28844.rjw@sisk.pl> <200702282125.53318.rjw@sisk.pl> <20070228203515.GA145@tv-sign.ru>
In-Reply-To: <20070228203515.GA145@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702282339.31234.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 28 February 2007 21:35, Oleg Nesterov wrote:
> On 02/28, Rafael J. Wysocki wrote:
> > 
> > Okay, but I've just finished the patch that removes the freezability of
> > workqueues (appended), so can we please do this in a separate one?
> 
> Please, please, no. This patch is of course correct, but it breaks _a lot_
> of patches in -mm tree.
> 
> May I ask you to send just
> 
> > ===================================================================
> > --- linux-2.6.21-rc2.orig/fs/xfs/linux-2.6/xfs_buf.c
> > +++ linux-2.6.21-rc2/fs/xfs/linux-2.6/xfs_buf.c
> > @@ -1829,11 +1829,11 @@ xfs_buf_init(void)
> >  	if (!xfs_buf_zone)
> >  		goto out_free_trace_buf;
> >  
> > -	xfslogd_workqueue = create_freezeable_workqueue("xfslogd");
> > +	xfslogd_workqueue = create_workqueue("xfslogd");
> >  	if (!xfslogd_workqueue)
> >  		goto out_free_buf_zone;
> >  
> > -	xfsdatad_workqueue = create_freezeable_workqueue("xfsdatad");
> > +	xfsdatad_workqueue = create_workqueue("xfsdatad");
> >  	if (!xfsdatad_workqueue)
> >  		goto out_destroy_xfslogd_workqueue;
> >  
> > 
> 
> this bit?
> 
> After that, we can do the "removes the freezability of workqueues" patch
> against -mm tree.

Okay, if that's better.

Pavel, is that acceptable to you?

Rafael
