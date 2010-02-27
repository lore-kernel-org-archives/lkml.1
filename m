Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935712Ab0B0VaQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 16:30:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934887Ab0B0VaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 16:30:11 -0500
Date: Sat, 27 Feb 2010 13:29:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Eric Paris <eparis@redhat.com>
cc: viro@zeniv.linux.org.uk, hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] notification: including fanotify
In-Reply-To: <1267218869.10582.12.camel@localhost>
Message-ID: <alpine.LFD.2.00.1002271323320.4513@localhost.localdomain>
References: <1267218869.10582.12.camel@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Feb 2010, Eric Paris wrote:
>
> This tree has the part of the notification changes which have existed
> for better than a year in linux-next.  They finish the inotify->fsnotify
> transition and rip out the old inotify in-kernel interface.  It
> implements fanotify as a notifier only.

I was going to pull this, but

 (a) that "notifier only" part seems to be incorrect. It has at least the 
     Kconfig part of the "let's also allow fanotify to do security 
     checks.

 (b) the compile has obviously never been tested with any modern gcc 
     version. I get tons of warnings after the pull, like

	In file included from fs/notify/fsnotify.h:6,
	                 from fs/notify/fsnotify.c:28:
	include/linux/fsnotify.h: In function ‘fsnotify_oldname_init’:
	include/linux/fsnotify.h:313: warning: pointer targets in passing argument 1 of ‘kstrdup’ differ in signedness
	include/linux/string.h:118: note: expected ‘const char *’ but argument is of type ‘const unsigned char *’
	include/linux/fsnotify.h:313: warning: pointer targets in return differ in signedness
	In file included from fs/notify/fsnotify.h:6,
	                 from fs/notify/group.c:28:

    which is totally unacceptable. I'm not going to merge code that adds 
    warnings like these. You can argue whether the warning is really 
    something gcc should warn about or not, but it really doesn't matter. 

    Adding lots of noisy warnings is unacceptable, and I'm upset that you 
    even pushed something to me with apparently _zero_ testing (or a total 
    disregard for a clean compile).

Grr. 

		Linus
