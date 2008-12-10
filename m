Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbYLJSVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbYLJSVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYLJSVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:21:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63305 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbYLJSVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:21:12 -0500
Date: Wed, 10 Dec 2008 13:21:10 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] replace deprecated RW_LOCK_UNLOCKED in net/dccp/proto.c
Message-ID: <alpine.DEB.1.10.0812101314460.11805@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch is in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: cleanups


Steven Rostedt (1):
      replace deprecated RW_LOCK_UNLOCKED in net/dccp/proto.c

----
 net/dccp/proto.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
---------------------------
commit 3e1de819261b68a48b09719694c7e3579a8e4186
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Dec 10 12:49:47 2008 -0500

    replace deprecated RW_LOCK_UNLOCKED in net/dccp/proto.c
    
    Impact: clean up
    
    RW_LOCK_UNLOCKED has been deprecated and superseded by
    __RW_LOCK_UNLOCKED(name).  This patch removes one of the last
    remaining users of it.
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index d0bd348..e6e54a7 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -45,7 +45,7 @@ atomic_t dccp_orphan_count = ATOMIC_INIT(0);
 EXPORT_SYMBOL_GPL(dccp_orphan_count);
 
 struct inet_hashinfo __cacheline_aligned dccp_hashinfo = {
-	.lhash_lock	= RW_LOCK_UNLOCKED,
+	.lhash_lock	= __RW_LOCK_UNLOCKED(dccp_hashinfo.lhash_lock),
 	.lhash_users	= ATOMIC_INIT(0),
 	.lhash_wait = __WAIT_QUEUE_HEAD_INITIALIZER(dccp_hashinfo.lhash_wait),
 };
