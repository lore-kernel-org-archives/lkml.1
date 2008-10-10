Return-Path: <linux-kernel-owner+w=401wt.eu-S1762803AbYJJSxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762803AbYJJSxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 14:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759326AbYJJSxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 14:53:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41466
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758940AbYJJSxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 14:53:42 -0400
Date: Fri, 10 Oct 2008 11:53:18 -0700 (PDT)
Message-Id: <20081010.115318.85254002.davem@davemloft.net>
To: jirislaby@gmail.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, lrodriguez@atheros.com,
       jmalinen@atheros.com
Subject: Re: [PATCH 1/1] Ath9k: fix uninitialized value in ath9k_hw_reset
From: David Miller <davem@davemloft.net>
In-Reply-To: <1223661403-21803-1-git-send-email-jirislaby@gmail.com>
References: <1223661403-21803-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>
Date: Fri, 10 Oct 2008 19:56:43 +0200

> status ath9k_hw_reset() parameter should be set in every case, since
> it is used in callers to find out an error code.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
> Cc: Jouni Malinen <jmalinen@atheros.com>
> ---
>  drivers/net/wireless/ath9k/hw.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
> index 62e44a0..fb6727b 100644
> --- a/drivers/net/wireless/ath9k/hw.c
> +++ b/drivers/net/wireless/ath9k/hw.c
> @@ -5893,7 +5893,7 @@ bool ath9k_hw_reset(struct ath_hal *ah,
>  	}
>  
>  	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
> -		return false;
> +		FAIL(-EIO);
>  

This fix may be correct, but this is the first time I've noticed
these error status updating macros and they are super ugly.

I really think they should be removed.  Someone casually scanning
this code won't be able to discern the side effects and that makes
auditing harder and more error prone.
