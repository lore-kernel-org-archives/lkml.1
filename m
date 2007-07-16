Return-Path: <linux-kernel-owner+w=401wt.eu-S1764806AbXGPRLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764806AbXGPRLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 13:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbXGPRLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 13:11:13 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:48096 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbXGPRLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 13:11:12 -0400
Date: Tue, 17 Jul 2007 02:11:53 +0900 (JST)
Message-Id: <20070717.021153.74661454.yoshfuji@linux-ipv6.org>
To: bryan.wu@analog.com
Cc: michael.hennerich@analog.com, mb@bu3sch.de, vapier.adi@gmail.com,
       jeff@garzik.org, hch@infradead.org, dcbw@redhat.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, joe@perches.com, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH try#5] Blackfin ethernet driver: on chip ethernet MAC
 controller driver
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <1184604542.6107.44.camel@roc-laptop>
References: <1184604542.6107.44.camel@roc-laptop>
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

In article <1184604542.6107.44.camel@roc-laptop> (at Tue, 17 Jul 2007 00:49:02 +0800), Bryan Wu <bryan.wu@analog.com> says:

> +static void bf537mac_set_multicast_list(struct net_device *dev)
> +{
> +	u32 sysctl;
> +
> +	if (dev->flags & IFF_PROMISC) {
> +		printk(KERN_INFO "%s: set to promisc mode\n", dev->name);
> +		sysctl = bfin_read_EMAC_OPMODE();
> +		sysctl |= RAF;
> +		bfin_write_EMAC_OPMODE(sysctl);
> +	} else if (dev->flags & IFF_ALLMULTI || dev->mc_count > 16) {
> +		/* accept all multicast */
> +		sysctl = bfin_read_EMAC_OPMODE();
> +		sysctl |= PAM;
> +		bfin_write_EMAC_OPMODE(sysctl);
> +	} else if (dev->mc_count) {
> +		/* set multicast */
> +	} else {
> +		/* clear promisc or multicast mode */
> +		sysctl = bfin_read_EMAC_OPMODE();
> +		sysctl &= ~(RAF | PAM);
> +		bfin_write_EMAC_OPMODE(sysctl);
> +	}
> +}
> +

Is this function really correct?

Please make sure to set up multicast list on device, or
set "all multi" on device if you do not know what to do; e.g.

static void bf537mac_set_multicast_list(struct net_device *dev)
{
     u32 sysctl;

     if (dev->flags & IFF_PROMISC) {
             printk(KERN_INFO "%s: set to promisc mode\n", dev->name);
             sysctl = bfin_read_EMAC_OPMODE();
             sysctl |= RAF;
             bfin_write_EMAC_OPMODE(sysctl);
     } else if (dev->flags & IFF_ALLMULTI || dev->mc_count) {
             /* accept all multicast */
             sysctl = bfin_read_EMAC_OPMODE();
             sysctl |= PAM;
             bfin_write_EMAC_OPMODE(sysctl);
     } else {
             /* clear promisc or multicast mode */
             sysctl = bfin_read_EMAC_OPMODE();
             sysctl &= ~(RAF | PAM);
             bfin_write_EMAC_OPMODE(sysctl);
     }
}
--yoshfuji
