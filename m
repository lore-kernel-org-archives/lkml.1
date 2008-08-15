Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbYHOXlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbYHOXlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 19:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbYHOXlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 19:41:35 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:46657 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbYHOXle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 19:41:34 -0400
Message-ID: <21849002.1218843677714.JavaMail.oracle@acsmt301.oracle.com>
Date: Fri, 15 Aug 2008 18:41:17 -0500 (CDT)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Miller <davem@davemloft.net>
Subject: Re: linux-next: Tree for August 15 (bnx2) [resend/lost]
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
In-Reply-To: <20080815.151715.111675039.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
References: <20080815184032.3acd8032.sfr@canb.auug.org.au>
	<20080815084116.340ac526.randy.dunlap@oracle.com> <20080815.151715.111675039.davem@davemloft.net>
X-Priority: 3
X-Mailer: Oracle Webmail Client(UIX)
Content-Language: en-US
Accept-Language: en-US
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Original Message ---
> From: Randy Dunlap <randy.dunlap@oracle.com>
> Date: Fri, 15 Aug 2008 08:41:16 -0700
> 
> > When VLAN is not enabled, bnx2 build fails with:
> > 
> > drivers/net/bnx2.c: In function 'bnx2_rx_int':
> > drivers/net/bnx2.c:2959: error: dereferencing pointer to incomplete type
> > drivers/net/bnx2.c:2960: error: dereferencing pointer to incomplete type
> > make[2]: *** [drivers/net/bnx2.o] Error 1
> 
> Does this fix it for you?

Yes, it does.  Thanks.

> diff --git a/drivers/net/bnx2.c b/drivers/net/bnx2.c
> index d454810..2486a65 100644
> --- a/drivers/net/bnx2.c
> +++ b/drivers/net/bnx2.c
> @@ -35,8 +35,8 @@
>  #include <linux/time.h>
>  #include <linux/ethtool.h>
>  #include <linux/mii.h>
> -#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
>  #include <linux/if_vlan.h>
> +#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
>  #define BCM_VLAN 1
>  #endif
>  #include <net/ip.h>

