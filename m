Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYHNTJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYHNTJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 15:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbYHNTI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 15:08:57 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:46837 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbYHNTI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 15:08:56 -0400
Date: Thu, 14 Aug 2008 21:08:46 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Frans Pop <elendil@planet.nl>
cc: linux-kernel@vger.kernel.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [regression?] [resend] Memory zone info seems incomplete in
 boottime dmesg output
In-Reply-To: <200808142042.24606.elendil@planet.nl>
Message-ID: <alpine.LNX.1.10.0808142057520.12259@titan.stealer.net>
References: <200808142042.24606.elendil@planet.nl>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -0.6
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Thu, 14 Aug 2008 19:08:54 +0000
	Bayes: 0.1342 Tokens: new, 187; hammy, 2; neutral, 4; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1342]
X-Spam-Signature: 3491b8133ae53e4bee62734a00ca923fdc0cbee8
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008, Frans Pop wrote:

> With 2.6.26 I get:
> <snip>
> Zone PFN ranges:
>   DMA             0 ->     4096
>   DMA32        4096 ->  1048576
>   Normal    1048576 ->  1048576
> Movable zone start PFN for each node
> early_node_map[4] active PFN ranges
>     0:        0 ->      159
>     0:      256 ->   521844
>     0:   521961 ->   521964
>     0:   521983 ->   521984
> On node 0 totalpages: 521751
>   DMA zone: 56 pages used for memmap
>   DMA zone: 1271 pages reserved
>   DMA zone: 2672 pages, LIFO batch:0
>   DMA32 zone: 7081 pages used for memmap
>   DMA32 zone: 510671 pages, LIFO batch:31
>   Normal zone: 0 pages used for memmap
>   Movable zone: 0 pages used for memmap
> </snip>
> 
> With 2.6.27-rc1 I only get pages listed for 2 zones (bottom part):
> <snip>
> Zone PFN ranges:
>   DMA      0x00000000 -> 0x00001000
>   DMA32    0x00001000 -> 0x00100000
>   Normal   0x00100000 -> 0x00100000
> Movable zone start PFN for each node
> early_node_map[4] active PFN ranges
>     0: 0x00000000 -> 0x0000009f
>     0: 0x00000100 -> 0x0007f674
>     0: 0x0007f6e9 -> 0x0007f6ec
>     0: 0x0007f6ff -> 0x0007f700
> On node 0 totalpages: 521751
>   DMA zone: 2072 pages, LIFO batch:0
>   DMA32 zone: 506625 pages, LIFO batch:31
> </snip>
> 
> Note that totalpages is the same and that for 2.6.26 the sum of pages for 
> all listed zones is equal to totalpages. Seems we've lost useful info 
> here.

Could you make sure DEBUG_MEMORY_INIT is activated (it should, if you've 
not chosen the embedded feature) and boot with mminit_loglevel=3 and see 
if you get the ouput you want.

Sven
