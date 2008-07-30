Return-Path: <linux-kernel-owner+w=401wt.eu-S1760953AbYG3BD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760953AbYG3BD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364AbYG3BAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 21:00:45 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:45202 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760735AbYG3BAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 21:00:43 -0400
Date: Tue, 29 Jul 2008 21:00:27 -0400
Message-Id: <200807300100.m6U10R8A015358@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Erez Zadok <ezk@cs.sunysb.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] unionfs: build fixes 
In-reply-to: Your message of "Tue, 29 Jul 2008 19:12:47 BST."
             <Pine.LNX.4.64.0807291907440.13365@blonde.site> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <Pine.LNX.4.64.0807291907440.13365@blonde.site>, Hugh Dickins writes:
> Get unionfs building and working in mmotm with the 2.6.27-rc1 VFS changes:
> permission() has been replaced by inode_permission() without nameidata arg;
> unionfs_permission() without nameidata arg; vfs_symlink() without mode arg;
> LOOKUP_ACCESS no longer defined; and kmem_cache_create() no longer passes
> kmem_cachep to the init_once() constructor.
> 
> Note: while okay for inclusion in -mm for now, unionfs_permission() mods
> will need review and perhaps correction by Erez: without a nameidata arg,
> some locking vanishes from unionfs_permission(), and a MNT_NOEXEC check on
> its lower_inode; I have not studied the VFS changes enough to tell whether
> that amounts to a real issue for unionfs, or just removal of dead code.

Thanks Hugh.  You beat me by few hours. :-) I've been testing similar fixes
for several days already (and was waiting for the dust to settle in the
merge window, b/c patches flying b/t linus's tree, -next, and -mm).

I've also looked at the inode_permission() locking, and tested it, and I
think it should be safe as long as the refcnt on the inode doesn't go to
zero.  In fact, I think unionfs_permission can be possibly further trimmed.

> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> Cc: Erez Zadok <ezk@cs.sunysb.edu>
> ---
> This should follow git-unionfs.patch
> I notice my unionfs-fix-memory-leak.patch
> and fsstack-fsstack_copy_inode_size-locking.patch
> are currently commented out, yet I don't recall the
> mm-commits dispatch rider bringing me a telegram to explain why?

Both of those patches are in my tree now (not yet pushed to korg).

Note: your fsstack-fsstack_copy_inode_size-locking patch should really go to
mainline, but the one you sent depends on code in unionfs.  So temporarily
I'm folding it into my tree.  In a couple of days (once I switch from using
git to something like quilt) I'll extract it out into a separate patch which
can be applied cleanly against linux-next, so that Andrew can hopefully send
it upstream.

Erez.
