Return-Path: <linux-kernel-owner+w=401wt.eu-S1759900AbXJYO15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900AbXJYO15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 10:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbXJYO1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 10:27:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbXJYO1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 10:27:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix pointer mismatches in proc_sysctl.c
To: torvalds@osdl.org, akpm@osdl.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 25 Oct 2007 15:27:40 +0100
Message-ID: <20071025142740.23699.15039.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix pointer mismatches in proc_sysctl.c.  The proc_handler() method returns a
size_t through an arg pointer, but is given a pointer to a ssize_t to return
into.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/proc/proc_sysctl.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 680c429..4e57fcf 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -171,7 +171,8 @@ static ssize_t proc_sys_read(struct file *filp, char __user *buf,
 	struct dentry *dentry = filp->f_dentry;
 	struct ctl_table_header *head;
 	struct ctl_table *table;
-	ssize_t error, res;
+	ssize_t error;
+	size_t res;
 
 	table = do_proc_sys_lookup(dentry->d_parent, &dentry->d_name, &head);
 	/* Has the sysctl entry disappeared on us? */
@@ -209,7 +210,8 @@ static ssize_t proc_sys_write(struct file *filp, const char __user *buf,
 	struct dentry *dentry = filp->f_dentry;
 	struct ctl_table_header *head;
 	struct ctl_table *table;
-	ssize_t error, res;
+	ssize_t error;
+	size_t res;
 
 	table = do_proc_sys_lookup(dentry->d_parent, &dentry->d_name, &head);
 	/* Has the sysctl entry disappeared on us? */

