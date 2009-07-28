Return-Path: <linux-kernel-owner+w=401wt.eu-S932180AbZG1Xxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbZG1Xxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756073AbZG1XxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:53:11 -0400
Received: from kroah.org ([198.145.64.141]:35951 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804AbZG1Xu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:28 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:42:01 2009
Message-Id: <20090728234200.899309524@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>
Subject: [patch 61/71] netfilter: xt_quota: fix incomplete initialization
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=netfilter-xt_quota-fix-incomplete-initialization.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Engelhardt <jengelh@medozas.de>

commit 6d62182fea6cc6bbc8d82a691ad0608d68a54aeb upstream.

Commit v2.6.29-rc5-872-gacc738f ("xtables: avoid pointer to self")
forgot to copy the initial quota value supplied by iptables into the
private structure, thus counting from whatever was in the memory
kmalloc returned.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/xt_quota.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -54,6 +54,7 @@ static bool quota_mt_check(const struct 
 	if (q->master == NULL)
 		return -ENOMEM;
 
+	q->master->quota = q->quota;
 	return true;
 }
 


