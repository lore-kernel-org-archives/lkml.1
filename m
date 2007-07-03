Return-Path: <linux-kernel-owner+w=401wt.eu-S1760589AbXGCUU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589AbXGCUU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 16:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757054AbXGCUUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 16:20:17 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:58537 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002AbXGCUUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 16:20:15 -0400
To: stern@rowland.harvard.edu
CC: oliver@neukum.org, miklos@szeredi.hu, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org, pavel@ucw.cz,
       linux-pm@lists.linux-foundation.org
In-reply-to: <Pine.LNX.4.44L0.0707031556160.7671-100000@iolanthe.rowland.org>
	(message from Alan Stern on Tue, 3 Jul 2007 16:02:37 -0400 (EDT))
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
 RAM pathway
References: <Pine.LNX.4.44L0.0707031556160.7671-100000@iolanthe.rowland.org>
Message-Id: <E1I5oq4-0004sc-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 03 Jul 2007 22:19:08 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Well, but you did remove sys_sync() from the freezer, which is
> > and must be called in the hibernate path.
> 
> That's not really true.  We _want_ to call sys_sync() in both the 
> hibernate and suspend paths (in case the batteries run down), to help 
> avoid filesystem problems if something goes wrong with the resume.  But 
> it isn't a hard requirement.
> 
> > > I'm not sure why this can't be made atomic, but assuming, that it
> > > can't, fuse should still not need to be implicated.  If it is, that's
> > > an indication about something wrong in the suspend procedure.
> > 
> > Nope, something's wrong in fuse. You must be able to deal with sync
> > until every task is frozen.
> 
> That's ridiculous.  FUSE itself runs partially as a user task.  How can
> you expect it to carry out a sync or anything else when it is frozen?
> 
> I suppose you could "deal" with it by having the kernel portion return
> an error if the userspace part is frozen.  If the hibernate/suspend 
> code bothered to check the return value, it would immediately abort 
> the suspend.

I strongly believe, that we don't want to deal with it.  If we want to
call sync(), do it while the system is fully operational.  It's a best
effort thing anyway, and you can loose data in other ways if resume
fails.

Miklos
