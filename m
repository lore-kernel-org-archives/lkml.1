Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbZJAAjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbZJAAjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 20:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbZJAAjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 20:39:21 -0400
Received: from mail.vyatta.com ([76.74.103.46]:40812 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139AbZJAAjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 20:39:20 -0400
Date: Wed, 30 Sep 2009 17:39:23 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Shreyas Bhatewara <sbhatewara@vmware.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Jeff Garzik <jgarzik@pobox.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       pv-drivers <pv-drivers@vmware.com>
Subject: Re: [PATCH 2.6.32-rc1] net: VMware virtual Ethernet NIC driver:
 vmxnet3
Message-ID: <20090930173923.4520716a@s6510>
In-Reply-To: <alpine.LRH.2.00.0909301432410.8073@localhost.localdomain>
References: <alpine.LRH.2.00.0909301432410.8073@localhost.localdomain>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009 14:34:57 -0700 (PDT)
Shreyas Bhatewara <sbhatewara@vmware.com> wrote:

Note: your patch was linewrapped again

> +
> +
> +static void
> +vmxnet3_declare_features(struct vmxnet3_adapter *adapter, bool dma64)
> +{
> +	struct net_device *netdev = adapter->netdev;
> +
> +	netdev->features = NETIF_F_SG |
> +		NETIF_F_HW_CSUM |
> +		NETIF_F_HW_VLAN_TX |
> +		NETIF_F_HW_VLAN_RX |
> +		NETIF_F_HW_VLAN_FILTER |
> +		NETIF_F_TSO |
> +		NETIF_F_TSO6;
> +
> +	printk(KERN_INFO "features: sg csum vlan jf tso tsoIPv6");
> +
> +	adapter->rxcsum = true;
> +	adapter->jumbo_frame = true;
> +
> +	if (!disable_lro) {
> +		adapter->lro = true;
> +		printk(" lro");
> +	}

Why not use NETIF_F_LRO and ethtool to control LRO support?
