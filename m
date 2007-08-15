Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbXHOLML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbXHOLML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 07:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbXHOLL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 07:11:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47315 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbXHOLL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 07:11:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] [443/2many] MAINTAINERS - HIBERNATION (aka Software Suspend, aka swsusp):
Date: Wed, 15 Aug 2007 13:21:04 +0200
User-Agent: KMail/1.9.5
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <46bffbd3.IqsNHrHU1Y9BF7Dd%joe@perches.com> <20070814232430.GA9325@redhat.com> <2ABEF126-D860-46D2-8E15-673C3ADB51A0@mac.com>
In-Reply-To: <2ABEF126-D860-46D2-8E15-673C3ADB51A0@mac.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708151321.05959.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 15 August 2007 04:51, Kyle Moffett wrote:
> On Aug 14, 2007, at 19:24:30, Dave Jones wrote:
> > On Tue, Aug 14, 2007 at 11:22:37AM -0700, Andrew Morton wrote:
> >> On Tue, 14 Aug 2007 11:15:41 -0700 (PDT) Linus Torvalds  
> >> <torvalds@linux-foundation.org> wrote:
> >>> In other words, it would be much better to just have per-file  
> >>> markers, along with some per-subdirectory stuff or similar.
> >>
> >> And a `make maintainers' target to pull it all together..
> >>
> >> (perhaps we could add a
> >>
> >> 	maintainer <keyword>
> >>
> >> record to Kconfig, then `make maintainers' goes and looks up  
> >> <keyword> somewhere and does something with it)
> >
> > Not everything that's in MAINTAINERS has a Kconfig entry though, so  
> > it really needs to live in the .c/.h files.
> 
> How about making "MAINTAINERS" operate vaguely similar  
> to .gitignore?  You would need 4 pieces
> 
> (a)  A set of "Maintainers" files sprinkled around the source tree  
> where they make sense.  Any file references would be done using  
> relative paths and patterns.  For example, there would be one in the  
> root directory which has:
> 
> [EVERYTHING ELSE]
> P: Various Linux Kernel Developers
> L: linux-kernel@vger.kernel.org
> F: *
> 
> 
> Then (using the earlier SUSPEND TO RAM example) in the kernel/power/ 
> Maintainers file, you would have:
> 
> [SUSPEND TO RAM]
> P: Pavel Machek
> M: pavel@suse.cz
> P: Rafael J. Wysocki
> M: rjw@sisk.pl
> L: linux-pm@lists.linux-foundation.org
> S: Maintained
> F: *
> 
> 
> Now that at least *one* of the maintainers files has the info for  
> Pavel and Rafael, you could just use this simpler form in any other  
> Maintainers file and still have it find their entries:
> 
> [SUSPEND TO RAM]
> F: linux/suspend.h
> F: linux/freezer.h
> F: linux/pm.h
> F: asm-*/suspend.h
> 
> 
> (b)  You would need a little tool which generates a combined  
> MAINTAINERS file when "make maintainers" is run.  It would iterate  
> over the directory tree and combine entries with the same names.   
> This also allows you to group people with their associated files even  
> if they work on the same subsystem/driver; they would be listed in  
> the respective sub-Maintainer-files, but when built it would mention  
> both of them.  The intent would not be a MAINTAINERS file which is  
> perfectly human-readable, it would be one which can be efficiently  
> grepped by a helper tool to find the necessary information.  When the  
> resulting MAINTAINERS file is built it would include the source  
> "Maintainers" file for each chunk right before said chunk, for example:
> 
> [SUSPEND TO RAM]
> 
> Origin: kernel/power/Maintainers
> P: Pavel Machek
> M: pavel@suse.cz
> P: Rafael J. Wysocki
> M: rjw@sisk.pl
> L: linux-pm@lists.linux-foundation.org
> S: Maintained
> F: kernel/power/*
> 
> Origin: include/Maintainers
> F: include/linux/suspend.h
> F: include/linux/freezer.h
> F: include/linux/pm.h
> F: include/asm-*/suspend.h
> 
> 
> 
> (c)  You would need a tool to go digging through the built  
> MAINTAINERS file based on a file, an email address, a subsystem-name- 
> regexp, etc.  It would return all matching entries, with the desired  
> fields user-selectable.
> 
> 
> (d)  You would need a little tool to poke at git similar to the shell  
> script Linus posted which dug through the recent commit history  
> looking for people doing significant *original* modifications (IE:  
> first person to sign-off) on code for which they aren't a maintainer,  
> as well as "Maintainers" who haven't recently signed off at all on  
> code for which they are responsible.  The output might be something  
> like this:
> 
> > ## Historical significance: 6 months
> > ## Uncategorized file threshold: >10 changes or >20 sign-offs
> > ## New maintainer threshold: >20 changes or >40 sign-offs
> > ## Neglectful-maintainer threshold: <5 changes and <10 sign-offs
> >
> > [SUSPEND TO RAM]
> > Nigel Cunningham should probably be a maintainer:
> >   kernel/power/* (130 changes, 132 sign-offs)
> >   include/linux/suspend.h (29 changes, 29 sign-offs)
> >
> > [RANDOM UNMAINTAINED DRIVER]
> > J. Random Hacker has neglected his maintainership:
> >   drivers/random/unmaintained.c (0 changes, 0 sign-offs)
> >
> > [UNCATEGORIZED]
> > John Linville should probably add/update a Maintainers entry:
> >   drivers/wireless/newly_added_driver.c (142 changes and 453 sign- 
> > offs)

I like this idea. :-)

Greetings,
Rafael
