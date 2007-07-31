Return-Path: <linux-kernel-owner+w=401wt.eu-S1765072AbXGaRRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765072AbXGaRRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758659AbXGaRR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:17:29 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3460 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbXGaRR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:17:28 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 13] kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 19:17:27 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       reiserfs-dev@namesys.com, reiserfs-devel@vger.kernel.org
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311917.27783.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 fs/reiser4/plugin/file/cryptcompress.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc1-mm1-a/fs/reiser4/plugin/file/cryptcompress.h	2007-07-26 13:07:46.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/fs/reiser4/plugin/file/cryptcompress.h	2007-07-31 15:01:29.000000000 +0200
@@ -83,10 +83,9 @@ static inline int alloc_ts(struct tfm_st
 	assert("edward-931", stm);
 	assert("edward-932", *stm == NULL);

-	*stm = kmalloc(sizeof **stm, reiser4_ctx_gfp_mask_get());
-	if (*stm == NULL)
+	*stm = kzalloc(sizeof(**stm), reiser4_ctx_gfp_mask_get());
+	if (!*stm)
 		return -ENOMEM;
-	memset(*stm, 0, sizeof **stm);
 	return 0;
 }

