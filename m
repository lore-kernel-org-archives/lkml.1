Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbYFTOxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbYFTOxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 10:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755908AbYFTOx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 10:53:27 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33821 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbYFTOx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 10:53:27 -0400
Date: Fri, 20 Jun 2008 09:53:25 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Emelianov <xemul@openvz.org>, Serge Hallyn <serue@us.ibm.com>
Subject: Re: [patch -mm 0/4] mqueue namespace
Message-ID: <20080620145325.GB30800@us.ibm.com>
References: <20071128163728.177495768@fr.ibm.com> <m11w2syfmk.fsf@frodo.ebiederm.org> <m1ve04vkov.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ve04vkov.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> ebiederm@xmission.com (Eric W. Biederman) writes:
> 
> > One way to fix that is to add a hidden directory to the mnt namespace.
> > Where magic in kernel filesystems can be mounted.  Only visible
> > with a magic openat flag.  Then:
> >
> > fd = openat(AT_FDKERN, ".", O_DIRECTORY)
> > fchdir(fd);
> > umount("./mqueue", MNT_DETACH);
> > mount(("none", "./mqueue", "mqueue", 0, NULL);
> >
> > Would unshare the mqueue namespace.
> >
> > Implemented for plan9 this would solve a problem of how do you get
> > access to all of it's special filesystems.  As only bind mounts
> > and remote filesystem mounts are available.  For linux thinking about
> > it might shake the conversation up a bit.
> 
> Thinking about this some more.  What is especially attractive if we do
> all namespaces this way is that it solves two lurking problems.
> 1) How do you keep a namespace around without a process in it.
> 2) How do you enter a container.
> 
> If we could land the namespaces in the filesystem we could easily
> persist them past the point where a process is present in one if we so
> choose.
> 
> Entering a container would be a matter of replacing your current
> namespaces mounts with namespace mounts take from the filesystem.
> 
> I expect performance would degrade in practice, but it is tempting
> to implement it and run a benchmark and see if we can measure anything.

The device ns could be a mount of an fs with the devices created in it,
while mknod becomes a symlink from that fs.  And once a network
namespace is a filesystem, we can aim for the plan9 NAT solution of
mounting a remote /net onto ours.  Neat.

But bye-bye posix?

-serge
