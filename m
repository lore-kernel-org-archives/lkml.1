Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbYKJFhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbYKJFhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 00:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYKJFgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 00:36:50 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:38335 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbYKJFgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 00:36:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=NXKN951xBZOaX3JEzp4cE7RKPv9DtGypi8DJ85y6yEX7slRTxoTetM8yrR4aa5t4TA
         3PdzKCg/FwYWNYnZQaqLjjr1IqF9lG3rpgfSgmDUAh7R2hkBkD3Mf6YNcncjUM7VvOKZ
         ZqLe/0+DIzb2cR3fDHbjl+Oji3xA0HnpWmWIM=
Subject: [PATCH 2/3] lib: radix_tree.c make percpu variable static
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 09 Nov 2008 21:36:43 -0800
Message-Id: <1226295403.5478.12.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

radix_tree_preloads is unused outside of this file, make it static.

Noticed by sparse:
lib/radix-tree.c:84:1: warning: symbol 'per_cpu__radix_tree_preloads' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 lib/radix-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index be86b32..8d3fb0b 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -81,7 +81,7 @@ struct radix_tree_preload {
 	int nr;
 	struct radix_tree_node *nodes[RADIX_TREE_MAX_PATH];
 };
-DEFINE_PER_CPU(struct radix_tree_preload, radix_tree_preloads) = { 0, };
+static DEFINE_PER_CPU(struct radix_tree_preload, radix_tree_preloads) = { 0, };
 
 static inline gfp_t root_gfp_mask(struct radix_tree_root *root)
 {
-- 
1.6.0.3.866.gc189b


