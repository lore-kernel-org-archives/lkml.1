Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbYHLPnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbYHLPnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 11:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbYHLPn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 11:43:29 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:38527 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191AbYHLPn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 11:43:28 -0400
X-Sasl-enc: o0QG6SYP/iB9jLuPZ8T1s5f/Zahquvhtzxa9kJFRa3ED 1218555806
Subject: Re: [Unionfs] Re: [PATCH -mm] unionfs: build fixes
From: Ian Kent <raven@themaw.net>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hugh@veritas.com>,
       unionfs@filesystems.org, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
In-Reply-To: <200807300102.m6U123KW015449@agora.fsl.cs.sunysb.edu>
References: <200807300102.m6U123KW015449@agora.fsl.cs.sunysb.edu>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 23:38:44 +0800
Message-Id: <1218555525.3248.18.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-07-29 at 21:02 -0400, Erez Zadok wrote:
> In message <20080729172216.84e958f7.akpm@linux-foundation.org>, Andrew Morton writes:
> > On Tue, 29 Jul 2008 19:12:47 +0100 (BST)
> > Hugh Dickins <hugh@veritas.com> wrote:
> > 
> > > Get unionfs building and working in mmotm with the 2.6.27-rc1 VFS changes:
> > > permission() has been replaced by inode_permission() without nameidata arg;
> > > unionfs_permission() without nameidata arg; vfs_symlink() without mode arg;
> > > LOOKUP_ACCESS no longer defined; and kmem_cache_create() no longer passes
> > > kmem_cachep to the init_once() constructor.
> > > 
> > > Note: while okay for inclusion in -mm for now, unionfs_permission() mods
> > > will need review and perhaps correction by Erez: without a nameidata arg,
> > > some locking vanishes from unionfs_permission(), and a MNT_NOEXEC check on
> > > its lower_inode; I have not studied the VFS changes enough to tell whether
> > > that amounts to a real issue for unionfs, or just removal of dead code.
> > 
> > thanks.
> > 
> > > This should follow git-unionfs.patch
> > > I notice my unionfs-fix-memory-leak.patch
> > > and fsstack-fsstack_copy_inode_size-locking.patch
> > > are currently commented out, yet I don't recall the
> > > mm-commits dispatch rider bringing me a telegram to explain why?
> > 
> > git-unionfs got commented out because of some upstream git (or build)
> > catastrophe.  So its fixes got comemnted out too.  Then git-unionfs was
> > restored but I forgot to manually restore the followon fixes.  It
> > happens.
> 
> Shortly I'm going to post fixes which include Hugh's stuff and more.  Sorry
> for the delay.
> 
> > I must say that I'm not really sure why we're struggling along with
> > unionfs.  Last I heard there were fundamental, unresolveable design
> > disagreements with the VFS guys.  Those issues should be where 100% of
> > the effort is being devoted, but instead we seem to be cruising along
> > in a different direction?
> 
> Some of my upcoming patches begin to address this (took longer than
> expected):
> 
> - extracting all whiteout related code into callable methods in unionfs, so
>   that I can "drop in" the new whiteout code that Bharata et al. are
>   reportedly working on.  I really hope to see some new whiteout code in -mm
>   soon.  Bharata?
> 
> - reworking the lookup code to handle vfsmounts: this'll be needed when we
>   switch from vfs_* to path_* (Miklos's patches).
> 
> As for other fundamental issues, I've been posting some suggestions in
> recent months.  For example
> 
> - the need for cleaner handling of vma->fault(), a relatively minor patch I
>   posted, based on hch's LSF08 suggestions.  Got no response from any of the
>   VFS folks.
> 
> - a post I made regarding suggestions on how to handle lower f/s changes,
>   based on Viro's LSF08 comments: to have a superblock level writers count
>   (I suggested that it's a superset of the superblock->s_vfs_rename_mutex,
>   and perhaps be elevated to be one).  Again, got no responses from anyone
>   on the VFS team.

Erez, do you have links to email threads or a commentary of the things
that are causing concern somewhere?

I spotted one but it seems light on for descriptive value (or maybe it's
me who's light on for understanding, ;)).

> 
> So I'm not sure how much the VFS guys have time now to review such patches
> and help me address these issues.  We can't seem to get through even simpler
> issues, nor get simple patches merged (ala the copy_inode_size) despite
> repeated attempts.

Yeah, life is like that a lot for me too.

But why not assume that, given a reasonable amount of time, a "no
response" is equivalent to a "no complaints" and push on with the
updates. Sooner or later someone who cares enough will take a look and
give the needed feedback.

Ian


