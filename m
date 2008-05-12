Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbYELNR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbYELNR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 09:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbYELNRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 09:17:51 -0400
Received: from c60.cesmail.net ([216.154.195.49]:46826 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514AbYELNRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 09:17:51 -0400
Subject: [PATCH] module: fix panic in is_imv_cond_end_module()
From: Pavel Roskin <proski@gnu.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 12 May 2008 09:17:49 -0400
Message-Id: <1210598269.7921.5.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
The patch is for mingo/linux-2.6-ftrace.git repository.

 kernel/module.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/kernel/module.c b/kernel/module.c
index 8f2f6fd..1831868 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2664,6 +2664,10 @@ EXPORT_SYMBOL_GPL(module_imv_update);
 int is_imv_cond_end_module(unsigned long addr1, unsigned long addr2)
 {
 	struct module *mod = __module_text_address(addr1);
+
+	if (!mod)
+		return 0;
+
 	return _is_imv_cond_end(mod->immediate_cond_end,
 		mod->immediate_cond_end + mod->num_immediate_cond_end,
 		addr1, addr2);

-- 
Regards,
Pavel Roskin
