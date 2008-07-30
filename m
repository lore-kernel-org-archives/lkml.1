Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbYG3D2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbYG3D2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 23:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbYG3D2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 23:28:43 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41215 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbYG3D2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 23:28:42 -0400
Date: Wed, 30 Jul 2008 08:57:38 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hugh@veritas.com>,
       unionfs@filesystems.org, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [Unionfs] Re: [PATCH -mm] unionfs: build fixes
Message-ID: <20080730032738.GA3977@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20080729172216.84e958f7.akpm@linux-foundation.org> <200807300102.m6U123KW015449@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807300102.m6U123KW015449@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 09:02:03PM -0400, Erez Zadok wrote:
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

When I last checked, David Woodhouse/Jan Blunck were working on this.
Looks like they have become busy with other work now. I can take that work
forward.

Jan/David, if this means duplicating your efforts, please let me know.

Regards,
Bharata.
