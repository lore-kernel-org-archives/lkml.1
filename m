Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbZBZClT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbZBZClT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 21:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbZBZClL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 21:41:11 -0500
Received: from sineb-mail-1.sun.com ([192.18.19.6]:45432 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbZBZClK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 21:41:10 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain
Date: Thu, 26 Feb 2009 10:40:05 +0800
From: Li Wei <W.Li@Sun.COM>
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
In-reply-to: <49883CD7.2060602@linux.vnet.ibm.com>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Sam Ravnborg <sam@ravnborg.org>
Message-id: <1235616005.7351.8.camel@localhost>
X-Mailer: Evolution 2.24.3
References: <49883CD7.2060602@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

node->parent is always NULL, causing NULL-pointer dereference in
remove_node.

Could you please include something like this?

---
 kernel/gcov/fs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/gcov/fs.c b/kernel/gcov/fs.c
index 0084492..6675c82 100644
--- a/kernel/gcov/fs.c
+++ b/kernel/gcov/fs.c
@@ -374,6 +374,7 @@ static struct gcov_node *new_node(struct gcov_node *parent,
 		return NULL;
 	}
 	init_node(node, info, name);
+	node->parent = parent;
 	/* Differentiate between gcov data file nodes and directory nodes. */
 	if (info) {
 		node->dentry = debugfs_create_file(deskew(node->name), 0600,
-- 
1.5.6.3



