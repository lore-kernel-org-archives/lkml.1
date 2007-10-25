Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbXJYFK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbXJYFK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 01:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbXJYFKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 01:10:36 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41819 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbXJYFKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 01:10:34 -0400
Message-ID: <47202548.6040100@garzik.org>
Date: Thu, 25 Oct 2007 01:10:32 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] napi: use non-interruptible sleep in napi_disable
References: <20071025035920.C2D39DDECE@ozlabs.org>
In-Reply-To: <20071025035920.C2D39DDECE@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> The current napi_disable() uses msleep_interruptible() but doesn't
> (and can't) exit in case there's a signal, thus ending up doing a
> hot spin without a cpu_relax. Use uninterruptible sleep instead.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
>  include/linux/netdevice.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-work/include/linux/netdevice.h
> ===================================================================
> --- linux-work.orig/include/linux/netdevice.h	2007-10-17 12:39:16.000000000 +1000
> +++ linux-work/include/linux/netdevice.h	2007-10-17 12:45:00.000000000 +1000
> @@ -390,7 +390,7 @@ static inline void napi_complete(struct 
>  static inline void napi_disable(struct napi_struct *n)
>  {
>  	while (test_and_set_bit(NAPI_STATE_SCHED, &n->state))
> -		msleep_interruptible(1);
> +		msleep(1);
>  }

ACK


