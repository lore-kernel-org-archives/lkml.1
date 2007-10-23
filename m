Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbXJWXPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbXJWXPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 19:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbXJWXPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 19:15:42 -0400
Received: from xenotime.net ([66.160.160.81]:39492 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752839AbXJWXPl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 19:15:41 -0400
Date: Tue, 23 Oct 2007 16:15:35 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 10/12] mac80211: fix warning created by BIT()
Message-Id: <20071023161535.a526d595.rdunlap@xenotime.net>
In-Reply-To: <20071023223645.421AB1F81B6@havoc.gtf.org>
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
	<20071023223645.421AB1F81B6@havoc.gtf.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007 18:36:45 -0400 (EDT) Jeff Garzik wrote:

> Now that BIT() forces unsigned long, this warning appears:
> 
> net/mac80211/ieee80211_sta.c: In function ‘ieee80211_rx_mgmt_assoc_resp’:
> net/mac80211/ieee80211_sta.c:1187: warning: format ‘%d’ expects type ‘int’, but argument 7 has type ‘long unsigned int’

LC_ALL=C make ...


> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
> 
> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index f7ffeec..bdfd901 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -1182,7 +1182,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
>  	aid = le16_to_cpu(mgmt->u.assoc_resp.aid);
>  
>  	printk(KERN_DEBUG "%s: RX %sssocResp from %s (capab=0x%x "
> -	       "status=%d aid=%d)\n",
> +	       "status=%d aid=%ld)\n",
>  	       dev->name, reassoc ? "Rea" : "A", print_mac(mac, mgmt->sa),
>  	       capab_info, status_code, aid & ~(BIT(15) | BIT(14)));
>  
> -

Patch was submitted yesterday by Johannes Berg, but does need to be
pushed by someone... (like this)


---
~Randy
