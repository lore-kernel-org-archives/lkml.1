Return-Path: <linux-kernel-owner+w=401wt.eu-S1760643AbXGEMIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760643AbXGEMIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 08:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227AbXGEMIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 08:08:40 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:38510 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbXGEMIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 08:08:39 -0400
To: pavel@ucw.cz
CC: miklos@szeredi.hu, oliver@neukum.org, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
In-reply-to: <20070705115400.GF3984@ucw.cz> (message from Pavel Machek on Thu,
	5 Jul 2007 11:54:00 +0000)
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <Pine.LNX.4.44L0.0707041045150.25704-100000@netrider.rowland.org> <18060.14856.824473.325660@cargo.ozlabs.ibm.com> <200707050858.03638.oliver@neukum.org> <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu> <20070705091801.GB3084@elf.ucw.cz> <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu> <20070705115400.GF3984@ucw.cz>
Message-Id: <E1I6Q73-0000Xi-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Jul 2007 14:07:09 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Actually fuse allows SIGKILL, because it's always fatal, and the
> > syscall may not be restarted.
> 
> I think you want to stick try_to_freeze() at the same places where you
> do SIGKILL handling. That should solve the 'syslogd is unfreezeable'
> problem.

I could, but it would not solve the general problem.  Namely, that the
presence of fuse imposes a certain ordering in which userspace tasks
have to be frozen.  And it is not possible to know this ordering.

And even if the ordering were solved, the freezer would still not work
if the filesystem is not responding due to external events, such as a
lost network (this affects NFS, CIFS, whatever just the same as fuse).

> Plus, it would be nice to find out where suspend/hibernation is
> triggering fuse activity. We can then decide where to fix it -- in
> fuse or in suspend parts. You said sys_sync is not implemented... so
> where is the problem?

I cannot say without having a sysrq-t of the situation.

> > > That's very special, and maybe even a FUSE bug. And that is also
> > > what makes FUSE special w.r.t. s2ram.
> > 
> > What makes fuse special is that some file operations are synchronous
> > and non-restartable.  That's just how the UNIX filesystem API works
> > and is hardly a bug in fuse.
> 
> Well, unix is not plan9, and maybe userland filesystems are impossible
> in unix. But that is hardly a bug in unix :-).

I'd rather say, reliable suspend to ram is impossible in the presense
of userspace filesystems, iff people are too lazy to fix the suspend
framework and the drivers to work without the freezer.

This has nothing to do with unix, if plan9 would need to support STR
or hibernate, it would face exactly the same problems.

Miklos
