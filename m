Return-Path: <linux-kernel-owner+w=401wt.eu-S1765557AbZDBKCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765557AbZDBKCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 06:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbZDBKCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 06:02:37 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:53492 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755361AbZDBKCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 06:02:36 -0400
Date: Thu, 2 Apr 2009 18:02:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       oliver@neukum.org
Subject: Re: [PATCH 1/2 V3] kaweth: Fix locking to be SMP-safe
Message-ID: <20090402100223.GA30905@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49d3881d.7EinO6dA2s6BnVTa%Larry.Finger@lwfinger.net>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
> @@ -796,7 +795,7 @@ static int kaweth_start_xmit(struct sk_b
> 
>        int res;
> 
> -       spin_lock(&kaweth->device_lock);
> +       spin_lock_irq(&kaweth->device_lock);

Should be irqsave unless you don't expect to be called via netpoll.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
