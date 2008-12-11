Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbYLKCex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbYLKCex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 21:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbYLKCen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 21:34:43 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43339 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbYLKCen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 21:34:43 -0500
Date: Thu, 11 Dec 2008 02:34:39 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] make INIT_FS use the __RW_LOCK_UNLOCKED initialization
Message-ID: <20081211023439.GJ28946@ZenIV.linux.org.uk>
References: <alpine.DEB.1.10.0812101832200.21545@gandalf.stny.rr.com> <20081210234307.GI28946@ZenIV.linux.org.uk> <8bd0f97a0812101707p7df7745dk9840b05c0b26184b@mail.gmail.com> <alpine.DEB.1.10.0812102010100.29200@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812102010100.29200@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 08:11:02PM -0500, Steven Rostedt wrote:
> 
> On Wed, 10 Dec 2008, Mike Frysinger wrote:
> 
> > On Wed, Dec 10, 2008 at 18:43, Al Viro wrote:
> > > On Wed, Dec 10, 2008 at 06:37:28PM -0500, Steven Rostedt wrote:
> > >>
> > >> The following patch is in:
> > >>
> > >>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > >>
> > >>     branch: cleanups
> > >
> > > Would be better to take init_fs to something in fs/ or kernel/ and kill
> > > the duplicates, along with INIT_FS macro itself...
> > 
> > how about the next level: unify init_task.c.  a quick check shows that
> > like 90% of the stuff in there is the same for everyone ...
> > -mike
> 
> I could probably do it for x86 and PPC, but beyond that, each arch 
> maintainer will have to do it separately. That's a change that would need 
> testing.
> 
> These changes are trivial (something I need to get RT working).

Guys, let's not take it to init/main.c, please.  That file is basically
a trashcan and I'd rather take that stuff to more or less relevant places
in kernel/* and fs/*.  FWIW, I've done that with init_files (fs/file.c)
some time ago.  For init_fs...  Hell knows.  Might make sense to take
that to separate file, actually (kernel/exit.c and kernel/fork.c bits
related to fs_struct).

BTW, why does sparc64 export put_fs_struct?  And is there any good reason
for doing copy_fs_struct() in nfsd instead of just teaching kthread_create()
how to create threads without sharing fs_struct (or descriptors, while we
are at it)?
