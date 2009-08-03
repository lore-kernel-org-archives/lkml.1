Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbZHCSah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbZHCSah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbZHCSag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:30:36 -0400
Received: from mail.vyatta.com ([76.74.103.46]:46131 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbZHCSaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:30:35 -0400
Date: Mon, 3 Aug 2009 11:30:30 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: linux-kernel@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
Subject: Re: [PATCH 6/7] net: Add vbus_enet driver
Message-ID: <20090803113030.3092d5b0@nehalam>
In-Reply-To: <20090803171801.17268.93846.stgit@dev.haskins.net>
References: <20090803171030.17268.26962.stgit@dev.haskins.net>
	<20090803171801.17268.93846.stgit@dev.haskins.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Aug 2009 13:18:02 -0400
Gregory Haskins <ghaskins@novell.com> wrote:

> +
> +static const struct net_device_ops vbus_enet_netdev_ops = {
> +	.ndo_open          = vbus_enet_open,
> +	.ndo_stop          = vbus_enet_stop,
> +	.ndo_set_config    = vbus_enet_config,
> +	.ndo_start_xmit    = vbus_enet_tx_start,
> +	.ndo_change_mtu	   = vbus_enet_change_mtu,
> +	.ndo_tx_timeout    = vbus_enet_timeout,
> +};


Missing 
	.ndo_set_mac_address = eth_mac_addr,
	.ndo_validate_addr   = eth_validate_addr,

Also, should have change_mtu.

Suggest adding ethtool to report link and settings.

For performance this device should do scatter/gather, tso, gso, etc.
