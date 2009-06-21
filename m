Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbZFUTE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbZFUTE6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 15:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbZFUTEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 15:04:49 -0400
Received: from cmpxchg.org ([85.214.51.133]:42624 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602AbZFUTEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 15:04:49 -0400
Date: Sun, 21 Jun 2009 21:01:30 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Michal Simek <monstr@monstr.eu>,
       microblaze-uclinux@itee.uq.edu.au, LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: Re: [patch] ipc: unbreak 32-bit shmctl/semctl/msgctl
Message-ID: <20090621190130.GA4811@cmpxchg.org>
References: <cover.1245345894.git.arnd@arndb.de> <200906190031.17786.arnd@arndb.de> <20090620010939.GA3469@cmpxchg.org> <200906200820.56707.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906200820.56707.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 20, 2009 at 08:20:56AM +0000, Arnd Bergmann wrote:
> On Saturday 20 June 2009 01:09:39 am Johannes Weiner wrote:
> > 31a985f "ipc: use __ARCH_WANT_IPC_PARSE_VERSION in ipc/util.h" would
> > choose the implementation of ipc_parse_version() based on a symbol
> > defined in <asm/unistd.h>.
> > 
> > But it failed to also include this header and thus broke
> > IPC_64-passing 32-bit userspace because the flag wasn't masked out
> > properly anymore and the command not understood.
> > 
> > Include <linux/unistd.h> to give the architecture a chance to ask for
> > the no-no-op ipc_parse_version().
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> Obviously fixes the bug I introduced, sorry for the trouble and thanks
> for fixing it!

Linus, could you apply this patch?

OTOH, breaking mplayer on x86_32 is probably the way to push 64-bit as
the driving factor in adoption of new technology seems to be porn.

	Hannes

---
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Sat, 20 Jun 2009 02:23:29 +0200
Subject: [PATCH] ipc: unbreak 32-bit shmctl/semctl/msgctl

31a985f "ipc: use __ARCH_WANT_IPC_PARSE_VERSION in ipc/util.h" would
choose the implementation of ipc_parse_version() based on a symbol
defined in <asm/unistd.h>.

But it failed to also include this header and thus broke
IPC_64-passing 32-bit userspace because the flag wasn't masked out
properly anymore and the command not understood.

Include <linux/unistd.h> to give the architecture a chance to ask for
the no-no-op ipc_parse_version().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 ipc/util.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/ipc/util.h b/ipc/util.h
index ab3ebf2..764b51a 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -10,6 +10,7 @@
 #ifndef _IPC_UTIL_H
 #define _IPC_UTIL_H
 
+#include <linux/unistd.h>
 #include <linux/err.h>
 
 #define SEQ_MULTIPLIER	(IPCMNI)
-- 
1.6.3.2

