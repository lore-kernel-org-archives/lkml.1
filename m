Return-Path: <linux-kernel-owner+w=401wt.eu-S1761885AbYD2LPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761885AbYD2LPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 07:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbYD2LN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 07:13:27 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:39950 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755987AbYD2LNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 07:13:25 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Patrick McHardy <kaber@trash.net>
Subject: [PATCH 10/12] netfilter: assign PDE->fops before gluing PDE into /proc tree
Date: Tue, 29 Apr 2008 15:13:20 +0400
Message-Id: <1209467602-20001-10-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1209467538.29647.11.camel@iris.sw.ru>
References: <1209467538.29647.11.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace create_proc_entry with specially created for this purpose proc_create.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_conntrack_standalone.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index b59871f..46ea542 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -296,11 +296,11 @@ static int nf_conntrack_standalone_init_proc(void)
 	pde = proc_net_fops_create(&init_net, "nf_conntrack", 0440, &ct_file_ops);
 	if (!pde)
 		goto out_nf_conntrack;
-	pde = create_proc_entry("nf_conntrack", S_IRUGO, init_net.proc_net_stat);
+
+	pde = proc_create("nf_conntrack", S_IRUGO, init_net.proc_net_stat,
+			  &ct_cpu_seq_fops);
 	if (!pde)
 		goto out_stat_nf_conntrack;
-	pde->proc_fops = &ct_cpu_seq_fops;
-	pde->owner = THIS_MODULE;
 	return 0;
 
 out_stat_nf_conntrack:
-- 
1.5.3.rc5

