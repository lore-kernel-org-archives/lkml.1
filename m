Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbXJCV6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbXJCV6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 17:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755901AbXJCV6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 17:58:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33320
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753559AbXJCV6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 17:58:08 -0400
Date: Wed, 03 Oct 2007 14:58:07 -0700 (PDT)
Message-Id: <20071003.145807.111205634.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@linux-foundation.org, jdike@addtoit.com
Subject: Re: [PATCH] net: fix race in process_backlog
From: David Miller <davem@davemloft.net>
In-Reply-To: <1191426293.5599.27.camel@lappy>
References: <1191426293.5599.27.camel@lappy>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed, 03 Oct 2007 17:44:53 +0200

> Index: linux-2.6/net/core/dev.c
> ===================================================================
> --- linux-2.6.orig/net/core/dev.c
> +++ linux-2.6/net/core/dev.c
> @@ -2095,11 +2095,11 @@ static int process_backlog(struct napi_s
>  
>  		local_irq_disable();
>  		skb = __skb_dequeue(&queue->input_pkt_queue);
> -		local_irq_enable();
>  		if (!skb) {
> -			napi_complete(napi);
> +			__napi_complete(napi);
>  			break;
>  		}
> +		local_irq_enable();

What re-enables interrupts in the !skb path?
