Return-Path: <linux-kernel-owner+w=401wt.eu-S1760696AbXGCVN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696AbXGCVN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbXGCVNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:13:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46447 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbXGCVNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:13:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 23:20:19 +0200
User-Agent: KMail/1.9.5
Cc: stern@rowland.harvard.edu, oliver@neukum.org, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org, pavel@ucw.cz,
       linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0707031556160.7671-100000@iolanthe.rowland.org> <E1I5oq4-0004sc-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I5oq4-0004sc-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707032320.20334.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3 July 2007 22:19, Miklos Szeredi wrote:
> > > Well, but you did remove sys_sync() from the freezer, which is
> > > and must be called in the hibernate path.
> > 
> > That's not really true.  We _want_ to call sys_sync() in both the 
> > hibernate and suspend paths (in case the batteries run down), to help 
> > avoid filesystem problems if something goes wrong with the resume.  But 
> > it isn't a hard requirement.
> > 
> > > > I'm not sure why this can't be made atomic, but assuming, that it
> > > > can't, fuse should still not need to be implicated.  If it is, that's
> > > > an indication about something wrong in the suspend procedure.
> > > 
> > > Nope, something's wrong in fuse. You must be able to deal with sync
> > > until every task is frozen.
> > 
> > That's ridiculous.  FUSE itself runs partially as a user task.  How can
> > you expect it to carry out a sync or anything else when it is frozen?
> > 
> > I suppose you could "deal" with it by having the kernel portion return
> > an error if the userspace part is frozen.  If the hibernate/suspend 
> > code bothered to check the return value, it would immediately abort 
> > the suspend.

Er, do_sync() doesn't return a result.

> I strongly believe, that we don't want to deal with it.  If we want to
> call sync(), do it while the system is fully operational.  It's a best
> effort thing anyway, and you can loose data in other ways if resume
> fails.

The requirement of syncing when the system (including the user space) is fully
operational is FUSE-specific.  Thus we'd rather like to sync FUSE filesystems
before freezing the user space and freeze the other filesystems after freezing
the user space.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
