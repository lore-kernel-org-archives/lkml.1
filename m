Return-Path: <linux-kernel-owner+w=401wt.eu-S932346AbXBWNrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346AbXBWNrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 08:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932365AbXBWNrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 08:47:43 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:2556 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932346AbXBWNrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 08:47:42 -0500
Date: Fri, 23 Feb 2007 08:47:06 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Markku Savela <msa@moth.iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ipv4 and ipv6 stacks for new link layers?
Message-ID: <20070223134706.GA24864@hmsreliant.homelinux.net>
References: <200702231149.l1NBnlZD029626@moth.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702231149.l1NBnlZD029626@moth.iki.fi>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 01:49:47PM +0200, Markku Savela wrote:
> The IPv6 and IPv4 both seem to be rather akwardly hardcoded to support
> only link layers they know.
> 
> This is a pity, because it would be so easy to make the both stacks
> totally independent of the actual link layers. It only needs one (or
> two) new function pointer in net_device. This function should do the
> conversion from IPv4/IPv6 address into corresponding hardware
> multicast/broadcast address.
> 
> In both IPv4 and IPv6, all places where symbols ARPHRD_* are
> reference, are suspect (there are some related to tunnels, which may
> be appropriate). For example, in ipv4/arp.c arp_mc_map would call this
> mapping function, if provided. Similarly ipv6/ndisc.c ndisc_mc_map.
> 
> In ipv6/addrconf.c the ivp6_generate_eui64 may possibly need yet
> another netdev function provided by the driver.
> 
> The current Ethernet specific code for these mappings could be moved
> from the ipv6/ipv6 into eth.c, and ether_setup would give defaults for
> the functions.
> 
> [I run into this while trying to do a netdev to a device is not known
> by the stacks, and IPv6 even refuses to start on it (because of the
> ivp6_generate_eui64 fails?). IPv4 ARP seems to fall back to broadcast,
> so it sort of starts]
> 

patches welcome :)

> -- 
> Markku Savela
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
