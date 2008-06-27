Return-Path: <linux-kernel-owner+w=401wt.eu-S1758986AbYF0WId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986AbYF0WId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 18:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757967AbYF0WH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:07:58 -0400
Received: from curtis.curtisfong.org ([66.43.110.51]:58559 "EHLO
	curtis.curtisfong.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757624AbYF0WHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:07:54 -0400
Date: Fri, 27 Jun 2008 15:07:49 -0700
From: Nye Liu <nyet@nyet.org>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] FS_ENET: Don't attempt to set mii_speed when fec_inf
	is null
Message-ID: <20080627220749.GA3046@curtisfong.org>
References: <20080627192651.GA28291@curtisfong.org> <48655BAC.8080800@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48655BAC.8080800@ru.mvista.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry!

diff --git a/drivers/net/fs_enet/mac-fec.c b/drivers/net/fs_enet/mac-fec.c
index 8a311d1..7359068 100644
--- a/drivers/net/fs_enet/mac-fec.c
+++ b/drivers/net/fs_enet/mac-fec.c
@@ -328,7 +328,8 @@ static void restart(struct net_device *dev)
 	/*
 	 * Set MII speed.
 	 */
-	FW(fecp, mii_speed, fec_inf->mii_speed);
+	if (fec_inf)
+		FW(fecp, mii_speed, fec_inf->mii_speed);
 
 	/*
 	 * Clear any outstanding interrupt.

On Sat, Jun 28, 2008 at 01:29:16AM +0400, Sergei Shtylyov wrote:
> Hello.
>
> Nye Liu wrote:
>> From: Nye Liu <nyet@mrv.com>
>>
>> When using CONFIG_FIXED_PHY, fec_inf (fep->phydev->bus->priv) is NULL in
>> fs_enet/mac-fec.c restart(). Dereferencing fec_inf when trying to set the
>> mii_speed causes a kernel oops.
>>
>> Signed-off-by: Nye Liu <nyet@mrv.com>
>>
>> ---
>>
>> diff --git a/drivers/net/fs_enet/mac-fec.c b/drivers/net/fs_enet/mac-fec.c
>> index 8a311d1..350bc73 100644
>> --- a/drivers/net/fs_enet/mac-fec.c
>> +++ b/drivers/net/fs_enet/mac-fec.c
>> @@ -328,7 +328,8 @@ static void restart(struct net_device *dev)
>>         /*
>>          * Set MII speed.
>>          */
>> -       FW(fecp, mii_speed, fec_inf->mii_speed);
>> +       if (fec_inf)
>> +           FW(fecp, mii_speed, fec_inf->mii_speed);
>>   
>
>   Alas, Your patch is whitespace damaged.
>
>
> WBR, Sergei
>
>
