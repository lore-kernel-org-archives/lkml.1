Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbYELRPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbYELRPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 13:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbYELRPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 13:15:17 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:38005 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754031AbYELRPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 13:15:15 -0400
Date: Mon, 12 May 2008 18:51:42 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Julia Lawall <julia@diku.dk>
Cc: pantelis.antoniou@gmail.com, vbordug@ru.mvista.com,
       linuxppc-dev@ozlabs.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       jgarzik@pobox.com
Subject: Re: [PATCH 4/6] drivers/net/fs_enet: remove null pointer
	dereference
Message-ID: <20080512165142.GC22190@electric-eye.fr.zoreil.com>
References: <Pine.LNX.4.64.0805121537590.3694@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805121537590.3694@ask.diku.dk>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <julia@diku.dk> :
[...]
> diff -u -p a/drivers/net/fs_enet/fs_enet-main.c b/drivers/net/fs_enet/fs_enet-main.c
> --- a/drivers/net/fs_enet/fs_enet-main.c	2008-04-27 11:41:11.000000000 +0200
> +++ b/drivers/net/fs_enet/fs_enet-main.c	2008-05-12 09:41:52.000000000 +0200
> @@ -1093,7 +1093,7 @@ err:
>  		if (registered)
>  			unregister_netdev(ndev);
>  
> -		if (fep != NULL) {
> +		if (fep && fep->ops) {
>  			(*fep->ops->free_bd)(ndev);
>  			(*fep->ops->cleanup_data)(ndev);
>  		}

Extra cookies for the nice soul who:
- removes the 'if (registered)' test (it can not happen)
- uses different error lablels and unrolls the error path. I can not claim
  that the current error path is wrong but it would not hurt if it was more
  trivially balanced.

-- 
Ueimor
