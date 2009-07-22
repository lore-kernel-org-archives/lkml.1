Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbZGVT2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbZGVT2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 15:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbZGVT2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 15:28:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:47767 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbZGVT2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 15:28:13 -0400
Subject: [PULL] lockdep patches
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 21:28:01 +0200
Message-Id: <1248290881.4711.6.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull these lockdep patches from:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git lockdep-for-linus

Thanks,

  Peter

---
Peter Zijlstra (1):
      lockdep: Fix lockdep annotation for pipe_double_lock()

 fs/pipe.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index f7dd21a..52c4151 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -68,8 +68,8 @@ void pipe_double_lock(struct pipe_inode_info *pipe1,
 		pipe_lock_nested(pipe1, I_MUTEX_PARENT);
 		pipe_lock_nested(pipe2, I_MUTEX_CHILD);
 	} else {
-		pipe_lock_nested(pipe2, I_MUTEX_CHILD);
-		pipe_lock_nested(pipe1, I_MUTEX_PARENT);
+		pipe_lock_nested(pipe2, I_MUTEX_PARENT);
+		pipe_lock_nested(pipe1, I_MUTEX_CHILD);
 	}
 }
 


