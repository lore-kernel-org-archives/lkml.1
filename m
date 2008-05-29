Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbYE2OQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbYE2OQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 10:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYE2OQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 10:16:39 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:17718 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbYE2OQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 10:16:38 -0400
From: Alexey Dobriyan <adobriyan@parallels.com>
To: akpm@osdl.org
Subject: [PATCH] sysctl: check for bogus modes
Date: Thu, 29 May 2008 18:15:53 +0400
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805291815.54321.adobriyan@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catch, e. g., 644/0644 typo.

Signed-off-by: Alexey Dobriyan <adobriyan@parallels.com>
---

 kernel/sysctl_check.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -1532,6 +1532,8 @@ int sysctl_check_table(struct nsproxy *namespaces, struct ctl_table *table)
 			sysctl_check_leaf(namespaces, table, &fail);
 		}
 		sysctl_check_bin_path(table, &fail);
+		if (table->mode > 0777)
+			set_fail(&fail, table, "bogus .mode");
 		if (fail) {
 			set_fail(&fail, table, NULL);
 			error = -EINVAL;
