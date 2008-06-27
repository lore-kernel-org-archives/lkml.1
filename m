Return-Path: <linux-kernel-owner+w=401wt.eu-S1762457AbYF0V3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762457AbYF0V3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758628AbYF0V3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:29:24 -0400
Received: from h155.mvista.com ([63.81.120.155]:61224 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758583AbYF0V3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:29:23 -0400
Message-ID: <48655BAC.8080800@ru.mvista.com>
Date: Sat, 28 Jun 2008 01:29:16 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Nye Liu <nyet@nyet.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] FS_ENET: Don't attempt to set mii_speed when fec_inf
 is null
References: <20080627192651.GA28291@curtisfong.org>
In-Reply-To: <20080627192651.GA28291@curtisfong.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Nye Liu wrote:
> From: Nye Liu <nyet@mrv.com>
>
> When using CONFIG_FIXED_PHY, fec_inf (fep->phydev->bus->priv) is NULL in
> fs_enet/mac-fec.c restart(). Dereferencing fec_inf when trying to set the
> mii_speed causes a kernel oops.
>
> Signed-off-by: Nye Liu <nyet@mrv.com>
>
> ---
>
> diff --git a/drivers/net/fs_enet/mac-fec.c b/drivers/net/fs_enet/mac-fec.c
> index 8a311d1..350bc73 100644
> --- a/drivers/net/fs_enet/mac-fec.c
> +++ b/drivers/net/fs_enet/mac-fec.c
> @@ -328,7 +328,8 @@ static void restart(struct net_device *dev)
>         /*
>          * Set MII speed.
>          */
> -       FW(fecp, mii_speed, fec_inf->mii_speed);
> +       if (fec_inf)
> +           FW(fecp, mii_speed, fec_inf->mii_speed);
>   

   Alas, Your patch is whitespace damaged.


WBR, Sergei


