Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbZDOSiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbZDOSiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 14:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbZDOSiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 14:38:11 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:44410 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbZDOSiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 14:38:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=elctF2FkURfYYY/wSD/4PK5VfalrA56Hnb1se+GWWqBBwX2hKh1TsnXjaC9uh5UwHJ
         MBtu7KWFEuApu+kJ0LV8f1ck0duEYU6feRvs/yw0dRmBAA5+frB005o9dKk8xqll0Ihk
         Bh6u0jYcxCruC7mwhTcufKwuj0R7ooRXqcDSU=
Message-ID: <49E6295F.80009@gmail.com>
Date: Wed, 15 Apr 2009 20:37:19 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
CC: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phylib: Fix delay argument of schedule_delayed_work
References: <1239811551-6101-1-git-send-email-anemo@mba.ocn.ne.jp>
In-Reply-To: <1239811551-6101-1-git-send-email-anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atsushi Nemoto wrote:
> The commit a390d1f3 ("phylib: convert state_queue work to
> delayed_work") missed converting 'expires' value to 'delay' value.

Yeah, sorry about that.

> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Acked-by: Marcin Slusarz <marcin.slusarz@gmail.com>

> ---
>  drivers/net/phy/phy.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index 3ff1f42..5737b85 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -434,7 +434,7 @@ void phy_start_machine(struct phy_device *phydev,
>  	phydev->adjust_state = handler;
>  
>  	INIT_DELAYED_WORK(&phydev->state_queue, phy_state_machine);
> -	schedule_delayed_work(&phydev->state_queue, jiffies + HZ);
> +	schedule_delayed_work(&phydev->state_queue, HZ);
>  }
>  
>  /**
> @@ -937,6 +937,5 @@ static void phy_state_machine(struct work_struct *work)
>  	if (err < 0)
>  		phy_error(phydev);
>  
> -	schedule_delayed_work(&phydev->state_queue,
> -				jiffies + PHY_STATE_TIME * HZ);
> +	schedule_delayed_work(&phydev->state_queue, PHY_STATE_TIME * HZ);
>  }

