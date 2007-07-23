Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbXGWPNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbXGWPNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 11:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbXGWPNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 11:13:11 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:48531 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbXGWPNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 11:13:09 -0400
Date: Mon, 23 Jul 2007 17:13:07 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Yoann Padioleau <padator@wanadoo.fr>
cc: kernel-janitors@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dev->priv to netdev_priv(dev), drivers/net/tokenring/
In-Reply-To: <87r6mzmf6q.fsf@wanadoo.fr>
Message-ID: <Pine.LNX.4.64.0707231712120.32367@fbirervta.pbzchgretzou.qr>
References: <87r6mzmf6q.fsf@wanadoo.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 23 2007 15:18, Yoann Padioleau wrote:
>
>Here is an excerpt of the semantic patch that performs the transformation
>
>@@
>
>- (T*) dev->priv
>+ netdev_priv(dev)

Note that dev->priv is a void*, and hence does not need casting.
So dev->priv may also appear without one.

> {
> 
>-	struct xl_private *xl_priv = (struct xl_private *)dev->priv ; 
>+	struct xl_private *xl_priv = netdev_priv(dev) ; 
> 	struct xl_tx_desc *txd ; 
> 	u8 __iomem *xl_mmio = xl_priv->xl_mmio ; 
> 	int i ; 

	Jan
-- 
