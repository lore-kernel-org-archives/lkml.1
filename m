Return-Path: <linux-kernel-owner+w=401wt.eu-S1761817AbYDNTRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761817AbYDNTRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758235AbYDNTRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:17:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:32708 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760819AbYDNTRI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:17:08 -0400
X-ExtLoop1: 1
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2] Re: WAN: new PPP code for generic HDLC
Date: Mon, 14 Apr 2008 12:16:55 -0700
Message-ID: <D5C1322C3E673F459512FB59E0DDC32904E2B65F@orsmsx414.amr.corp.intel.com>
In-Reply-To: <m33apqomgf.fsf@maximus.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2] Re: WAN: new PPP code for generic HDLC
Thread-Index: Acic2prmyRwly60ITQKhcgqAgScE4ABiOZOg
References: <m3prtzsszg.fsf@maximus.localdomain><m3tzj92xq6.fsf@maximus.localdomain><m33aqedg0a.fsf@maximus.localdomain><m37if4oz1g.fsf@maximus.localdomain><20080411221448.22b69ff5.akpm@linux-foundation.org><m3prsva3y7.fsf@maximus.localdomain> <20080412115950.1cbb9cfa@core> <m33apqomgf.fsf@maximus.localdomain>
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: "Krzysztof Halasa" <khc@pm.waw.pl>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Jeff Garzik" <jeff@garzik.org>, <linux-kernel@vger.kernel.org>,
       <netdev@vger.kernel.org>
X-OriginalArrivalTime: 14 Apr 2008 19:16:54.0626 (UTC) FILETIME=[19C41C20:01C89E64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's not that simple - it was broken between 2.6.22 and 2.6.23 (2.6.23
> was already broken), I just haven't noticed (I don't use PPP myself,
> except for tests).

> author	Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
> 	 Fri, 6 Jul 2007 20:36:20 +0000 (13:36 -0700)
> commit	f25f4e44808f0f6c9875d94ef1c41ef86c288eb2

> [CORE] Stack changes to add multiqueue hardware support API
> Add the multiqueue hardware device support API to the core network
> stack.  Allow drivers to allocate multiple queues and manage them at
> the netdev level if they choose to do so.

> Added a new field to sk_buff, namely queue_mapping, for drivers to
> know which tx_ring to select based on OS classification of the flow.

> And it included:
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -565,9 +578,7 @@ struct net_device
 
> static inline void *netdev_priv(const struct net_device *dev)
> {
> -       return (char *)dev + ((sizeof(struct net_device)
> -                                       + NETDEV_ALIGN_CONST)
> -                               & ~NETDEV_ALIGN_CONST);
> +       return dev->priv;
> }

What I find a bit disturbing is I found my original patchsets I
submitted to the list that were committed for this patchset.  My
original patches don't have this change in them at all.  :-(

-PJ Waskiewicz
