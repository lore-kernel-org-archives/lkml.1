Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbZCEBFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbZCEBFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 20:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbZCEBFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 20:05:04 -0500
Received: from mga10.intel.com ([192.55.52.92]:55810 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750775AbZCEBFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 20:05:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,304,1233561600"; 
   d="scan'208";a="436274421"
Subject: Re: [RFC v1] hand off skb list to other cpu to submit to upper
	layer
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com,
       shemminger@vyatta.com
In-Reply-To: <20090304.013937.129768263.davem@davemloft.net>
References: <1235546423.2604.556.camel@ymzhang>
	 <20090224.233115.240823417.davem@davemloft.net>
	 <1236158868.2567.93.camel@ymzhang>
	 <20090304.013937.129768263.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 05 Mar 2009 09:04:36 +0800
Message-Id: <1236215076.2567.105.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 01:39 -0800, David Miller wrote:
> From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
> Date: Wed, 04 Mar 2009 17:27:48 +0800
> 
> > Both the new skb_record_rx_queue and current kernel have an
> > assumption on multi-queue. The assumption is it's best to send out
> > packets from the TX of the same number of queue like the one of RX
> > if the receved packets are related to the out packets. Or more
> > direct speaking is we need send packets on the same cpu on which we
> > receive them. The start point is that could reduce skb and data
> > cache miss.
> 
> We have to use the same TX queue for all packets for the same
> connection flow (same src/dst IP address and ports) otherwise
> we introduce reordering.
> Herbert brought this up, now I have explicitly brought this up,
> and you cannot ignore this issue.
Thanks. ﻿Stephen Hemminger brought it up and explained what reorder
is. I answered in a reply (sorry for not clear) that mostly we need spread
packets among RX/TX in a 1:1 mapping or N:1 mapping. For example, all packets
received from RX 8 will be spreaded to TX 0 always.


> 
> You must not knowingly reorder packets, and using different TX
> queues for packets within the same flow does that.
Thanks for you rexplanation which is really consistent with ﻿Stephen's speaking.


