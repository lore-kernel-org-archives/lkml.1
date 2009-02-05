Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZBEWhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZBEWhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZBEWhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:37:45 -0500
Received: from tundra.namei.org ([65.99.196.166]:3921 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbZBEWho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:37:44 -0500
Date: Fri, 6 Feb 2009 09:37:01 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, serue@us.ibm.com,
       safford@watson.ibm.com, Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH] TPM: integrity fix
In-Reply-To: <1233846390-21146-1-git-send-email-srajiv@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.1.10.0902060936560.13175@tundra.namei.org>
References: <1233846390-21146-1-git-send-email-srajiv@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009, Rajiv Andrade wrote:

> Fix to function which is called by IMA, now tpm_chip_find_get() considers the case in which the machine doesn't have a TPM or, if it has, its TPM isn't enabled.

Applied.

> 
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> ---
>  drivers/char/tpm/tpm.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index 0387965..912a473 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -666,18 +666,20 @@ EXPORT_SYMBOL_GPL(tpm_show_temp_deactivated);
>   */
>  static struct tpm_chip *tpm_chip_find_get(int chip_num)
>  {
> -	struct tpm_chip *pos;
> +	struct tpm_chip *pos, *chip = NULL;
>  
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(pos, &tpm_chip_list, list) {
>  		if (chip_num != TPM_ANY_NUM && chip_num != pos->dev_num)
>  			continue;
>  
> -		if (try_module_get(pos->dev->driver->owner))
> +		if (try_module_get(pos->dev->driver->owner)) {
> +			chip = pos;
>  			break;
> +		}
>  	}
>  	rcu_read_unlock();
> -	return pos;
> +	return chip;
>  }
>  
>  #define TPM_ORDINAL_PCRREAD cpu_to_be32(21)
> -- 
> 1.5.6.3
> 

-- 
James Morris
<jmorris@namei.org>
