Return-Path: <linux-kernel-owner+w=401wt.eu-S932556AbXHCNK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556AbXHCNK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 09:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759693AbXHCNKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 09:10:44 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:31093 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757636AbXHCNKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 09:10:43 -0400
From: Jan-Bernd Themann <ossthema@de.ibm.com>
Subject: [PATCH 0/1] lro: Generic Large Receive Offload for TCP traffic
Date: Fri, 3 Aug 2007 14:41:14 +0200
User-Agent: KMail/1.8.2
MIME-Version: 1.0
Content-Disposition: inline
To: David Miller <davem@davemloft.net>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ppc" <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>, Andrew Gallatin <gallatin@myri.com>,
       Jeff Garzik <jeff@garzik.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       netdev <netdev@vger.kernel.org>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200708031441.14780.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think this patch could be the final version for now. It has been tested
on two platforms (power and x86_64) and works very well.

Apart from David Miller and Evgeniy Polaykov, we'd like to thank especially
Andrew Gallatin for his great reviews and help to make that happen.

After some discussion we decided to post the LRO patch separately from the 
driver patches. Our final driver patches for LRO will be posted later with
some additional fixes for upstream inclusion to the netdev git.
However, I'll also post our LRO patch for the driver today as an example
of how to use this interface.

Thanks a lot,
Jan-Bernd 

[PATCH 1/1] lro: Generic Large Receive Offload for TCP traffic

Changes to http://www.spinics.net/lists/netdev/msg37084.html

1) Fixed the LRO_MAX_PG_HLEN bug

2) skb->ip_summed can now be defined by driver for aggregated packets

3) The problem that the "ramp up" for tcp connections between machines
   with different MTU size (1500 vs 9000) is very slow has been fixed
   by setting skb->gso_size.

4) Checksum problem for little endian machines has been fixed

5) missing additon of vlan_hdr_len for TCP header determination has been added.
