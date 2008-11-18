Return-Path: <linux-kernel-owner+w=401wt.eu-S1752073AbYKRFgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbYKRFgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 00:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750800AbYKRFgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 00:36:41 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:50811 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbYKRFgk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 00:36:40 -0500
Message-ID: <49225432.6050607@cosmosbay.com>
Date: Tue, 18 Nov 2008 06:35:46 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mingo@elte.hu, torvalds@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       shemminger@vyatta.com
Subject: Re: eth_type_trans(): Re: [Bug #11308] tbench regression on each
 kernel release from 2.6.22 -&gt; 2.6.28
References: <20081117182320.GA26844@elte.hu>	<20081117184951.GA5585@elte.hu>	<20081117212657.GH12020@elte.hu> <20081117.211645.193706814.davem@davemloft.net>
In-Reply-To: <20081117.211645.193706814.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 18 Nov 2008 06:35:51 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller a écrit :
> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 17 Nov 2008 22:26:57 +0100
> 
>> eth->h_proto access.
> 
> Yes, this is the first time a packet is touched on receive.

Well, not exactly, since we do a 

if (is_multicast_ether_addr(eth->h_dest)) {
...}

and one of the
	compare_ether_addr(eth->h_dest, {dev->dev_addr | dev->broadcast})

probably its a profiling effect...



