Return-Path: <linux-kernel-owner+w=401wt.eu-S1761646AbXGaRIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761646AbXGaRIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbXGaRI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:08:29 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3960 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbXGaRI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:08:28 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 09] drivers/char/consolemap.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 19:08:28 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311908.28679.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/consolemap.c | 22678 -> 22650 (-28 bytes)
 drivers/char/consolemap.o | 90113 -> 90029 (-84 bytes)

 drivers/char/consolemap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/char/consolemap.c	2007-07-26 13:07:41.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/char/consolemap.c	2007-07-31 11:24:24.000000000 +0200
@@ -494,12 +494,11 @@ int con_clear_unimap(struct vc_data *vc,
 	p = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
 	if (p && p->readonly) return -EIO;
 	if (!p || --p->refcount) {
-		q = kmalloc(sizeof(*p), GFP_KERNEL);
+		q = kzalloc(sizeof(*p), GFP_KERNEL);
 		if (!q) {
 			if (p) p->refcount++;
 			return -ENOMEM;
 		}
-		memset(q, 0, sizeof(*q));
 		q->refcount=1;
 		*vc->vc_uni_pagedir_loc = (unsigned long)q;
 	} else {
