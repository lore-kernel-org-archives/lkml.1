Return-Path: <linux-kernel-owner+w=401wt.eu-S1760019AbXHWJXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760019AbXHWJXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 05:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756972AbXHWJXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 05:23:46 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:3562 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756737AbXHWJXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 05:23:45 -0400
Date: Thu, 23 Aug 2007 13:22:59 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: devel@openvz.org, linux-kernel@vger.kernel.org, serue@us.ibm.com
Subject: [PATCH] userns: don't leak root user
Message-ID: <20070823092259.GB31289@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 kernel/user_namespace.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -81,6 +81,7 @@ void free_user_ns(struct kref *kref)
 	struct user_namespace *ns;
 
 	ns = container_of(kref, struct user_namespace, kref);
+	free_uid(ns->root_user);
 	kfree(ns);
 }
 

