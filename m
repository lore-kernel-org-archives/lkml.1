Return-Path: <linux-kernel-owner+w=401wt.eu-S1764100AbYEOSc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764100AbYEOSc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364AbYEOScr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:32:47 -0400
Received: from stinky.trash.net ([213.144.137.162]:50014 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180AbYEOScq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:32:46 -0400
Message-ID: <482C81CC.7000305@trash.net>
Date: Thu, 15 May 2008 20:32:44 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@gmail.com>
CC: Kingsley Foreman <kingsley@internode.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: NET_SCHED cbq dropping too many packets on a bonding interface
References: <20080515091216.GA6550@ff.dom.local> <8ECDBB4EB5394859BFFACAAEE3A6EDB0@uglypunk> <482C6040.9030808@trash.net> <20080515182504.GB2936@ami.dom.local>
In-Reply-To: <20080515182504.GB2936@ami.dom.local>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:
> On Thu, May 15, 2008 at 06:09:36PM +0200, Patrick McHardy wrote:
> ...
>> Do things improve if you set txqueuelen to a larger value
>> *before* configuring the qdiscs?
> 
> BTW, I hope it was *before*, but since pfifo_fast_enqueue() uses
> "qdisc->dev->tx_queue_len" does it really matter? (Until it's
> before the test of course...)


Yes, CBQ uses pfifo, not pfifo_fast. pfifo uses txqueuelen
to inialize q->limit, but thats whats used during ->enqueue().
