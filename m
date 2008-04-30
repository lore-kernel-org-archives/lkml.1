Return-Path: <linux-kernel-owner+w=401wt.eu-S1761602AbYD3HMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761602AbYD3HMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 03:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760512AbYD3HLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 03:11:51 -0400
Received: from relay2.sgi.com ([192.48.171.30]:39895 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760018AbYD3HLu (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 03:11:50 -0400
Date: Wed, 30 Apr 2008 17:11:16 +1000
From: David Chinner <dgc@sgi.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Chinner <dgc@sgi.com>, linux-next@vger.kernel.org,
       xfs-masters@oss.sgi.com, Christoph Hellwig <hch@infradead.org>,
       Lachlan McIlroy <lachlan@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH, XFS] Fix random.h include for non-debug builds
Message-ID: <20080430071116.GE108924158@sgi.com>
References: <20080430140027.6cd83fd0.sfr@canb.auug.org.au> <20080430063544.GA108924158@sgi.com> <20080430164218.9c2bfb1c.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430164218.9c2bfb1c.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 04:42:18PM +1000, Stephen Rothwell wrote:
> Hi David,
> 
> On Wed, 30 Apr 2008 16:35:44 +1000 David Chinner <dgc@sgi.com> wrote:
> >
> > Ah, I see the problem - a CONFIG_XFS_DEBUG build includes linux/random.h
> > in a debug header file. That's probably why I didn't catch it (I need to
> > check the .config on my build test tree).
> > 
> > I'll get it fixed properly, but in the mean time the include you've got
> > there will suffice...
> 
> Could you make sure something gets sent to Linus pretty quickly as this
> breaks a lot of the powerpc builds at the moment (see
> http://kisskb.ellerman.id.au/kisskb/branch/3/).

It should break anything that builds a non-debug XFS, not just powerpc.

> Or should I do my patch
> up and sent it?

No, the correct patch is below. Linus, can you please apply?

Cheers,

Dave.

---
Include linux/random.h in all builds, not just debug.


Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/linux-2.6/xfs_linux.h |    1 +
 fs/xfs/support/debug.h       |    2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_linux.h	2008-04-22 15:06:11.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_linux.h	2008-04-30 16:38:38.754688626 +1000
@@ -75,6 +75,7 @@
 #include <linux/delay.h>
 #include <linux/log2.h>
 #include <linux/spinlock.h>
+#include <linux/random.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
Index: 2.6.x-xfs-new/fs/xfs/support/debug.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/support/debug.h	2007-08-02 22:13:10.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/support/debug.h	2008-04-30 16:38:43.518080606 +1000
@@ -49,8 +49,6 @@ extern void assfail(char *expr, char *f,
 
 #else /* DEBUG */
 
-#include <linux/random.h>
-
 #define ASSERT(expr)	\
 	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
 
