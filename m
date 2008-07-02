Return-Path: <linux-kernel-owner+w=401wt.eu-S932408AbYGBLgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408AbYGBLgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbYGBLgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:36:03 -0400
Received: from smtprelay03.ispgateway.de ([80.67.18.15]:35839 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbYGBLgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:36:01 -0400
Message-ID: <486B681D.5030605@selhorst.net>
Date: Wed, 02 Jul 2008 13:35:57 +0200
From: Marcel Selhorst <tpm@selhorst.net>
User-Agent: Thunderbird 2.0.0.14 (X11/20080618)
MIME-Version: 1.0
To: Marcin Obara <marcin_obara@users.sourceforge.net>
CC: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tpm:correct tpm timeouts to jiffies conversion
References: <alpine.DEB.0.99.0806052204440.8295@ip-195-3-221-75.vnet.pl>
In-Reply-To: <alpine.DEB.0.99.0806052204440.8295@ip-195-3-221-75.vnet.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.1-5; AVE: 7.8.0.59; VDF: 7.0.5.34; host: mail)
X-Df-Sender: 174499
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Marcel Selhorst <tpm@selhorst.net>

Marcin Obara schrieb:
> This patch fixes timeouts conversion to jiffies,
> by replacing msecs_to_jiffies() calls with usecs_to_jiffies().
> According to TCG TPM Specification Version 1.2 Revision 103 (pages 166, 167)
> TPM timeouts and durations are returned in microseconds (usec)
> not in miliseconds (msec).
> 
> Signed-off-by: Marcin Obara <marcin_obara@users.sourceforge.net>
> 
> --- linux/drivers/char/tpm/tpm.c	2008-06-05 20:57:06.000000000 +0200
> +++ linux_tpm/drivers/char/tpm/tpm.c	2008-06-05 20:54:52.000000000 +0200
> @@ -524,19 +524,19 @@ void tpm_get_timeouts(struct tpm_chip *c
>  	timeout =
>  	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_1_IDX)));
>  	if (timeout)
> -		chip->vendor.timeout_a = msecs_to_jiffies(timeout);
> +		chip->vendor.timeout_a = usecs_to_jiffies(timeout);
>  	timeout =
>  	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_2_IDX)));
>  	if (timeout)
> -		chip->vendor.timeout_b = msecs_to_jiffies(timeout);
> +		chip->vendor.timeout_b = usecs_to_jiffies(timeout);
>  	timeout =
>  	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_3_IDX)));
>  	if (timeout)
> -		chip->vendor.timeout_c = msecs_to_jiffies(timeout);
> +		chip->vendor.timeout_c = usecs_to_jiffies(timeout);
>  	timeout =
>  	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_4_IDX)));
>  	if (timeout)
> -		chip->vendor.timeout_d = msecs_to_jiffies(timeout);
> +		chip->vendor.timeout_d = usecs_to_jiffies(timeout);
>  
>  duration:
>  	memcpy(data, tpm_cap, sizeof(tpm_cap));
> @@ -553,15 +553,15 @@ duration:
>  		return;
>  
>  	chip->vendor.duration[TPM_SHORT] =
> -	    msecs_to_jiffies(be32_to_cpu
> +	    usecs_to_jiffies(be32_to_cpu
>  			     (*((__be32 *) (data +
>  					    TPM_GET_CAP_RET_UINT32_1_IDX))));
>  	chip->vendor.duration[TPM_MEDIUM] =
> -	    msecs_to_jiffies(be32_to_cpu
> +	    usecs_to_jiffies(be32_to_cpu
>  			     (*((__be32 *) (data +
>  					    TPM_GET_CAP_RET_UINT32_2_IDX))));
>  	chip->vendor.duration[TPM_LONG] =
> -	    msecs_to_jiffies(be32_to_cpu
> +	    usecs_to_jiffies(be32_to_cpu
>  			     (*((__be32 *) (data +
>  					    TPM_GET_CAP_RET_UINT32_3_IDX))));
>  }
> 
