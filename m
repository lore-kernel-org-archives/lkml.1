Return-Path: <linux-kernel-owner+w=401wt.eu-S1757866AbYFTOun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbYFTOun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 10:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYFTOue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 10:50:34 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45724 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbYFTOud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 10:50:33 -0400
Date: Fri, 20 Jun 2008 09:50:31 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Dave Hansen <haveblue@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [patch -mm 0/4] mqueue namespace
Message-ID: <20080620145031.GA30800@us.ibm.com>
References: <20071128163728.177495768@fr.ibm.com> <m11w2syfmk.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11w2syfmk.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Cedric Le Goater <clg@fr.ibm.com> writes:
> 
> > Hello ! 
> >
> > Here's a small patchset introducing a new namespace for POSIX
> > message queues. 
> >
> > Nothing really complex a part from the mqueue filesystem which 
> > needed some special care
> 
> This looks stalled.

It actually isn't really - Cedric had resent it a few weeks ago but had
troubles with the mail server so it never hit the lists.  I think Dave
made a few more changes from there and was getting ready to resend
again.  Dave?

> I have a brainstorm that might takes a totally
> different perspective on things.
> 
> The only reason we don't just allow multiple mounts of mqueuefs to
> solve this problem is because there is a kernel syscall on the path.
> 
> If we just hard coded a mount point into the kernel and required user
> space to always mount mqueuefs there the problem would be solved.
> 
> hard coding a mount point is unfortunately violates the unix rule
> of separating mechanism and policy.
> 
> One way to fix that is to add a hidden directory to the mnt namespace.
> Where magic in kernel filesystems can be mounted.  Only visible
> with a magic openat flag.  Then:
> 
> fd = openat(AT_FDKERN, ".", O_DIRECTORY)
> fchdir(fd);
> umount("./mqueue", MNT_DETACH);
> mount(("none", "./mqueue", "mqueue", 0, NULL);
> 
> Would unshare the mqueue namespace.
> 
> Implemented for plan9 this would solve a problem of how do you get
> access to all of it's special filesystems.  As only bind mounts
> and remote filesystem mounts are available.  For linux thinking about
> it might shake the conversation up a bit.

It is unfortunate that two actions are needed to properly complete the
unshare, and we had definately talked about just using the mount before.
I forget why we decided it wasn't practical, so maybe what you describe
solves it...

But at least the current patch reuses CLONE_NEWIPC for posix ipc, which
also seems to make sense.

-serge
