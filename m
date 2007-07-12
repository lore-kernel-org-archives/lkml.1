Return-Path: <linux-kernel-owner+w=401wt.eu-S1759147AbXGLXQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147AbXGLXQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 19:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762691AbXGLXQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 19:16:25 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:59653 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759577AbXGLXQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 19:16:24 -0400
To: miklos@szeredi.hu
CC: pavel@ucw.cz, miklos@szeredi.hu, oliver@neukum.org, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
In-reply-to: <E1I96eW-00059M-00@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Thu, 12 Jul 2007 23:56:48 +0200)
Subject: Re: malicious filesystems (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
References: <200707050858.03638.oliver@neukum.org> <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu> <20070705091801.GB3084@elf.ucw.cz> <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu> <20070705115400.GF3984@ucw.cz> <E1I6Q73-0000Xi-00@dorka.pomaz.szeredi.hu> <20070707121729.GC3111@elf.ucw.cz> <E1I7H6v-0006pf-00@dorka.pomaz.szeredi.hu> <20070707233315.GB3820@elf.ucw.cz> <E1I7vx0-0002Fn-00@dorka.pomaz.szeredi.hu> <20070712153112.GB5139@ucw.cz> <E1I96eW-00059M-00@dorka.pomaz.szeredi.hu>
Message-Id: <E1I97qP-0005JF-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 13 Jul 2007 01:13:09 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Ok, I'll just blame fuse here. 'You have to write to /sys
> > files for SIGKILL to work' is not funny.
> 
> SIGKILL won't work on a stopped task.  Neither on a traced task.
> Neither on a zombie (how many newbies are thoroughly confused about
> that ;)
> 
> And it won't work on a task that is hanging on an NFS mount, when the
> network broke.
> 
> Oh, and it won't work on a deadlocked fuse filesystem.  How many of
> these have you met?  How many of the others?

And maybe someday, when I'm feeling _really_ bored, I may start
hacking the VFS to make it possible for tasks to be killed while
waiting on a mutex.  Can a task doing a page fault be interrupted?  I
don't see why not.

But, it's _not_ going to happen now, to fix the problems with suspend.
Hacking fuse (however broken it may be) or the VFS is not the right
way to fix those problems.  It may be easier than fixing the drivers,
though I doubt it.  But even if it's the easier way it's not the
_right_ way.

We want the various subsystems in the kernel to be less dependent on
each other not more.  And the freezer is just adding unnecessary
dependence on totally unrelated code.  And that does not only impact
fuse, but a lot of other code in the kernel, in the form of
try_to_freeze() calls all over the place.

Is that so hard to understand?

You can bash fuse all you want, I really don't mind.  But please stop
trying to prove, that this situation is best handled in fuse.  It just
won't happen, not because I'm lazy to do the work but because I don't
have the guts to do something so obviously wrong.

Miklos
