Return-Path: <linux-kernel-owner+w=401wt.eu-S1761424AbXGCUCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761424AbXGCUCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 16:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757002AbXGCUCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 16:02:39 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53133 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756889AbXGCUCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 16:02:38 -0400
Date: Tue, 3 Jul 2007 16:02:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Miklos Szeredi <miklos@szeredi.hu>, <mjg59@srcf.ucam.org>,
       <linux-kernel@vger.kernel.org>, <pavel@ucw.cz>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
 RAM pathway
In-Reply-To: <200707032132.20731.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0707031556160.7671-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007, Oliver Neukum wrote:

> Well, but you did remove sys_sync() from the freezer, which is
> and must be called in the hibernate path.

That's not really true.  We _want_ to call sys_sync() in both the 
hibernate and suspend paths (in case the batteries run down), to help 
avoid filesystem problems if something goes wrong with the resume.  But 
it isn't a hard requirement.

> > I'm not sure why this can't be made atomic, but assuming, that it
> > can't, fuse should still not need to be implicated.  If it is, that's
> > an indication about something wrong in the suspend procedure.
> 
> Nope, something's wrong in fuse. You must be able to deal with sync
> until every task is frozen.

That's ridiculous.  FUSE itself runs partially as a user task.  How can
you expect it to carry out a sync or anything else when it is frozen?

I suppose you could "deal" with it by having the kernel portion return
an error if the userspace part is frozen.  If the hibernate/suspend 
code bothered to check the return value, it would immediately abort 
the suspend.

Alan Stern

