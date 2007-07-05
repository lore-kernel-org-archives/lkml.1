Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbXGEAC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbXGEAC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 20:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbXGEACt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 20:02:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41191 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756046AbXGEACs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 20:02:48 -0400
Date: Thu, 5 Jul 2007 02:02:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: oliver@neukum.org, linux-pm@lists.linux-foundation.org,
       benh@kernel.crashing.org, nigel@nigel.suspend2.net, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Message-ID: <20070705000235.GD2719@elf.ucw.cz>
References: <20070703042916.GA17240@srcf.ucam.org> <200707030944.18702.oliver@neukum.org> <E1I5fug-0003ZS-00@dorka.pomaz.szeredi.hu> <200707031307.41366.oliver@neukum.org> <E1I5gSu-0003f4-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1I5gSu-0003f4-00@dorka.pomaz.szeredi.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I don't claim to know anything about how STR or hibernate works, but
> > > neither seem to have any problem with I/O on the fuse device "racing"
> > > with them.
> > 
> > The problem is not with fuse. The problem is generic in nature.
> > 
> > If you remove the freezer, user space remains active until the last CPU
> > goes into suspend. It can do syscalls. Or do you know a clean way to exempt
> > only the tasks fuse might use?
> 
> You are talking about hibernate, right?  Suspending (to ram) is
> instantaneous, in that _after_ suspend no CPU is active obviously.

No, suspend to ram is not instantaneous.

We may have 16 cpus, and we may have 250 disks that need to be spun
down. That takes time, and is really not atomic operation.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
