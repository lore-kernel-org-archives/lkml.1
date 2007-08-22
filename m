Return-Path: <linux-kernel-owner+w=401wt.eu-S1759462AbXHVJBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbXHVJBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757715AbXHVIxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:31 -0400
Received: from 1wt.eu ([62.212.114.60]:2079 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910AbXHVIx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:27 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084002.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:04 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Alexey Dobriyan <adobriyan@sw.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 20/58] Fix leak on /proc/lockdep_stats
Content-Disposition: inline; filename=0020-Fix-leak-on-proc-lockdep_stats.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/lockdep_proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index b554b40..d787db5 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -323,7 +323,7 @@ static const struct file_operations proc_lockdep_stats_operations = {
 	.open		= lockdep_stats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= single_release,
 };
 
 static int __init lockdep_proc_init(void)
-- 
1.5.2.5

-- 
