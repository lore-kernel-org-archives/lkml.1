Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbZLWRrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbZLWRrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 12:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZLWRrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 12:47:51 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:36825 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbZLWRrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 12:47:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wcCdvpWJqQLVjw5pKIBdrNkr+dPsI9MDF0ftHrfZs420r1vDzDKWRj4uH8zyTafDd1
         dP+3mvtPJljGfKOFrcpNWJgF09K7JCsBuxr+Y1VgHMoPmgAdPVWr6j8Han9Pj2AV5JcU
         05VNytBdffns2OlCRah5t5kEpf7q8LFqnNQ6M=
Message-ID: <4B3257C2.2050500@gmail.com>
Date: Wed, 23 Dec 2009 18:47:46 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] hamradio: avoid null deref
References: <20091223132550.GD17923@bicker>
In-Reply-To: <20091223132550.GD17923@bicker>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter wrote, On 12/23/2009 02:25 PM:

> If dev == NULL we shouldn't dereference it.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> --- orig/drivers/net/hamradio/bpqether.c	2009-12-22 23:58:56.000000000 +0200
> +++ devel/drivers/net/hamradio/bpqether.c	2009-12-22 23:59:46.000000000 +0200
> @@ -283,7 +283,6 @@ static netdev_tx_t bpq_xmit(struct sk_bu
>  	bpq = netdev_priv(dev);
>  
>  	if ((dev = bpq_get_ether_dev(dev)) == NULL) {
> -		dev->stats.tx_dropped++;

Why not use a separate variable for another dev? This stat
should be helpful for debugging.

Jarek P.

>  		kfree_skb(skb);
>  		return NETDEV_TX_OK;
>  	}


