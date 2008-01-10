Return-Path: <linux-kernel-owner+w=401wt.eu-S1760215AbYAJP6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215AbYAJP6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758588AbYAJP6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:58:10 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:33770 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143AbYAJP6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:58:09 -0500
Date: Thu, 10 Jan 2008 10:57:46 -0500
Message-Id: <200801101557.m0AFvkoU024149@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [UNIONFS] 00/29 Unionfs and related patches pre-merge review (v2) 
In-reply-to: Your message of "Thu, 10 Jan 2008 15:08:08 GMT."
             <20080110150808.GA32080@infradead.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080110150808.GA32080@infradead.org>, Christoph Hellwig writes:
> On Thu, Jan 10, 2008 at 09:59:19AM -0500, Erez Zadok wrote:
> > 
> > Dear Linus, Al, Christoph, and Andrew,
> > 
> > As per your request, I'm posting for review the unionfs code (and related
> > code) that's in my korg tree against mainline (v2.6.24-rc7-71-gfd0b45d).
> > This is in preparation for merge in 2.6.25.
> 
> Huh?  There's still aboslutely not fix to the underlying problems of
> the whole idea.   I think we made it pretty clear that unionfs is not
> the way to go, and that we'll get the union mount patches clear once
> the per-mountpoint r/o and unprivilegued mount patches series are in
> and stable.

I'll reiterate what I've said before: unionfs is used today by many users,
it works, and is stable.  After years of working with unionfs, we've settled
on a set of features that users actually use.  This functionality can be in
mainline today.

Unioning at the VFS level, will take a long time to reach the same level of
maturity and support the same set of features.  Based on my years of
practical experience with it, unioning directories seems like a simple idea,
but in practice it's quite hard no matter the approach taken to implement
it.

Existing users of unioning aren't likely to switch to Union Mounts unless it
supports the same set of features.  How long will it realistically take to
get whiteout support in every lower file system that's used by Unionfs
users?  How will Union Mounts support persistent inode numbers at the VFS
level?  Those are just a few of the questions.

I think a better approach would be to start with Unionfs (a standalone file
system that doesn't touch the rest of the kernel).  And as Linux gradually
starts supporting more and more features that help unioning/stacking in
general, to change Unionfs to use those features (e.g., native whiteout
support).  Eventually there could be basic unioning support at the VFS
level, and concurrently a file-system which offers the extra features (e.g.,
persistency).  This can be done w/o affecting user-visible APIs.

Cheers,
Erez.
