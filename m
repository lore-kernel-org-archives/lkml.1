Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935753Ab0BZJjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:39:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40471
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935695Ab0BZJjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 04:39:52 -0500
Date: Fri, 26 Feb 2010 01:40:10 -0800 (PST)
Message-Id: <20100226.014010.239722623.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/7] drivers/net/chelsio: Use pr_<level>,
 netif_msg_<type>
From: David Miller <davem@davemloft.net>
In-Reply-To: <819e937a3feefb278c2816db2947eff95dd6740a.1266893507.git.joe@perches.com>
References: <cover.1266893507.git.joe@perches.com>
	<819e937a3feefb278c2816db2947eff95dd6740a.1266893507.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 22 Feb 2010 18:56:57 -0800

> Convert CH_<level> and CH_DBG uses to pr_<level> and netif equivalents
> Remove CH_<level> and CH_DBG macro definitions
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.

BTW:

> @@ -734,8 +734,9 @@ int t1_elmer0_ext_intr_handler(adapter_t *adapter)
>  		break;
>  	case CHBT_BOARD_8000:
>  	case CHBT_BOARD_CHT110:
> -		CH_DBG(adapter, INTR, "External interrupt cause 0x%x\n",
> -		       cause);
> +		if (netif_msg_intr(adapter))
> +			dev_dbg(&adapter->pdev->dev, 

Trailing whitespace on that last line.  I fixed it up when
adding the patch to my tree.

