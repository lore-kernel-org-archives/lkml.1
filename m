Return-Path: <linux-kernel-owner+w=401wt.eu-S933214AbXCAJ2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214AbXCAJ2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 04:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933217AbXCAJ2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 04:28:04 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36225 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933214AbXCAJ2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 04:28:01 -0500
Date: Thu, 1 Mar 2007 01:25:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@tv-sign.ru>,
       vatsa@in.ibm.com, Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>, David Chinner <dgc@sgi.com>,
       Nigel Cunningham <ncunningham@linuxmail.org>
Subject: Re: [PATCH] Make XFS workqueues nonfreezable
Message-Id: <20070301012554.8426b5cb.akpm@linux-foundation.org>
In-Reply-To: <20070301091521.GA20171@elf.ucw.cz>
References: <200702272251.28844.rjw@sisk.pl>
	<200702282339.31234.rjw@sisk.pl>
	<20070228224443.GC19542@elf.ucw.cz>
	<200703010054.33536.rjw@sisk.pl>
	<20070301000351.ad3f641c.akpm@linux-foundation.org>
	<20070301091521.GA20171@elf.ucw.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2007 10:15:21 +0100 Pavel Machek <pavel@ucw.cz> wrote:

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
> > 
> > Won't this break suspend+XFS?
> > 
> > If so, and given that nobody seems to be reporting this deadlock, perhaps
> > we'd be better off leaving things as-is for the while?
> 
> Worst case is not breaking suspend+XFS, worst case is XFS writing to
> disk after freeze(), leading to subtle fs corruption.
> 
> (But noone could reproduce corruption before, and I was told XFS will
> not do those writes these days).

hm, OK.   To avoid making a decision I sent the patch to David ;)
