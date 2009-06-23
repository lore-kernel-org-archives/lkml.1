Return-Path: <linux-kernel-owner+w=401wt.eu-S1758482AbZFWLFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482AbZFWLFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbZFWLFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:05:01 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:50732 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756964AbZFWLFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:05:00 -0400
Message-ID: <4A40B69A.2020703@gmail.com>
Date: Tue, 23 Jun 2009 13:03:54 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: acme@redhat.com, mel@csn.ul.ie, akpm@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, htd@fancy-poultry.org
Subject: Re: [PATCH 3/3] net-dccp: Suppress warning about large allocations
 from DCCP
References: <1245685414-8979-4-git-send-email-mel@csn.ul.ie>	<20090622.161502.74508182.davem@davemloft.net>	<20090623023936.GA2721@ghostprotocols.net> <20090622.211927.245716932.davem@davemloft.net>
In-Reply-To: <20090622.211927.245716932.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 23 Jun 2009 13:04:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller a écrit :
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> Date: Mon, 22 Jun 2009 23:39:36 -0300
> 
>> Em Mon, Jun 22, 2009 at 04:15:02PM -0700, David Miller escreveu:
>>> It's probably much more appropriate to make this stuff use
>>> alloc_large_system_hash(), like TCP does (see net/ipv4/tcp.c
>>> tcp_init()).
>>>
>>> All of this complicated DCCP hash table size computation code will
>>> simply disappear.  And it'll fix the warning too :-)
>> He mentioned that in the conversation that lead to this new patch
>> series, problem is that alloc_large_system_hash is __init, so when you
>> try to load dccp.ko it will not be available.
> 
> Fair enough.
> 
> It's such an unfortunate duplication of code, it's likely therefore
> better to remove the __init tag and export that symbol.

Agreed, I once considered using this function for futex hash table allocation
and just forgot about it...

But it has some bootmem references, it might need more work than just exporting it.
