Return-Path: <linux-kernel-owner+w=401wt.eu-S1752023AbYKRFQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbYKRFQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 00:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbYKRFQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 00:16:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36374
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750705AbYKRFQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 00:16:45 -0500
Date: Mon, 17 Nov 2008 21:16:45 -0800 (PST)
Message-Id: <20081117.211645.193706814.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, dada1@cosmosbay.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       shemminger@vyatta.com
Subject: Re: eth_type_trans(): Re: [Bug #11308] tbench regression on each
 kernel release from 2.6.22 -&gt; 2.6.28
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081117212657.GH12020@elte.hu>
References: <20081117182320.GA26844@elte.hu>
	<20081117184951.GA5585@elte.hu>
	<20081117212657.GH12020@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 17 Nov 2008 22:26:57 +0100

> eth->h_proto access.

Yes, this is the first time a packet is touched on receive.

> Given that this workload does localhost networking, my guess would be 
> that eth->h_proto is bouncing around between 16 CPUs? At minimum this 
> read-mostly field should be separated from the bouncing bits.

It's the packet contents, there is no way to "seperate it".

And it should be unlikely bouncing on your system under tbench,
the senders and receivers should hang out on the same cpu unless
the something completely stupid is happening.

That's why I like running tbench with a num_threads command
line argument equal to the number of cpus, every cpu gets
the two thread talking to eachother over the TCP socket.
