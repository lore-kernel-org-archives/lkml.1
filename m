Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbYGaKnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbYGaKnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbYGaKmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:42:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35387 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbYGaKmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:42:51 -0400
Subject: Re: [patch 3/4] Configure out ethtool support
From: David Woodhouse <dwmw2@infradead.org>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, Matt Mackall <mpm@selenic.com>,
       jgarzik@pobox.com, netdev@vger.kernel.org, davem@davemloft.net,
       akpm@linux-foundation.org
In-Reply-To: <20080731093221.236840420@free-electrons.com>
References: <20080731092703.661994657@free-electrons.com>
	 <20080731093221.236840420@free-electrons.com>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 11:42:47 +0100
Message-Id: <1217500967.3454.140.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-31 at 11:27 +0200, Thomas Petazzoni wrote:
> 
> +#else
> +static inline u32 ethtool_op_get_link(struct net_device *dev) { return 0; }
> +static inline u32 ethtool_op_get_tx_csum(struct net_device *dev) { return 0; }
> +static inline int ethtool_op_set_tx_csum(struct net_device *dev, u32 data) { return 0; }
> +static inline int ethtool_op_set_tx_hw_csum(struct net_device *dev, u32 data) { return 0; }
> +static inline int ethtool_op_set_tx_ipv6_csum(struct net_device *dev, u32 data) { return 0; }
> +static inline u32 ethtool_op_get_sg(struct net_device *dev) { return 0; }
> +static inline int ethtool_op_set_sg(struct net_device *dev, u32 data) { return 0; }
> +static inline u32 ethtool_op_get_tso(struct net_device *dev) { return 0; }
> +static inline int ethtool_op_set_tso(struct net_device *dev, u32 data) { return 0; }
> +static inline u32 ethtool_op_get_ufo(struct net_device *dev) { return 0; }
> +static inline int ethtool_op_set_ufo(struct net_device *dev, u32 data) { return 0; }
> +static inline u32 ethtool_op_get_flags(struct net_device *dev) { return 0; }
> +static inline int ethtool_op_set_flags(struct net_device *dev, u32 data) { return 0; }
> +#endif

It's alleged that these functions are called from 'core' network code in
some places, although I can't actually see any evidence of that anywhere
in Linus' tree except for vlans and bridging.

If that's actually the case, perhaps it makes sense to add a
WARN_ON_ONCE() to these empty functions, so that a developer who
disables CONFIG_ETHTOOL when they shouldn't will see a nasty warning
about it rather than a silent failure?

Btw, I see you've made bridging 'select ETHTOOL'; did you do the same
for vlan support?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



