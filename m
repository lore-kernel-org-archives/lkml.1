Return-Path: <linux-kernel-owner+w=401wt.eu-S1758042AbYDYWdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbYDYWdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 18:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbYDYWcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 18:32:53 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:21021 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbYDYWcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 18:32:52 -0400
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, bfields@citi.umich.edu,
       Trond.Myklebust@netapp.com
Subject: [PATCH] Export __locks_copy_lock() so modular lockd builds
X-Message-Flag: Warning: May contain useful information
Date: Fri, 25 Apr 2008 15:32:51 -0700
Message-ID: <adar6ct5zvw.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Apr 2008 22:32:51.0870 (UTC) FILETIME=[4C2C6BE0:01C8A724]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1a747ee0 ("locks: don't call ->copy_lock methods on return of
conflicting locks") changed fs/lockd/svclock.c to call
__locks_copy_lock() instead of locks_copy_lock(), but lockd can be built
as a module and __locks_copy_lock() is not exported, which causes a
build error

    ERROR: "__locks_copy_lock" [fs/lockd/lockd.ko] undefined!

with CONFIG_LOCKD=m.

Fix this by exporting __locks_copy_lock().

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 fs/locks.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index e1ea2fe..44d9a6a 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -236,6 +236,7 @@ void __locks_copy_lock(struct file_lock *new, const struct file_lock *fl)
 	new->fl_ops = NULL;
 	new->fl_lmops = NULL;
 }
+EXPORT_SYMBOL(__locks_copy_lock);
 
 void locks_copy_lock(struct file_lock *new, struct file_lock *fl)
 {
