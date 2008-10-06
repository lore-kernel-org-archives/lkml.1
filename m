Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbYJFMXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbYJFMXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 08:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYJFMX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 08:23:26 -0400
Received: from userg501.nifty.com ([202.248.238.81]:57032 "EHLO
	userg501.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbYJFMXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:23:25 -0400
DomainKey-Signature: a=rsa-sha1; s=userg501; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=TJqd9U2JZ0qYmUC9YdtQdKmig4VLq0uL1VLvKjcn17ged6r6csa+J5lJKBMMWLBPv
	w0hNVVP1ZVr2BwCOKt9bw==
X-Nifty-SrcIP: [220.145.29.93]
Date: Mon, 6 Oct 2008 21:18:30 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: RE: [PATCH 03/19] pcmcia: Whine harder about use of EXCLUSIVE
Message-Id: <20081006211830.4976f166.komurojun-mbn@nifty.com>
In-Reply-To: <20080922231227.2625dd09@lxorguk.ukuu.org.uk>
References: <20080922155814.2bdad40f@lxorguk.ukuu.org.uk>
	<20080922215617.GA13057@comet.dominikbrodowski.net>
	<20080922231227.2625dd09@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



duplicate warning message in pcmcia_resource.c ....


>   /* Make sure the fact the request type was overridden is passed back */
>    if (type == IRQF_SHARED && !(req->Attributes & IRQ_TYPE_DYNAMIC_SHARING)) {
>        req->Attributes |= IRQ_TYPE_DYNAMIC_SHARING;
>        printk(KERN_WARNING "pcmcia: request for exclusive IRQ could not be fulfilled.\n");
>        printk(KERN_WARNING "pcmcia: the driver needs updating to supported shared IRQ lines\n");
>     }



>diff --git a/drivers/pcmcia/pcmcia_resource.c b/drivers/pcmcia/pcmcia_resource.c
>index 4884a18..8f1c3d4 100644
>--- a/drivers/pcmcia/pcmcia_resource.c
>+++ b/drivers/pcmcia/pcmcia_resource.c
>@@ -738,8 +738,9 @@ int pcmcia_request_irq(struct pcmcia_device *p_dev, irq_req_t *req)
> 	type = 0;
> 	if (s->functions > 1)		/* All of this ought to be handled higher up */
> 		type = IRQF_SHARED;
>-	if (req->Attributes & IRQ_TYPE_DYNAMIC_SHARING)
>+	else if (req->Attributes & IRQ_TYPE_DYNAMIC_SHARING)
> 		type = IRQF_SHARED;
>+	else printk(KERN_WARNING "pcmcia: Driver needs updating to support IRQ sharing.\n");
> 
> #ifdef CONFIG_PCMCIA_PROBE
 

Best Regards
Komuro
