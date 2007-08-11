Return-Path: <linux-kernel-owner+w=401wt.eu-S1764640AbXHKTCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764640AbXHKTCP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762488AbXHKS6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:58:21 -0400
Received: from 1wt.eu ([62.212.114.60]:1548 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762436AbXHKS6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:58:20 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184847.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:48:13 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Tony Jones <tonyj@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 21/28] audit: fix oops removing watch if audit disabled
Content-Disposition: inline; filename=0021-audit-fix-oops-removing-watch-if-audit-disabled.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Removing a watched file will oops if audit is disabled (auditctl -e 0).

To reproduce:
- auditctl -e 1
- touch /tmp/foo
- auditctl -w /tmp/foo
- auditctl -e 0
- rm /tmp/foo (or mv)

Signed-off-by: Tony Jones <tonyj@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/auditfilter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 9c8c232..5a75657 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -905,7 +905,7 @@ static void audit_update_watch(struct audit_parent *parent,
 
 		/* If the update involves invalidating rules, do the inode-based
 		 * filtering now, so we don't omit records. */
-		if (invalidating &&
+		if (invalidating && current->audit_context &&
 		    audit_filter_inodes(current, current->audit_context) == AUDIT_RECORD_CONTEXT)
 			audit_set_auditable(current->audit_context);
 
-- 
1.5.2.4

-- 
