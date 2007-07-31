Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbXGaWIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbXGaWIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbXGaWIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:08:23 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3617 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbXGaWIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:08:22 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 74] include/linux/textsearch.h: kmalloc + memset conversion to kzalloc
Date: Wed, 1 Aug 2007 00:08:23 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708010008.23721.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 include/linux/textsearch.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc1-mm1-a/include/linux/textsearch.h	2007-07-26 13:07:40.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/include/linux/textsearch.h	2007-07-31 11:58:29.000000000 +0200
@@ -164,11 +164,10 @@ static inline struct ts_config *alloc_ts
 {
 	struct ts_config *conf;

-	conf = kmalloc(TS_PRIV_ALIGN(sizeof(*conf)) + payload, gfp_mask);
-	if (conf == NULL)
+	conf = kzalloc(TS_PRIV_ALIGN(sizeof(*conf)) + payload, gfp_mask);
+	if (!conf)
 		return ERR_PTR(-ENOMEM);

-	memset(conf, 0, TS_PRIV_ALIGN(sizeof(*conf)) + payload);
 	return conf;
 }

