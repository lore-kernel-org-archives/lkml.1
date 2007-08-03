Return-Path: <linux-kernel-owner+w=401wt.eu-S1762117AbXHCNpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762117AbXHCNpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 09:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761281AbXHCNpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 09:45:47 -0400
Received: from lazybastard.de ([212.112.238.170]:36604 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761006AbXHCNpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 09:45:46 -0400
Date: Fri, 3 Aug 2007 15:41:50 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jan-Bernd Themann <ossthema@de.ibm.com>
Cc: David Miller <davem@davemloft.net>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>, netdev <netdev@vger.kernel.org>,
       Andrew Gallatin <gallatin@myri.com>, Jeff Garzik <jeff@garzik.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 1/1] lro: Generic Large Receive Offload for TCP traffic
Message-ID: <20070803134150.GH19344@lazybastard.org>
References: <200708031441.20632.ossthema@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200708031441.20632.ossthema@de.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 August 2007 14:41:19 +0200, Jan-Bernd Themann wrote:
> 
> This patch provides generic Large Receive Offload (LRO) functionality
> for IPv4/TCP traffic.
> 
> LRO combines received tcp packets to a single larger tcp packet and 
> passes them then to the network stack in order to increase performance
> (throughput). The interface supports two modes: Drivers can either pass
> SKBs or fragment lists to the LRO engine. 

Maybe this is a stupid question, but why is LRO done at the device
driver level?

If it is a unversal performance benefit, I would have expected it to be
done generically, i.e. have all packets moved into network layer pass
through LRO instead.

> +void lro_flush_pkt(struct net_lro_mgr *lro_mgr,
> +		   struct iphdr *iph, struct tcphdr *tcph);

In particular this bit looks like it should be driven by a timeout,
which would be settable via /proc/sys/net/core/lro_timeout or similar.

Jörn

-- 
Rules of Optimization:
Rule 1: Don't do it.
Rule 2 (for experts only): Don't do it yet.
-- M.A. Jackson
