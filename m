Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab0BCCCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 21:02:06 -0500
Received: from mail.perches.com ([173.55.12.10]:1825 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270Ab0BCCCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 21:02:05 -0500
Subject: Re: [PATCH] seastar - SeaStar Ethernet driver (review comments
 addressed)
From: Joe Perches <joe@perches.com>
To: Kevin Pedretti <ktpedre@sandia.gov>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1265159307.15726.4.camel@hawkeye.sandia.gov>
References: <20100202205845.GE5246@hawkeye.sandia.gov>
	 <1265159307.15726.4.camel@hawkeye.sandia.gov>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 18:02:01 -0800
Message-ID: <1265162522.1945.148.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 18:08 -0700, Kevin Pedretti wrote:
> diff -uprN -X linux-2.6.32.7-vanilla/Documentation/dontdiff linux-2.6.32.7-vanilla/drivers/net/seastar/main.c linux-2.6.32.7/drivers/net/seastar/main.c
> --- linux-2.6.32.7-vanilla/drivers/net/seastar/main.c	1969-12-31 17:00:00.000000000 -0700
> +++ linux-2.6.32.7/drivers/net/seastar/main.c	2010-02-02 17:52:31.000000000 -0700
[]
> +static struct pending *alloc_tx_pending(struct ss_priv *ssp)
> +{
> +	struct pending *pending = ssp->tx_pending_free_list;
> +	if (!pending)
> +		return NULL;
> +
> +	ssp->tx_pending_free_list = pending->next;
> +	pending->next = 0;

kernel style doesn't like pointer assignments of 0.
NULL is preferred.

> +	/* Squash broadcast packets, SeaStar doesn't support broadcast */
> +	if (dest_lo_mac == 0xFF) {
> +		dev_err(&ssp->pdev->dev, "squashing broadcast packet.");
> +		return -1;
> +	}
 
Presumably SeaStar doesn't support multicast either, so maybe:
	if (dest_low_mac & 0x01)


