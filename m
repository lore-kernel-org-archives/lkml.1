Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747AbZIXIcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbZIXIcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 04:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbZIXIbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 04:31:34 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:1113
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752628AbZIXIbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 04:31:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAMvIukrLO0En/2dsb2JhbADWL4QbBYFYZQ
X-IronPort-AV: E=Sophos;i="4.44,444,1249228800"; 
   d="scan'208";a="468142895"
From: Ian Kent <raven@themaw.net>
Subject: [RFC PATCH 09/11] autofs4 - rename dentry to active in
	autofs4_lookup_active()
To: Sage Weil <sage@newdream.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Andreas Dilger <adilger@sun.com>, Yehuda Saheh <yehuda@newdream.net>,
       Jim Garlick <garlick@llnl.gov>
Date: Thu, 24 Sep 2009 16:22:19 +0800
Message-ID: <20090924082219.22151.83740.stgit@zeus.themaw.net>
In-Reply-To: <20090924082036.22151.85151.stgit@zeus.themaw.net>
References: <20090924082036.22151.85151.stgit@zeus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In autofs4_lookup_active() a declaration within the list traversal
loop uses a declaration that has the same name as the function
parameter.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/root.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index b6530f3..e8a8881 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -419,23 +419,23 @@ static struct dentry *autofs4_lookup_active(struct dentry *dentry)
 	head = &sbi->active_list;
 	list_for_each(p, head) {
 		struct autofs_info *ino;
-		struct dentry *dentry;
+		struct dentry *active;
 		struct qstr *qstr;
 
 		ino = list_entry(p, struct autofs_info, active);
-		dentry = ino->dentry;
+		active = ino->dentry;
 
-		spin_lock(&dentry->d_lock);
+		spin_lock(&active->d_lock);
 
 		/* Already gone? */
-		if (atomic_read(&dentry->d_count) == 0)
+		if (atomic_read(&active->d_count) == 0)
 			goto next;
 
-		qstr = &dentry->d_name;
+		qstr = &active->d_name;
 
-		if (dentry->d_name.hash != hash)
+		if (active->d_name.hash != hash)
 			goto next;
-		if (dentry->d_parent != parent)
+		if (active->d_parent != parent)
 			goto next;
 
 		if (qstr->len != len)
@@ -443,15 +443,15 @@ static struct dentry *autofs4_lookup_active(struct dentry *dentry)
 		if (memcmp(qstr->name, str, len))
 			goto next;
 
-		if (d_unhashed(dentry)) {
-			dget(dentry);
-			spin_unlock(&dentry->d_lock);
+		if (d_unhashed(active)) {
+			dget(active);
+			spin_unlock(&active->d_lock);
 			spin_unlock(&sbi->lookup_lock);
 			spin_unlock(&dcache_lock);
-			return dentry;
+			return active;
 		}
 next:
-		spin_unlock(&dentry->d_lock);
+		spin_unlock(&active->d_lock);
 	}
 	spin_unlock(&sbi->lookup_lock);
 	spin_unlock(&dcache_lock);

