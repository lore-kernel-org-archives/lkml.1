Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030930Ab0B0Xtz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 18:49:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030902Ab0B0Xty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 18:49:54 -0500
Subject: Re: [GIT PULL] notification: including fanotify
From: Eric Paris <eparis@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1002271323320.4513@localhost.localdomain>
References: <1267218869.10582.12.camel@localhost>
	 <alpine.LFD.2.00.1002271323320.4513@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Feb 2010 18:49:10 -0500
Message-ID: <1267314550.10582.56.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-27 at 13:29 -0800, Linus Torvalds wrote:
> 
> On Fri, 26 Feb 2010, Eric Paris wrote:
> >
> > This tree has the part of the notification changes which have existed
> > for better than a year in linux-next.  They finish the inotify->fsnotify
> > transition and rip out the old inotify in-kernel interface.  It
> > implements fanotify as a notifier only.
> 
> I was going to pull this, but
> 
>  (a) that "notifier only" part seems to be incorrect. It has at least the 
>      Kconfig part of the "let's also allow fanotify to do security 
>      checks.

Honestly I just forgot the permissions code was in -next (and has been
since before 2.6.32 opened now that I think about it).  I remembered to
drop that stuff for my 2.6.32 pull request (which came in WAY to late
for you to care about) but forgot I needed to pull it back out this
time.  It will be dropped (even though I think it's good to go, limiting
what I'm trying to get Al/hch to look at is my only hope)

>  (b) the compile has obviously never been tested with any modern gcc 
>      version. I get tons of warnings after the pull, like
> 
> 	In file included from fs/notify/fsnotify.h:6,
> 	                 from fs/notify/fsnotify.c:28:
> 	include/linux/fsnotify.h: In function ‘fsnotify_oldname_init’:
> 	include/linux/fsnotify.h:313: warning: pointer targets in passing argument 1 of ‘kstrdup’ differ in signedness
> 	include/linux/string.h:118: note: expected ‘const char *’ but argument is of type ‘const unsigned char *’
> 	include/linux/fsnotify.h:313: warning: pointer targets in return differ in signedness
> 	In file included from fs/notify/fsnotify.h:6,
> 	                 from fs/notify/group.c:28:
> 
>     which is totally unacceptable. I'm not going to merge code that adds 
>     warnings like these. You can argue whether the warning is really 
>     something gcc should warn about or not, but it really doesn't matter. 
> 
>     Adding lots of noisy warnings is unacceptable, and I'm upset that you 
>     even pushed something to me with apparently _zero_ testing (or a total 
>     disregard for a clean compile).

No question this was my stupidity.  When I was rebasing my stuff on top
of your tree to make sure it would merge nicely before I ask for a pull
this patch had conflicts.  While resolving the conflict I added the -W
to the Makefile to make sure that I didn't screw up the point of the
patch.  I knew the warnings were going to pop out and I just ignored
them.  I guess I managed to save the Makefile by accident.  Obviously
I'm going to fix that patch to what it's been in -next (where sfr has
been handling the conflict)

/me sets the clock for one week for next pull request.

-Eric

