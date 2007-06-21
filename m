Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbXFUKpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbXFUKpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 06:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbXFUKpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 06:45:35 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:49443 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbXFUKpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 06:45:34 -0400
To: nix@esperi.org.uk
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
In-reply-to: <87abuu2q3w.fsf@hades.wkstn.nix> (message from Nix on Wed, 20 Jun
	2007 23:55:15 +0100)
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that through other means
References: <467994BD.6000403@zytor.com> <87abuu2q3w.fsf@hades.wkstn.nix>
Message-Id: <E1I1KA8-0007Fu-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 21 Jun 2007 12:45:16 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Right now it is actually impossible to conclusively determine a
> > filesystem-relative path in the presence of bind (and possibly move)
> > mounts.  This is highly desirable to be able to do in contexts that
> > involve non-Linux (or not-the-current-instance-of-Linux) accesses to the
> > filesystem, e.g. other filesystems or bootloaders.
> 
> It's also highly desirable if you want to be able to run a backup :) one
> would desire to back up the filesystem as a whole, not some bind mount
> of one directory out of it (and backing up both is needless
> duplication).
> 
> So I applaud this and would be an immediate user, no matter what format
> is chosen, as long as we can tell what is mounted where.
> 
> (As an aside, it would be nice if mount(8) could supply (a limited
> amount of) extra (arbitrary?) textual options to the kernelq,
> specifically so that mount options which are only interpreted by
> userspace programs, like `user' and the quota options, could appear in
> /proc/mounts. That way we could finally ditch bloody /etc/mtab for good.

I'm working on this actually.  See this (and related patches) in -mm:

  http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/broken-out/unprivileged-mounts-add-user-mounts-to-the-kernel.patch

This solves the "user=" thing, but is not a generic solution for other
options.  And I'm wondering if there is really a need for that.

Which quota options are you thinking about?  Some quota options
(e.g. for ext*) seem to be already present in /proc/mounts.

There's also "loop=", but that's not really a per-mount option, but a
per-loop-device option, so it could be stored separately under /var.

Do you know any other options which are only in /etc/mtab, and need to
be stored along with each mount?

Miklos
