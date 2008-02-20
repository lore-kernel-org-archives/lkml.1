Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbYBTJ7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbYBTJ7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 04:59:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbYBTJ6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 04:58:54 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:43523 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbYBTJ6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 04:58:52 -0500
Date: Wed, 20 Feb 2008 02:07:18 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH 2/4] x86_64: fix dma_alloc_pages v2
In-reply-to: <200802200036.54406.yinghai.lu@sun.com>
To: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802200207.18403.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802200015.43547.yinghai.lu@sun.com>
 <200802200036.54406.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please use this one instead.

because v1 already in mm, and that doesn't depends on 1/4 here.

[PATCH 2/4] x86_64: fix dma_alloc_pages fix

this patch will use updated dev_to node, because dev_to_node already make sure
it have node online

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/kernel/pci-dma_64.c b/arch/x86/kernel/pci-dma_64.c
index 931b51a..375cb2b 100644
--- a/arch/x86/kernel/pci-dma_64.c
+++ b/arch/x86/kernel/pci-dma_64.c
@@ -53,8 +53,6 @@ dma_alloc_pages(struct device *dev, gfp_t gfp, unsigned order)
 	int node;
 
 	node = dev_to_node(dev);
-	if (node == -1 || !node_online(node))
-		node = numa_node_id();
 
 	page = alloc_pages_node(node, gfp, order);
 	return page ? page_address(page) : NULL;
