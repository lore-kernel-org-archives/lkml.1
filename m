Return-Path: <linux-kernel-owner+w=401wt.eu-S1758547AbXHHGCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbXHHGCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 02:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbXHHGC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 02:02:27 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1606 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbXHHGC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 02:02:26 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 55] drivers/char/n_hdlc.c: kmalloc + memset conversion to kzalloc
Date: Wed, 8 Aug 2007 08:02:24 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, khc@pm.waw.pl
References: <200707311845.48807.m.kozlowski@tuxland.pl> <200707312327.30692.m.kozlowski@tuxland.pl> <20070801011655.08e3c17b@the-village.bc.nu>
In-Reply-To: <20070801011655.08e3c17b@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708080802.24635.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
> NAK
> 
> > -	struct n_hdlc *n_hdlc = kmalloc(sizeof(*n_hdlc), GFP_KERNEL);
> > -
> > +	struct n_hdlc *n_hdlc;
> > +
> > +	n_hdlc = kzalloc(sizeof(*n_hdlc), GFP_KERNEL);
> 
> Change looks fine but please keep the original formatting style

Ok. Here it goes (based on 2.6.23-rc1-mm2).

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/n_hdlc.c | 27451 -> 27413 (-38 bytes)
 drivers/char/n_hdlc.o | 107068 -> 107088 (+20 bytes)

 drivers/char/n_hdlc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- linux-2.6.23-rc1-mm2-a/drivers/char/n_hdlc.c	2007-08-01 08:43:44.000000000 +0200
+++ linux-2.6.23-rc1-mm2-b/drivers/char/n_hdlc.c	2007-08-08 07:50:42.000000000 +0200
@@ -807,13 +807,11 @@ static struct n_hdlc *n_hdlc_alloc(void)
 {
 	struct n_hdlc_buf *buf;
 	int i;
-	struct n_hdlc *n_hdlc = kmalloc(sizeof(*n_hdlc), GFP_KERNEL);
+	struct n_hdlc *n_hdlc = kzalloc(sizeof(*n_hdlc), GFP_KERNEL);

 	if (!n_hdlc)
 		return NULL;

-	memset(n_hdlc, 0, sizeof(*n_hdlc));
-
 	n_hdlc_buf_list_init(&n_hdlc->rx_free_buf_list);
 	n_hdlc_buf_list_init(&n_hdlc->tx_free_buf_list);
 	n_hdlc_buf_list_init(&n_hdlc->rx_buf_list);
