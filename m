Return-Path: <linux-kernel-owner+w=401wt.eu-S1752293AbZIOIdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbZIOIdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 04:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbZIOIdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 04:33:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33592
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750891AbZIOIdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 04:33:04 -0400
Date: Tue, 15 Sep 2009 01:33:21 -0700 (PDT)
Message-Id: <20090915.013321.07006714.davem@davemloft.net>
To: yi.zhu@intel.com
Cc: mel@csn.ul.ie, reinette.chatre@intel.com, elendil@planet.nl,
       Larry.Finger@lwfinger.net, linville@tuxdriver.com,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       assaf.krauss@intel.com, johannes@sipsolutions.net,
       mohamed.abbas@intel.com, netdev@vger.kernel.org
Subject: Re: alloc skb based on a given data buffer
From: David Miller <davem@davemloft.net>
In-Reply-To: <1253003420.7549.51.camel@debian>
References: <1252897270.5650.169.camel@debian>
	<20090914130612.GA11778@csn.ul.ie>
	<1253003420.7549.51.camel@debian>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhu Yi <yi.zhu@intel.com>
Date: Tue, 15 Sep 2009 16:30:20 +0800

> This way, device drivers can allocate the Rx buffers with their own size
> and alignment requirement. i.e. do an order-1 page allocation directly
> with free_pages() in the iwlagn driver for a 256 bytes aligned 8K Rx
> buffer. After DMA is finished, drivers can use the above function to
> assemble an skb based on the Rx buffer. It should resolve the problem
> for requiring an order-2 allocation by alloc_skb() in the first place.

You can create paged RX skbs just like drivers such as niu.c
and others already do, there is no need for special APIs for
this.
