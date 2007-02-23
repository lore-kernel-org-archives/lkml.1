Return-Path: <linux-kernel-owner+w=401wt.eu-S932229AbXBWLtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbXBWLtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932253AbXBWLtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:49:50 -0500
Received: from burp.tkv.asdf.org ([212.16.99.49]:51587 "EHLO moth.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230AbXBWLts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:49:48 -0500
Date: Fri, 23 Feb 2007 13:49:47 +0200
Message-Id: <200702231149.l1NBnlZD029626@moth.iki.fi>
From: Markku Savela <msa@moth.iki.fi>
To: linux-kernel@vger.kernel.org
Subject: ipv4 and ipv6 stacks for new link layers?
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The IPv6 and IPv4 both seem to be rather akwardly hardcoded to support
only link layers they know.

This is a pity, because it would be so easy to make the both stacks
totally independent of the actual link layers. It only needs one (or
two) new function pointer in net_device. This function should do the
conversion from IPv4/IPv6 address into corresponding hardware
multicast/broadcast address.

In both IPv4 and IPv6, all places where symbols ARPHRD_* are
reference, are suspect (there are some related to tunnels, which may
be appropriate). For example, in ipv4/arp.c arp_mc_map would call this
mapping function, if provided. Similarly ipv6/ndisc.c ndisc_mc_map.

In ipv6/addrconf.c the ivp6_generate_eui64 may possibly need yet
another netdev function provided by the driver.

The current Ethernet specific code for these mappings could be moved
from the ipv6/ipv6 into eth.c, and ether_setup would give defaults for
the functions.

[I run into this while trying to do a netdev to a device is not known
by the stacks, and IPv6 even refuses to start on it (because of the
ivp6_generate_eui64 fails?). IPv4 ARP seems to fall back to broadcast,
so it sort of starts]

-- 
Markku Savela
