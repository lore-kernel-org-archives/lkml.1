Return-Path: <linux-kernel-owner+w=401wt.eu-S1759369AbZBYHbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbZBYHbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 02:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbZBYHbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 02:31:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50473
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754370AbZBYHbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 02:31:34 -0500
Date: Tue, 24 Feb 2009 23:31:15 -0800 (PST)
Message-Id: <20090224.233115.240823417.davem@davemloft.net>
To: yanmin_zhang@linux.intel.com
Cc: herbert@gondor.apana.org.au, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com,
       shemminger@vyatta.com
Subject: Re: [RFC v1] hand off skb list to other cpu to submit to upper
 layer
From: David Miller <davem@davemloft.net>
In-Reply-To: <1235546423.2604.556.camel@ymzhang>
References: <20090225063656.GA32635@gondor.apana.org.au>
	<1235546423.2604.556.camel@ymzhang>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Date: Wed, 25 Feb 2009 15:20:23 +0800

> If the machines might have a couple of NICs and every NIC has CPU_NUM queues,
> binding them evenly might cause more cache-miss/ping-pong. I didn't test
> multiple receiving NICs scenario as I couldn't get enough hardware.

In the net-next-2.6 tree, since we mark incoming packets with
skb_record_rx_queue() properly, we'll make a more favorable choice of
TX queue.

You may want to figure out what that isn't behaving well in your
case.

I don't think we should do any kind of software spreading for such
capable hardware, it defeats the whole point of supporting the
multiqueue features.
