Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbYDADtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbYDADtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 23:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYDADtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 23:49:10 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:42994 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbYDADtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 23:49:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=IwbXlTrUNFSolUYkDwH82jJtOWP0s5HXpUyOumc9qdyOvFCPIGRLCbJ0vjAvg0l2pWdQDlDUy6dnrD7U4/UbDXIgsxPoLIStRAHPH5Y5epBfAlU7glziTqlb5H6hfUmTGCgPbU7+HT8WOiFP2p0C8++PAfqZe0gCbM+NKiesBLM=
Date: Mon, 31 Mar 2008 23:49:03 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix tosakbd suspend
Message-ID: <20080401034903.GB18041@anvil.corenet.prv>
References: <20080331213801.GA9372@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331213801.GA9372@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Tue, Apr 01, 2008 at 01:38:01AM +0400, Dmitry Baryshkov wrote:
> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> ---
>  drivers/input/keyboard/tosakbd.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/keyboard/tosakbd.c b/drivers/input/keyboard/tosakbd.c
> index 3884d1e..306cbe8 100644
> --- a/drivers/input/keyboard/tosakbd.c
> +++ b/drivers/input/keyboard/tosakbd.c
> @@ -210,6 +210,9 @@ static int tosakbd_suspend(struct platform_device *dev, pm_message_t state)
>  
>  	del_timer_sync(&tosakbd->timer);
>  

What if interrupt comes here? The whole suspend path seems racy with
interrup handler/timer.

> +	PGSR1 = (PGSR1 & ~TOSA_GPIO_LOW_STROBE_BIT);
> +	PGSR2 = (PGSR2 & ~TOSA_GPIO_HIGH_STROBE_BIT);
> +
>  	return 0;
>  }
>  

-- 
Dmitry
