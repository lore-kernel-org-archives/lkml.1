Return-Path: <linux-kernel-owner+w=401wt.eu-S1761331AbXGENU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761331AbXGENU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 09:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758663AbXGENUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 09:20:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53483 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478AbXGENUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 09:20:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 15:28:17 +0200
User-Agent: KMail/1.9.5
Cc: pavel@ucw.cz, oliver@neukum.org, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <20070705115400.GF3984@ucw.cz> <E1I6Q73-0000Xi-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I6Q73-0000Xi-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707051528.18766.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 July 2007 14:07, Miklos Szeredi wrote:
> > > Actually fuse allows SIGKILL, because it's always fatal, and the
> > > syscall may not be restarted.
> > 
> > I think you want to stick try_to_freeze() at the same places where you
> > do SIGKILL handling. That should solve the 'syslogd is unfreezeable'
> > problem.
> 
> I could, but it would not solve the general problem.  Namely, that the
> presence of fuse imposes a certain ordering in which userspace tasks
> have to be frozen.  And it is not possible to know this ordering.
> 
> And even if the ordering were solved, the freezer would still not work
> if the filesystem is not responding due to external events, such as a
> lost network (this affects NFS, CIFS, whatever just the same as fuse).
> 
> > Plus, it would be nice to find out where suspend/hibernation is
> > triggering fuse activity. We can then decide where to fix it -- in
> > fuse or in suspend parts. You said sys_sync is not implemented... so
> > where is the problem?
> 
> I cannot say without having a sysrq-t of the situation.
> 
> > > > That's very special, and maybe even a FUSE bug. And that is also
> > > > what makes FUSE special w.r.t. s2ram.
> > > 
> > > What makes fuse special is that some file operations are synchronous
> > > and non-restartable.  That's just how the UNIX filesystem API works
> > > and is hardly a bug in fuse.
> > 
> > Well, unix is not plan9, and maybe userland filesystems are impossible
> > in unix. But that is hardly a bug in unix :-).
> 
> I'd rather say, reliable suspend to ram is impossible in the presense
> of userspace filesystems, iff people are too lazy to fix the suspend
> framework and the drivers to work without the freezer.

Well, I don't think it has anything to do with laziness or things like that.
Rather, people have limited time and this requires some knowledge about
drivers you're modifying, so not many people really can do that.

Also, you've already assumed that there's no other solution, but I'm not
convinced about that yet.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
