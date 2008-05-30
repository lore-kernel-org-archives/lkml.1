Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbYE3IXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbYE3IXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 04:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYE3IWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 04:22:49 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:58564 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbYE3IWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 04:22:47 -0400
Date: Fri, 30 May 2008 01:22:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nadia.Derbey@bull.net
Cc: manfred@colorfullife.com, lnxninja@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org
Subject: Re: [PATCH 1/9] Change the idr structure
Message-ID: <20080530082241.GE4943@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080507113553.395937000@bull.net> <20080507113735.137310000@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507113735.137310000@bull.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 01:35:54PM +0200, Nadia.Derbey@bull.net wrote:
> [PATCH 01/09]
> 
> This patch adds an rcu_head to the idr_layer structure in order to free it
> after a grace period.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
> 
> ---
>  include/linux/idr.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6.25-mm1/include/linux/idr.h
> ===================================================================
> --- linux-2.6.25-mm1.orig/include/linux/idr.h	2008-05-06 17:14:24.000000000 +0200
> +++ linux-2.6.25-mm1/include/linux/idr.h	2008-05-06 17:20:58.000000000 +0200
> @@ -15,6 +15,7 @@
>  #include <linux/types.h>
>  #include <linux/bitops.h>
>  #include <linux/init.h>
> +#include <linux/rcupdate.h>
> 
>  #if BITS_PER_LONG == 32
>  # define IDR_BITS 5
> @@ -51,6 +52,7 @@ struct idr_layer {
>  	unsigned long		 bitmap; /* A zero bit means "space here" */
>  	struct idr_layer	*ary[1<<IDR_BITS];
>  	int			 count;	 /* When zero, we can release it */
> +	struct rcu_head		 rcu_head;
>  };
> 
>  struct idr {
> 
> --
