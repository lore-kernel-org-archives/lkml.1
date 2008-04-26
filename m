Return-Path: <linux-kernel-owner+w=401wt.eu-S1751990AbYDZEZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbYDZEZW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 00:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbYDZEZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 00:25:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38972 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbYDZEZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 00:25:02 -0400
Date: Sat, 26 Apr 2008 05:25:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [fix] Re: [git pull] VFS patches
Message-ID: <20080426042459.GG5882@ZenIV.linux.org.uk>
References: <20080426020221.GF5882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426020221.GF5882@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Arrgghhh...

Sorry about that, I'd been sure I'd folded that one, but it actually got
lost.  Please apply - that breaks execve().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---

diff --git a/kernel/fork.c b/kernel/fork.c
index 4df3949..a647542 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1788,7 +1788,7 @@ bad_unshare_out:
 int unshare_files(struct files_struct **displaced)
 {
 	struct task_struct *task = current;
-	struct files_struct *copy;
+	struct files_struct *copy = NULL;
 	int error;
 
 	error = unshare_fd(CLONE_FILES, &copy);
