Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbZKRGtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbZKRGtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 01:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbZKRGtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 01:49:12 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:42596 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbZKRGtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 01:49:12 -0500
Message-ID: <4B0398D4.8030904@gmail.com>
Date: Wed, 18 Nov 2009 07:48:52 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick McHardy <kaber@trash.net>,
       Patrick Mullaney <pmullaney@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Edge Virtual Bridging <evb@yahoogroups.com>,
       Anna Fischer <anna.fischer@hp.com>, bridge@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.com,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>
Subject: Re: [PATCH 3/3] macvlan: export macvlan mode through netlink
References: <1258497551-25959-1-git-send-email-arnd@arndb.de> <1258497551-25959-4-git-send-email-arnd@arndb.de>
In-Reply-To: <1258497551-25959-4-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 18 Nov 2009 07:48:53 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann a écrit :
> In order to support all three modes of macvlan at
> runtime, extend the existing netlink protocol
> to allow choosing the mode per macvlan slave
> interface.
> 
> This depends on a matching patch to iproute2
> in order to become accessible in user land.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/macvlan.c   |   67 +++++++++++++++++++++++++++++++++++++++++-----
>  include/linux/if_link.h |   15 ++++++++++
>  2 files changed, 74 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
> index fa8b568..731017e 100644
> --- a/drivers/net/macvlan.c
> +++ b/drivers/net/macvlan.c
> @@ -33,12 +33,6 @@
>  
>  #define MACVLAN_HASH_SIZE	(1 << BITS_PER_BYTE)
>  
> -enum macvlan_type {
> -	MACVLAN_PRIVATE		= 1,
> -	MACVLAN_VEPA		= 2,
> -	MACVLAN_BRIDGE		= 4,
> -};

I realize you defined MACVLAN_PRIVATE in patch 2, but used MACVLAN_MODE_PRIVATE,
so patch 2 is not compilable and breaks bisection ?


> +
> +enum ifla_macvlan_mode {
> +	MACVLAN_MODE_PRIVATE = 1, /* don't talk to other macvlans */
> +	MACVLAN_MODE_VEPA    = 2, /* talk to other ports through ext bridge */
> +	MACVLAN_MODE_BRIDGE  = 4, /* talk to bridge ports directly */
> +};
