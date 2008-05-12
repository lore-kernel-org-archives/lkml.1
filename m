Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbYELR3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbYELR3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 13:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbYELR32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 13:29:28 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:57131 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbYELR31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 13:29:27 -0400
Message-ID: <48287CE4.9050304@freescale.com>
Date: Mon, 12 May 2008 12:22:44 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Julia Lawall <julia@diku.dk>, netdev@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, vbordug@ru.mvista.com, jgarzik@pobox.com
Subject: Re: [PATCH 4/6] drivers/net/fs_enet: remove null pointer dereference
References: <Pine.LNX.4.64.0805121537590.3694@ask.diku.dk> <20080512165142.GC22190@electric-eye.fr.zoreil.com>
In-Reply-To: <20080512165142.GC22190@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu wrote:
> Julia Lawall <julia@diku.dk> :
> [...]
>> diff -u -p a/drivers/net/fs_enet/fs_enet-main.c b/drivers/net/fs_enet/fs_enet-main.c
>> --- a/drivers/net/fs_enet/fs_enet-main.c	2008-04-27 11:41:11.000000000 +0200
>> +++ b/drivers/net/fs_enet/fs_enet-main.c	2008-05-12 09:41:52.000000000 +0200
>> @@ -1093,7 +1093,7 @@ err:
>>  		if (registered)
>>  			unregister_netdev(ndev);
>>  
>> -		if (fep != NULL) {
>> +		if (fep && fep->ops) {
>>  			(*fep->ops->free_bd)(ndev);
>>  			(*fep->ops->cleanup_data)(ndev);
>>  		}
> 
> Extra cookies for the nice soul who:
> - removes the 'if (registered)' test (it can not happen)
> - uses different error lablels and unrolls the error path. I can not claim
>   that the current error path is wrong but it would not hurt if it was more
>   trivially balanced.
> 

Please note that this code is going away very soon, when arch/ppc dies.

-Scott
