Return-Path: <linux-kernel-owner+w=401wt.eu-S1757786AbZFSLPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786AbZFSLPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 07:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756909AbZFSLPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 07:15:15 -0400
Received: from stinky.trash.net ([213.144.137.162]:63323 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452AbZFSLPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 07:15:14 -0400
Message-ID: <4A3B7340.50602@trash.net>
Date: Fri, 19 Jun 2009 13:15:12 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: conntrack: death_by_timeout() fix
References: <20090615.050449.144947903.davem@davemloft.net> <20090616091538.GA4184@elte.hu> <20090616.034752.226811527.davem@davemloft.net> <20090616105304.GA3579@elte.hu> <20090616122415.GA16630@elte.hu> <20090617092152.GA17449@elte.hu> <4A38C2F3.3000009@gmail.com> <20090617110803.GA10175@elte.hu> <20090618052356.GA18722@elte.hu> <4A39D778.9020607@cosmosbay.com> <4A3A0D45.8090806@trash.net> <4A3A5599.4080906@trash.net> <4A3A6143.3040607@gmail.com> <4A3A66CC.4090205@trash.net> <4A3AC3B3.2030002@gmail.com>
In-Reply-To: <4A3AC3B3.2030002@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> [PATCH] netfilter: conntrack: death_by_timeout() fix
> 
> death_by_timeout() might delete a conntrack from hash list
> and insert it in dying list.
> 
>  nf_ct_delete_from_lists(ct);
>  nf_ct_insert_dying_list(ct);
> 
> I believe a (lockless) reader could *catch* ct while doing a lookup 
> and miss the end of its chain.
> (nulls lookup algo must check the null value at the end of lookup and
> should restart if the null value is not the expected one.
> cf Documentation/RCU/rculist_nulls.txt for details)
> 
> We need to change nf_conntrack_init_net() and use a different "null" value,
> guaranteed not being used in regular lists. Choose very large values, since
> hash table uses [0..size-1] null values.

Applied, thanks Eric.
