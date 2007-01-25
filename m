Return-Path: <linux-kernel-owner+w=401wt.eu-S933172AbXAYM0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172AbXAYM0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 07:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933177AbXAYM0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 07:26:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933172AbXAYM0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 07:26:11 -0500
Subject: Re: 2.6.20-rc4 gfs2 bug
From: Steven Whitehouse <swhiteho@redhat.com>
To: Dan Merillat <dmerillat@sequiam.com>
Cc: linux-cluster@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20070125050731.GA23270@chaos.ao.net>
References: <20070125050731.GA23270@chaos.ao.net>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Thu, 25 Jan 2007 12:29:49 +0000
Message-Id: <1169728189.11001.107.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2007-01-25 at 00:07 -0500, Dan Merillat wrote:
> Running 2.6.20-rc4 _WITH_ the following patch: (Shouldn't be the issue,
> but just in case, I'm listing it here)
> 
> Date:	Fri, 29 Dec 2006 21:03:57 +0100
> From:	Ingo Molnar <mingo@elte.hu>
> Subject: [patch] remove MAX_ARG_PAGES
> Message-ID: <20061229200357.GA5940@elte.hu>
> 
> Linux fileserver 2.6.20-rc4MAX_ARGS #4 PREEMPT Fri Jan 12 03:58:25 EST 2007 x86_64 GNU/Linux
> 
> This happened when I started testing gfs2 for the first time.  I
> installed userspace from CVS, loaded the gfs2/dlm modules, mkfs.gfs2,
> then "mount -t gfs2 -v /dev/vg1/gfs2 /mnt/gfs"
> 
> This was the initial mount of the new filesystem.  I can create
> directories, but attempting a stress-test with bonnie seems to have
> deadlocked something.  (at "Start 'em", immediately.)
> 
> To clarify: the two oopses happened at first mount.  After that, I
> created files/directories, then attempted to stress it a bit with
> bonnie++.  No further oops/dmesg output.
> 
Are you in a position to test a kernel without preempt? I have a
sneeking suspicion that its related to that.

> For the GFS2 folks, latest CVS gfs_tool doesn't have lockdump, is there
> any way to examine what I'm stuck on?
> 
There isn't anything similar at the moment, however we do know about
that and there is a bugzilla entry relating to it, #221300. I don't
think that in this case it will help though since I think this is
something more fundamental in the locking code.

I'll see if I can reproduce something similar locally in the mean time,

Steve.


