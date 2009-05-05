Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbZEERVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbZEERVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 13:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbZEERVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 13:21:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:33233 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbZEERVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 13:21:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,298,1239001200"; 
   d="scan'208";a="512728293"
Subject: Re: [PATCH] iwl3945: fix ia64/ppc build
From: reinette chatre <reinette.chatre@intel.com>
To: Jan Beulich <jbeulich@novell.com>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A00525C.76EA.0078.0@novell.com>
References: <4A00525C.76EA.0078.0@novell.com>
Content-Type: text/plain
Date: Tue, 05 May 2009 10:27:29 -0700
Message-Id: <1241544449.6198.4.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan,

On Tue, 2009-05-05 at 05:51 -0700, Jan Beulich wrote:
> Exporting static and non-static symbols in the same compilation unit
> results, on some architectures, in section mismatch errors from the
> compiler. Since exporting static symbols is bogus altogether, simply
> remove the offending export. Once at it, also remove the other export
> commit df833b1d73680f9f9dc72cbc3215edbbc6ab740d pointlessly added.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Reinette Chatre <reinette.chatre@intel.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> 
> ---
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> --- linux-2.6.30-rc4/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-04-30 09:42:55.000000000 +0200
> +++ 2.6.30-rc4-iwl3945-build/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-05-05 14:25:43.000000000 +0200
> @@ -1694,7 +1694,6 @@ void iwl3945_rx_queue_reset(struct iwl_p
>  	rxq->free_count = 0;
>  	spin_unlock_irqrestore(&rxq->lock, flags);
>  }
> -EXPORT_SYMBOL(iwl3945_rx_queue_reset);
>  
>  /*
>   * this should be called while priv->lock is locked
> @@ -1745,7 +1744,6 @@ static void iwl3945_rx_queue_free(struct
>  	rxq->bd = NULL;
>  	rxq->rb_stts  = NULL;
>  }
> -EXPORT_SYMBOL(iwl3945_rx_queue_free);
>  
> 
>  /* Convert linear signal-to-noise ratio into dB */
> 
> 
> 

These changes are already queued for 2.6.30 in wireless-2.6 as commit
6269b731560d69c5eaa929909891edec39496d71 and
3ee59f8d0dcab2e114546038b2b224776c82b7f7

Reinette

