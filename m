Return-Path: <linux-kernel-owner+w=401wt.eu-S1761296AbYBZKZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761296AbYBZKZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 05:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758774AbYBZKZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 05:25:11 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:10041 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757009AbYBZKZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 05:25:10 -0500
Date: Tue, 26 Feb 2008 13:24:37 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] keys: switch to proc_create()
Message-ID: <20080226102437.GE7469@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 security/keys/proc.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/security/keys/proc.c
+++ b/security/keys/proc.c
@@ -70,19 +70,15 @@ static int __init key_proc_init(void)
 	struct proc_dir_entry *p;
 
 #ifdef CONFIG_KEYS_DEBUG_PROC_KEYS
-	p = create_proc_entry("keys", 0, NULL);
+	p = proc_create("keys", 0, NULL, &proc_keys_fops);
 	if (!p)
 		panic("Cannot create /proc/keys\n");
-
-	p->proc_fops = &proc_keys_fops;
 #endif
 
-	p = create_proc_entry("key-users", 0, NULL);
+	p = proc_create("key-users", 0, NULL, &proc_key_users_fops);
 	if (!p)
 		panic("Cannot create /proc/key-users\n");
 
-	p->proc_fops = &proc_key_users_fops;
-
 	return 0;
 
 } /* end key_proc_init() */

