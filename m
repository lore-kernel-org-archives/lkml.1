Return-Path: <linux-kernel-owner+w=401wt.eu-S1030306AbXBGASL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030306AbXBGASL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 19:18:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030303AbXBGASL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 19:18:11 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:56660 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030289AbXBGASJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 19:18:09 -0500
Message-ID: <45C91ABF.9030504@pobox.com>
Date: Tue, 06 Feb 2007 19:18:07 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sky2: flow control off
References: <20070202153425.2d979fd4@freekitty>
In-Reply-To: <20070202153425.2d979fd4@freekitty>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> Turn flow control off for sky2. When flow control is on, the transmitter
> may get randomly stuck. Perhaps there is hardware problem, but until
> Marvell provides errata information for workaround, it should default to off.
> 
> Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
> ---
>  drivers/net/sky2.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
> index 822dd0b..a31dea5 100644
> --- a/drivers/net/sky2.c
> +++ b/drivers/net/sky2.c
> @@ -3263,7 +3263,7 @@ #endif
>  
>  	/* Auto speed and flow control */
>  	sky2->autoneg = AUTONEG_ENABLE;
> -	sky2->flow_mode = FC_BOTH;
> +	sky2->flow_mode = FC_NONE;

I ACK the patch... conditional on some -mm style testing and user ACKs.

Logic:  if there were no downsides to disabling flow control globally, 
the world's networks would have already done so.  Flow control can be 
quite helpful, so I while I understand the errata argument, I also want 
to understand the full effect of this tiny patch.

	Jeff



