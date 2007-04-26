Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbXDZVJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbXDZVJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbXDZVJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:09:23 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:27834 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbXDZVJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:09:22 -0400
Subject: Re: [PATCH 1/3] ia64: convert to use clocksource code
From: Daniel Walker <dwalker@mvista.com>
To: Peter Keilty <peter.keilty@hp.com>
Cc: linux-ia64@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Eric Whitney <eric.whitney@hp.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070426202632.23343.54944.sendpatchset@rambler.zko.hp.com>
References: <20070426202632.23343.54944.sendpatchset@rambler.zko.hp.com>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 14:07:53 -0700
Message-Id: <1177621673.12796.121.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 16:26 -0400, Peter Keilty wrote:

> +        .mask           = (1LL << 40) - 1,
> +        .mult           = 0, /*to be caluclated*/
> +        .shift          = 16,
> +        .is_continuous  = 1,
>  };

You should use CLOCKSOURCE_MASK() here ..


>  
> diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> index daa4940..a20b4d6 100644
> --- a/include/linux/clocksource.h
> +++ b/include/linux/clocksource.h
> @@ -61,6 +61,9 @@ struct clocksource {
>  	u32 shift;
>  	unsigned long flags;
>  	cycle_t (*vread)(void);
> +#ifdef CONFIG_IA64
> +	void *fsys_mmio_ptr;	/* used by fsyscall asm code */
> +#endif

Could you explain in detail why this is needed?

Daniel

