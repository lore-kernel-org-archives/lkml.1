Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbZCDE3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbZCDE3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 23:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbZCDE2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 23:28:55 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:47322 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbZCDE2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 23:28:55 -0500
Date: Wed, 4 Mar 2009 09:59:20 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH mmotm] cgroup: remove rcu_read_lock() from css_get_next()
Message-ID: <20090304042920.GA4508@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup: remove rcu_read_lock() from css_get_next()

Callers of css_get_next() are already calling css_get_next()
under rcu_read_lock() and hence there there is no need for
css_get_next() to re-acquire rcu_read_lock(). As per the
comments in css_get_next(), let the callers accquire the
rcu_read_lock().

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/cgroup.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3553,7 +3553,6 @@ css_get_next(struct cgroup_subsys *ss, i
 		return NULL;
 
 	BUG_ON(!ss->use_id);
-	rcu_read_lock();
 	/* fill start point for scan */
 	tmpid = id;
 	while (1) {
@@ -3577,8 +3576,6 @@ css_get_next(struct cgroup_subsys *ss, i
 		/* continue to scan from next id */
 		tmpid = tmpid + 1;
 	}
-
-	rcu_read_unlock();
 	return ret;
 }
 
Regards,
Bharata.
