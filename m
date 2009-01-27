Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbZA0Smd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbZA0Smd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 13:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755974AbZA0SmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 13:42:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54832
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755920AbZA0SmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 13:42:12 -0500
Date: Tue, 27 Jan 2009 10:42:10 -0800 (PST)
Message-Id: <20090127.104210.136585415.davem@davemloft.net>
To: zbr@ioremap.net
Cc: jarkao2@gmail.com, herbert@gondor.apana.org.au, w@1wt.eu,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090126.221056.174077798.davem@davemloft.net>
References: <20090126082036.GB4183@ff.dom.local>
	<20090126212130.GA4338@ioremap.net>
	<20090126.221056.174077798.davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 26 Jan 2009 22:10:56 -0800 (PST)

> Even for drivers like NIU and myri10ge that do this, they only
> use heuristics or some fixed minimum to decide how much to
> move to the linear area.
> 
> Result?  Some data payload bits end up there because it overshoots.
 ...
> I did test this with the NIU driver at one point, and it did not
> change TCP latency nor throughput at all even at 10g speeds.

As a followup, it turns out that NIU right now does this properly.

It only pulls a maximum of ETH_HLEN into the linear area before giving
the SKB to netif_receive_skb().
