Return-Path: <linux-kernel-owner+w=401wt.eu-S1759728AbXGELu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728AbXGELu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 07:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755694AbXGELuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 07:50:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53004 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042AbXGELuu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 07:50:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 13:58:25 +0200
User-Agent: KMail/1.9.5
Cc: pavel@ucw.cz, oliver@neukum.org, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <20070705091801.GB3084@elf.ucw.cz> <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707051358.26963.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 July 2007 11:31, Miklos Szeredi wrote:
> > > > > > I have discussed the benefits elsewhere.  As for the deadlocks -- do 
> > > > > > you still observe them if you use the version of the freezer which 
> > > > > > doesn't freeze kernel threads?
> > > > > 
> > > > > In general the only way to guarantee there are no deadlocks is to
> > > > > construct the graph of dependencies between tasks.  Those dependencies
> > > > > are not in practice observable from outside the tasks, so it is
> > > > > virtually impossible to construct the graph.
> > > > 
> > > > In which way can user space tasks depend on each other in a way that
> > > > allows a them members of that cycle to be in uninterruptible sleep?
> > > 
> > >  - process A calls rename() on a fuse fs
> > >  - process B, the fuse server, starts to process the rename request
> > >  - process B is frozen before it can reply
> > > 
> > > Now process A is unfreezable.  We cannot make rename() restartable,
> > > hence it cannot be interruptible.
> > 
> > Yes, we are claiming fuse is very special in this regard, and perhaps
> > even broken.
> > 
> > Let's see. If I SIGSTOP the fuse server, I can get unrelated tasks
> > unkillable (even for SIGKILL!) forever.
> 
> Actually fuse allows SIGKILL, because it's always fatal, and the
> syscall may not be restarted.
> 
> > That's very special, and maybe even a FUSE bug. And that is also
> > what makes FUSE special w.r.t. s2ram.
> 
> What makes fuse special is that some file operations are synchronous
> and non-restartable.  That's just how the UNIX filesystem API works
> and is hardly a bug in fuse.
> 
> > So no, you can't claim "FUSE is just IPC". It is very special IPC.
> 
> I did say it's special.  Sure, it has some "interesting" properties,
> and with a bit of malice you can do very ugly things with it.  If you
> are interested, read Documentation/filesystems/fuse.txt, especially
> the "Tricky deadlock" section ;)

Very well.

Don't you think, however, that it can be modified a little to play well,
for example, with the freezer?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
