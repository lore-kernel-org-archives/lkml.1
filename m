Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbYIDQGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbYIDQGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 12:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYIDQF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 12:05:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59830 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbYIDQF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 12:05:58 -0400
Date: Thu, 4 Sep 2008 17:05:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Parisc List <linux-parisc@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] forgotten refcount on sysctl root table
Message-ID: <20080904160557.GT28946@ZenIV.linux.org.uk>
References: <1220540651.3276.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220540651.3276.16.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	We should've set refcount on the root sysctl table; otherwise we'll
blow up the first time we get down to zero dynamically registered sysctl
tables.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index fe47133..50ec088 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -159,6 +159,7 @@ static int proc_dointvec_taint(struct ctl_table *table, int write, struct file *
 static struct ctl_table root_table[];
 static struct ctl_table_root sysctl_table_root;
 static struct ctl_table_header root_table_header = {
+	.count = 1,
 	.ctl_table = root_table,
 	.ctl_entry = LIST_HEAD_INIT(sysctl_table_root.default_set.list),
 	.root = &sysctl_table_root,
