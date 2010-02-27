Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966007Ab0B0WwL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 17:52:11 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33089 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964920Ab0B0WwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 17:52:09 -0500
Date: Sat, 27 Feb 2010 22:51:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>, hch@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] notification: including fanotify
Message-ID: <20100227225145.GN30031@ZenIV.linux.org.uk>
References: <1267218869.10582.12.camel@localhost>
 <alpine.LFD.2.00.1002271323320.4513@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002271323320.4513@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 01:29:41PM -0800, Linus Torvalds wrote:

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
> 
>  (b) the compile has obviously never been tested with any modern gcc 
>      version. I get tons of warnings after the pull, like
> 
> 	In file included from fs/notify/fsnotify.h:6,
> 	                 from fs/notify/fsnotify.c:28:
> 	include/linux/fsnotify.h: In function ???fsnotify_oldname_init???:
> 	include/linux/fsnotify.h:313: warning: pointer targets in passing argument 1 of ???kstrdup??? differ in signedness
> 	include/linux/string.h:118: note: expected ???const char *??? but argument is of type ???const unsigned char *???
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

Guys, could you hold that odd until Tuesday or so?  I'm halfway through the
autofs4 review (and there are real gems there - code that had been dead
for a decade, right in the way of any analysis of lifetime rules, potential
deadlocks, etc.) and once I'm through with that, I'll push the first part
of VFS tree, give the autofs pile to Ian and post the fanotify review.
It's nearly finished, just need to get from under the pile of other stuff ;-/
