Return-Path: <linux-kernel-owner+w=401wt.eu-S932314Ab0ANWQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab0ANWQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932096Ab0ANWQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:16:26 -0500
Received: from [206.15.93.42] ([206.15.93.42]:6345 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932085Ab0ANWQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:16:26 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] prio_tree.c: quiet sparse noise
Date: Thu, 14 Jan 2010 15:16:27 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001141516.27305.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prio_tree.c: quiet sparse noise

The function prio_tree_init is called during start_kernel. Since it
is an __init function it is not exposed as an exported symbol.
A sparse build produces the following warning because of this:

warning: symbol 'prio_tree_init' was not declared. Should it be static?

Quiet the warning by declaring the function as an extern before
it's definition.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/lib/prio_tree.c b/lib/prio_tree.c
index ccfd850..a677200 100644
--- a/lib/prio_tree.c
+++ b/lib/prio_tree.c
@@ -68,6 +68,9 @@ static void get_index(const struct prio_tree_root *root,
 
 static unsigned long index_bits_to_maxindex[BITS_PER_LONG];
 
+/* Keep sparse happy since this is not an EXPORT_SYMBOL */
+extern void prio_tree_init(void);
+
 void __init prio_tree_init(void)
 {
 	unsigned int i;
