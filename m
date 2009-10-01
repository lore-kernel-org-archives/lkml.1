Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbZJABSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbZJABSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 21:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbZJABSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 21:18:54 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:40794 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755300AbZJABSx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 21:18:53 -0400
From: Shreyas Bhatewara <sbhatewara@vmware.com>
To: Stephen Hemminger <shemminger@vyatta.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Jeff Garzik <jgarzik@pobox.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       pv-drivers <pv-drivers@vmware.com>
Date: Wed, 30 Sep 2009 18:18:49 -0700
Subject: RE: [PATCH 2.6.32-rc1] net: VMware virtual Ethernet NIC driver:
 vmxnet3
Thread-Topic: [PATCH 2.6.32-rc1] net: VMware virtual Ethernet NIC driver:
 vmxnet3
Thread-Index: AcpCL6D6ZZTGOF+qTfe9R/LTkaJaiQABLmLg
Message-ID: <89E2752CFA8EC044846EB849981913410173DCE285@EXCH-MBX-4.vmware.com>
References: <alpine.LRH.2.00.0909301432410.8073@localhost.localdomain>
 <20090930173923.4520716a@s6510>
In-Reply-To: <20090930173923.4520716a@s6510>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

Thanks for taking a look.



> -----Original Message-----
> From: Stephen Hemminger [mailto:shemminger@vyatta.com]
> Sent: Wednesday, September 30, 2009 5:39 PM
> To: Shreyas Bhatewara
> Cc: linux-kernel; netdev; Stephen Hemminger; David S. Miller; Jeff
> Garzik; Anthony Liguori; Chris Wright; Greg Kroah-Hartman; Andrew
> Morton; virtualization; pv-drivers
> Subject: Re: [PATCH 2.6.32-rc1] net: VMware virtual Ethernet NIC
> driver: vmxnet3
> 
> On Wed, 30 Sep 2009 14:34:57 -0700 (PDT)
> Shreyas Bhatewara <sbhatewara@vmware.com> wrote:
> 
> Note: your patch was linewrapped again
> 

Fixed the alpine option. Should not happen again.

> > +
> > +
> > +static void
> > +vmxnet3_declare_features(struct vmxnet3_adapter *adapter, bool
> dma64)
> > +{
> > +	struct net_device *netdev = adapter->netdev;
> > +
> > +	netdev->features = NETIF_F_SG |
> > +		NETIF_F_HW_CSUM |
> > +		NETIF_F_HW_VLAN_TX |
> > +		NETIF_F_HW_VLAN_RX |
> > +		NETIF_F_HW_VLAN_FILTER |
> > +		NETIF_F_TSO |
> > +		NETIF_F_TSO6;
> > +
> > +	printk(KERN_INFO "features: sg csum vlan jf tso tsoIPv6");
> > +
> > +	adapter->rxcsum = true;
> > +	adapter->jumbo_frame = true;
> > +
> > +	if (!disable_lro) {
> > +		adapter->lro = true;
> > +		printk(" lro");
> > +	}
> 
> Why not use NETIF_F_LRO and ethtool to control LRO support?

Yes, that would be a better way to do it. I will make that change.



