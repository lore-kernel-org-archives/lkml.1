Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbYFKUYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbYFKUYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbYFKUYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:24:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450AbYFKUYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:24:03 -0400
Date: Wed, 11 Jun 2008 13:22:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: oberparleiter@googlemail.com, linux-kernel@vger.kernel.org,
       ltp-coverage@lists.sourceforge.net, sam@ravnborg.org
Subject: Re: [PATCH 0/6] gcov kernel support
Message-Id: <20080611132227.593b13ea.akpm@linux-foundation.org>
In-Reply-To: <484FCC4A.1010605@de.ibm.com>
References: <4843F6BF.9070409@de.ibm.com>
	<20080609002509.7782442e.akpm@linux-foundation.org>
	<484D34DC.40401@de.ibm.com>
	<20080609120954.7d41a5bf.akpm@linux-foundation.org>
	<484FCC4A.1010605@de.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008 14:59:54 +0200
Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:

> Andrew Morton wrote:
> > On Mon, 09 Jun 2008 15:49:16 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:
> > 
> >> Andrew Morton wrote:
> >> > On Mon, 02 Jun 2008 15:33:51 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:
> >> > 
> >> >> This is version #3 of the gcov kernel support patch set 
> >> > 
> >> > My build tree is now filled with dead symlinks, like
> >> > 
> >> > lrwxrwxrwx 1 akpm akpm 64 Jun  9 00:06 security/selinux/nlmsgtab.gcda -> /sys/kernel/debug/gcov/usr/src/25/security/selinux/nlmsgtab.gcda
> >> 
> >> Unfortunately a necessary evil of this approach: symlinks are created
> >> for all compiled source files while link targets are only available when
> >> the corresponding code is executed. In other words: those links will be
> >> dead for source files which don't compile to actual code and for modules
> >> as long as they are not loaded.
> > 
> > It doesn't seem awfully useful.  I don't run kernels on my build
> > machines and I'm sure many are in the same situation.  So gcov is going
> > to need a way of locating these files on the *target* machine.  And
> > once that is available, there is no need to add all these symlinks into
> > the build directory.
> 
> I don't see any other feasibly way to do it if we want the kernel to
> work out-of-the-box with gcov. If the kernel was a user-space
> application, gcc/libgcov would create the .gcda files in exactly the
> same place where the symbolic links are now.
> 
> If we removed those symlinks, users would have to manually copy files
> from /sys on the test machine to the correct position in /objtree on the
> build machine before being able to get any kind of result. This would
> IMO reduce the usefulness of the gcov kernel infrastructure noticeably
> (though gcov-wrappers such as lcov could be modified to hide the
> additional effort).

gcov needs both the .gcda files and the source tree available to do its
work, I assume.

So a sensible scenario would be to copy the entire build tree,
including the .gcda symlinks over to the target system, yes? 
tar+scp+untar?

If so, it'd be good to get that tested and documented...

> How about a CONFIG_GCOV_PROFILE_SYMLINKS configuration option?

What use would that be?

> >> > Which causes (at least)
> >> > 
> >> > ctags: Warning: cannot open source file "security/selinux/ss/conditional.gcda" : No such file or directory
> >> > ctags: Warning: cannot open source file "security/selinux/netlink.gcda" : No such file or directory
> >> > ctags: Warning: cannot open source file "security/selinux/netlabel.gcda" : No such file or directory
> >> 
> >> > and probably other thing which I haven't discovered yet.
> 
> I would argue that any mechanism that tries to access all files in
> /objtree regardless of filename extension is brave at best, if not
> broken.

Well, these things happen.  You'll probably need to add these to .gitignore.

<does Samsummoning dance>
