Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbYAPVXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbYAPVXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 16:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbYAPVXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 16:23:44 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59476 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbYAPVXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 16:23:43 -0500
Date: Wed, 16 Jan 2008 15:21:40 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [UNIONFS] 00/29 Unionfs and related patches pre-merge review (v2)
Message-ID: <20080116212139.GA17255@localhost.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20080110150808.GA32080@infradead.org> <200801101557.m0AFvkoU024149@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801101557.m0AFvkoU024149@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 10:57:46AM -0500, Erez Zadok wrote:
> In message <20080110150808.GA32080@infradead.org>, Christoph Hellwig
> writes:
> > On Thu, Jan 10, 2008 at 09:59:19AM -0500, Erez Zadok wrote:
> > > 
> > > Dear Linus, Al, Christoph, and Andrew,
> > > 
> > > As per your request, I'm posting for review the unionfs code
> > > (and related code) that's in my korg tree against mainline
> > > (v2.6.24-rc7-71-gfd0b45d).  This is in preparation for merge in
> > > 2.6.25.
> > 
> > Huh?  There's still aboslutely not fix to the underlying problems
> > of the whole idea.  I think we made it pretty clear that unionfs
> > is not the way to go, and that we'll get the union mount patches
> > clear once the per-mountpoint r/o and unprivilegued mount patches
> > series are in and stable.
> 
> I'll reiterate what I've said before: unionfs is used today by many
> users, it works, and is stable.  After years of working with
> unionfs, we've settled on a set of features that users actually use.
> This functionality can be in mainline today.

There are well-known distributions out there that are tacking Unionfs
onto their kernels; for instance, it is popular in the bootable
read-only media scene. When enough vendors are adding the code on
their own, it is generally a good indicator that it should just be
upstream, especially if it can be built as a non-invasive experimental
module with a caveat about its shortcomings in the config menu and
documentation.

> Unioning at the VFS level, will take a long time to reach the same level of
> maturity and support the same set of features.  Based on my years of
> practical experience with it, unioning directories seems like a simple idea,
> but in practice it's quite hard no matter the approach taken to implement
> it.
> 
> Existing users of unioning aren't likely to switch to Union Mounts
> unless it supports the same set of features.  How long will it
> realistically take to get whiteout support in every lower file
> system that's used by Unionfs users?

Well, depending on the amount of code that actually needs to get
pushed below the VFS layer itself, I think you would be surprised how
quickly something like this can be done. But I do agree that a
non-invasive stacked module is a reasonable intermediate step in the
meantime, so long as the users understand the potential shortcomings
and are able to substantially benefit from its present inclusion in
mainline.

> How will Union Mounts support persistent inode numbers at the VFS
> level?  Those are just a few of the questions.
> 
> I think a better approach would be to start with Unionfs (a
> standalone file system that doesn't touch the rest of the kernel).
> And as Linux gradually starts supporting more and more features that
> help unioning/stacking in general, to change Unionfs to use those
> features (e.g., native whiteout support).  Eventually there could be
> basic unioning support at the VFS level, and concurrently a
> file-system which offers the extra features (e.g., persistency).
> This can be done w/o affecting user-visible APIs.

Would the inclusion of Unionfs in mainline really slow down or damage
the union mount effort? If not, then I think the pragmatic approach
would be to make it available in mainline for all of the users who are
already successfully running it today. We can then focus future
efforts on the VFS-level modifications that address the remaining
issues, limiting Unionfs in the future to only those problems that are
best solved in a stacked filesystem layer.

Mike
