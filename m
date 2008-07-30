Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbYG3AWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbYG3AWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbYG3AWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:22:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752746AbYG3AWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:22:30 -0400
Date: Tue, 29 Jul 2008 17:22:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: ezk@cs.sunysb.edu, linux-kernel@vger.kernel.org, unionfs@filesystems.org
Subject: Re: [PATCH -mm] unionfs: build fixes
Message-Id: <20080729172216.84e958f7.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0807291907440.13365@blonde.site>
References: <Pine.LNX.4.64.0807291907440.13365@blonde.site>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 19:12:47 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

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

thanks.

> This should follow git-unionfs.patch
> I notice my unionfs-fix-memory-leak.patch
> and fsstack-fsstack_copy_inode_size-locking.patch
> are currently commented out, yet I don't recall the
> mm-commits dispatch rider bringing me a telegram to explain why?

git-unionfs got commented out because of some upstream git (or build)
catastrophe.  So its fixes got comemnted out too.  Then git-unionfs was
restored but I forgot to manually restore the followon fixes.  It
happens.

I must say that I'm not really sure why we're struggling along with
unionfs.  Last I heard there were fundamental, unresolveable design
disagreements with the VFS guys.  Those issues should be where 100% of
the effort is being devoted, but instead we seem to be cruising along
in a different direction?

