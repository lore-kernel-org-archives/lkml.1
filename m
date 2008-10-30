Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbYJ3Bs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbYJ3Bs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 21:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756703AbYJ3BsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 21:48:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:27015 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbYJ3BsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 21:48:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Pr7y3VZcuU3vjWawRzouCYXE8A6gquqlDa5tWSvIW3OKqwSr0C6u4DDsHqfF9b6ylz
         Ik+/t+JKaBeqecCCHxByDqCmfKDnKPnGgmi+JH4lVQBGV42Shj/YHLtAyj1NLdyFzcHe
         KGxotFJ+NMNXJk/1yjs7gEJbxsbAAYfaVVoQM=
Subject: Re: mmc: struct device - replace bus_id with dev_name(),
 dev_set_name()
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
In-Reply-To: <1225329600.5970.72.camel@nga.site>
References: <1225329600.5970.72.camel@nga.site>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 18:48:04 -0700
Message-Id: <1225331284.5496.12.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 02:20 +0100, Kay Sievers wrote:
> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
> index ee6e822..403aa50 100644
> --- a/include/linux/mmc/card.h
> +++ b/include/linux/mmc/card.h
> @@ -130,7 +130,7 @@ struct mmc_card {
>  #define mmc_card_set_blockaddr(c) ((c)->state |= MMC_STATE_BLOCKADDR)
>  
>  #define mmc_card_name(c)	((c)->cid.prod_name)
> -#define mmc_card_id(c)		((c)->dev.bus_id)
> +#define mmc_card_id(c)		(dev_name(&(c)->dev))
>  
>  #define mmc_list_to_card(l)	container_of(l, struct mmc_card, node)
>  #define mmc_get_drvdata(c)	dev_get_drvdata(&(c)->dev)
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index bde891f..f842f23 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -176,7 +176,7 @@ static inline void *mmc_priv(struct mmc_host *host)
>  
>  #define mmc_dev(x)	((x)->parent)
>  #define mmc_classdev(x)	(&(x)->class_dev)
> -#define mmc_hostname(x)	((x)->class_dev.bus_id)
> +#define mmc_hostname(x)	(dev_name(&(x)->class_dev))
>  
>  extern int mmc_suspend_host(struct mmc_host *, pm_message_t);
>  extern int mmc_resume_host(struct mmc_host *);
> diff --git a/include/linux/mmc/sdio_func.h b/include/linux/mmc/sdio_func.h
> index 07bee4a..451bdfc 100644
> --- a/include/linux/mmc/sdio_func.h
> +++ b/include/linux/mmc/sdio_func.h
> @@ -63,7 +63,7 @@ struct sdio_func {
>  
>  #define sdio_func_set_present(f) ((f)->state |= SDIO_STATE_PRESENT)
>  
> -#define sdio_func_id(f)		((f)->dev.bus_id)
> +#define sdio_func_id(f)		(dev_name(&(f)->dev))
>  
>  #define sdio_get_drvdata(f)	dev_get_drvdata(&(f)->dev)
>  #define sdio_set_drvdata(f,d)	dev_set_drvdata(&(f)->dev, d)
> 

A lot of these helpers don't seem to add that much, would you care for
a patch removing them Pierre?

Specifically sdio_func_id, sdio_get/set_drvdata don't have that many
users.

mmc_hostname has a lot of users, but if you're agreeable, I could
take a crack at that too.

Harvey

