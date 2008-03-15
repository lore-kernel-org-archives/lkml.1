Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369AbYCOWQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbYCOWQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 18:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbYCOWQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 18:16:20 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:65136 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbYCOWQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 18:16:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=dbPWqnno5XqIopamcRNO/YVE4ZUinrMr5iTt1g9Ma+QddAUoCg6zZCgH9OkzC1NEiNbjPuwrU32CzjFzAssgopOveKV3onWBI6cJ22QMCsYJcESCagB1hpr4gIK5Qq1ynO04eidBUWoNhhz3KyAutlBHWFQJ2J7qYgOdXwF+FBw=
Date: Sat, 15 Mar 2008 17:16:09 -0500
From: Jay Cliburn <jcliburn@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: csnook@redhat.com, atl1-devel@lists.sourceforge.net, jgarzik@pobox.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/7] drivers/net/atl1/atl1_main.c: remove unused
 variable
Message-ID: <20080315171609.05db507b@osprey.hogchain.net>
In-Reply-To: <Pine.LNX.4.64.0803151704400.24178@ask.diku.dk>
References: <Pine.LNX.4.64.0803151704400.24178@ask.diku.dk>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Mar 2008 17:05:02 +0100 (CET)
Julia Lawall <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> The variable update_rx is initialized but never used otherwise.
> 
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> type T;
> identifier i;
> constant C;
> @@
> 
> (
> extern T i;
> |
> - T i;
>   <+... when != i
> - i = C;
>   ...+>
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Jay Cliburn <jacliburn@bellsouth.net>

> ---
>  drivers/net/atl1/atl1_main.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> diff -u -p a/drivers/net/atl1/atl1_main.c
> b/drivers/net/atl1/atl1_main.c ---
> a/drivers/net/atl1/atl1_main.c	2008-03-12 14:13:13.000000000
> +0100 +++ b/drivers/net/atl1/atl1_main.c	2008-03-15
> 16:18:08.000000000 +0100 @@ -1765,15 +1765,12 @@ static irqreturn_t
> atl1_intr(int irq, vo { struct atl1_adapter *adapter =
> netdev_priv(data); u32 status;
> -	u8 update_rx;
>  	int max_ints = 10;
>  
>  	status = adapter->cmb.cmb->int_stats;
>  	if (!status)
>  		return IRQ_NONE;
>  
> -	update_rx = 0;
> -
>  	do {
>  		/* clear CMB interrupt status at once */
>  		adapter->cmb.cmb->int_stats = 0;
