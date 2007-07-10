Return-Path: <linux-kernel-owner+w=401wt.eu-S1761979AbXGJLxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761979AbXGJLxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 07:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbXGJLxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 07:53:08 -0400
Received: from THUNK.ORG ([69.25.196.29]:49776 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358AbXGJLxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 07:53:06 -0400
Date: Tue, 10 Jul 2007 07:52:51 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Amit Arora <aarora@in.ibm.com>,
       Andi Kleen <ak@suse.de>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arnd Bergmann <arnd@arndb.de>, "Luck, Tony" <tony.luck@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>, Mark Fasheh <mark.fasheh@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: fallocate-implementation-on-i86-x86_64-and-powerpc.patch (was: re: -mm merge plans for 2.6.23)
Message-ID: <20070710115251.GG2343@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Amit Arora <aarora@in.ibm.com>,
	Andi Kleen <ak@suse.de>, Paul Mackerras <paulus@samba.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Arnd Bergmann <arnd@arndb.de>, "Luck, Tony" <tony.luck@intel.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Mark Fasheh <mark.fasheh@oracle.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 01:31:52AM -0700, Andrew Morton wrote:
>  Merge
> 
> fallocate-implementation-on-i86-x86_64-and-powerpc.patch

Andrew,

Could you replace the comment/header section of
fallocate-implementation-on-i86-x86_64-and-powerpc.patch with the
following (attached below) ?  This is from the ext4 patches, where
Amit had cleaned up description, which will make for a cleaner and
easier to understand submission into the git tree.

I've reviewed the other fallocate patches, noting the request to drop
the s390 patches since Martin has said he will wire up it up after
this hits mainline, and the only other change that I've found between
what we have in the ext4 tree and -mm is that we have 

	fallocate-on-ia64.patch
and
	fallocate-on-ia64-fix.patch 

merged into a single patch.  It probably would be better to merge them
before sending it off to Linus, in the interests of cleanliness and
making the tree more git-bisect friendly.

Regards,

						- Ted


From: Amit Arora <aarora@in.ibm.com>

sys_fallocate() implementation on i386, x86_64 and powerpc

fallocate() is a new system call being proposed here which will allow
applications to preallocate space to any file(s) in a file system.
Each file system implementation that wants to use this feature will need
to support an inode operation called ->fallocate().
Applications can use this feature to avoid fragmentation to certain
level and thus get faster access speed. With preallocation, applications
also get a guarantee of space for particular file(s) - even if later the
the system becomes full.

Currently, glibc provides an interface called posix_fallocate() which
can be used for similar cause. Though this has the advantage of working
on all file systems, but it is quite slow (since it writes zeroes to
each block that has to be preallocated). Without a doubt, file systems
can do this more efficiently within the kernel, by implementing
the proposed fallocate() system call. It is expected that
posix_fallocate() will be modified to call this new system call first
and incase the kernel/filesystem does not implement it, it should fall
back to the current implementation of writing zeroes to the new blocks.
ToDos:
1. Implementation on other architectures (other than i386, x86_64,
ppc64 and s390(x)). David Chinner has already posted a patch for ia64.
2. A generic file system operation to handle fallocate
(generic_fallocate), for filesystems that do _not_ have the fallocate
inode operation implemented.
3. Changes to glibc,
   a) to support fallocate() system call
   b) to make posix_fallocate() and posix_fallocate64() call fallocate()


Signed-off-by: Amit Arora <aarora@in.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
