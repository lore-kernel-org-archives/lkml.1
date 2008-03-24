Return-Path: <linux-kernel-owner+w=401wt.eu-S1760922AbYCXOmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760922AbYCXOmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 10:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757418AbYCXOmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 10:42:42 -0400
Received: from khc.piap.pl ([195.187.100.11]:38244 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbYCXOml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 10:42:41 -0400
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/net/wan/wanxl.c: time_before(timeout, jiffies) -> jiffies, timeout
References: <47E28637.4010700@tiscali.nl>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 24 Mar 2008 15:42:38 +0100
In-Reply-To: <47E28637.4010700@tiscali.nl> (Roel Kluin's message of "Thu\, 20 Mar 2008 16\:43\:51 +0100")
Message-ID: <m3k5js2nfl.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Roel Kluin <12o3l@tiscali.nl> writes:

> --- a/drivers/net/wan/wanxl.c
> +++ b/drivers/net/wan/wanxl.c
> @@ -650,7 +650,7 @@ static int __devinit wanxl_pci_init_one(struct pci_dev *pdev,
>  
>  	timeout = jiffies + 20 * HZ;
>  	while ((stat = readl(card->plx + PLX_MAILBOX_0)) != 0) {
> -		if (time_before(timeout, jiffies)) {
> +		if (time_before(jiffies, timeout)) {
>  			printk(KERN_WARNING "wanXL %s: timeout waiting for"
>  			       " PUTS to complete\n", pci_name(pdev));
>  			wanxl_pci_remove_one(pdev);
>

I can't see a bug here - time_before(timeout, jiffies) means "if
timeout is before jiffies", IOW if jiffies passed the timeout.

Perhaps time_after(jiffies, timeout) is a bit better equivalent, I
will use that.
-- 
Krzysztof Halasa
