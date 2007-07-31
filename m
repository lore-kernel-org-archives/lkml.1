Return-Path: <linux-kernel-owner+w=401wt.eu-S932195AbXGaV1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbXGaV1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933695AbXGaV1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:27:32 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2192 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933649AbXGaV1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:27:30 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 55] drivers/char/n_hdlc.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 23:27:30 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       khc@pm.waw.pl
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312327.30692.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/n_hdlc.c | 27451 -> 27423 (-28 bytes)
 drivers/char/n_hdlc.o | 112528 -> 112516 (-12 bytes)

 drivers/char/n_hdlc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/char/n_hdlc.c	2007-07-26 13:07:41.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/char/n_hdlc.c	2007-07-31 23:19:40.000000000 +0200
@@ -807,13 +807,12 @@ static struct n_hdlc *n_hdlc_alloc(void)
 {
 	struct n_hdlc_buf *buf;
 	int i;
-	struct n_hdlc *n_hdlc = kmalloc(sizeof(*n_hdlc), GFP_KERNEL);
-
+	struct n_hdlc *n_hdlc;
+
+	n_hdlc = kzalloc(sizeof(*n_hdlc), GFP_KERNEL);
 	if (!n_hdlc)
 		return NULL;

-	memset(n_hdlc, 0, sizeof(*n_hdlc));
-
 	n_hdlc_buf_list_init(&n_hdlc->rx_free_buf_list);
 	n_hdlc_buf_list_init(&n_hdlc->tx_free_buf_list);
 	n_hdlc_buf_list_init(&n_hdlc->rx_buf_list);
