Return-Path: <linux-kernel-owner+w=401wt.eu-S1760581AbXF0N3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581AbXF0N3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 09:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbXF0N3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 09:29:09 -0400
Received: from stinky.trash.net ([213.144.137.162]:56977 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042AbXF0N3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 09:29:08 -0400
Message-ID: <46826607.4060201@trash.net>
Date: Wed, 27 Jun 2007 15:28:39 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Vasily Averin <vvs@sw.ru>
CC: netfilter-devel@lists.netfilter.org, rusty@rustcorp.com.au,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       "David S. Miller" <davem@davemloft.net>, devel@openvz.org
Subject: Re: [NETFILTER] early_drop() imrovement (v4)
References: <4615FE1D.80206@sw.ru>	<20070406102433.d3a670a5.dada1@cosmosbay.com>	<4616203A.80203@sw.ru> <4616626C.9020100@trash.net>	<4617845F.7080203@sw.ru> <461789CF.8000106@cosmosbay.com>	<46187770.1070106@sw.ru> <46417137.5080501@sw.ru>	<467FC8D2.5070102@trash.net> <46811292.1010501@sw.ru>	<468223D0.90305@sw.ru> <46822540.2010004@trash.net> <4682523F.6000002@trash.net> <4682582D.7080501@sw.ru> <46825D63.3060500@trash.net> <46825FE0.7060306@sw.ru> <4682638F.40507@trash.net> <46826566.2060304@sw.ru>
In-Reply-To: <46826566.2060304@sw.ru>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vasily Averin wrote:
> Patrick McHardy wrote:
> 
>>+	for (i = 0; i < nf_conntrack_htable_size; i++) {
>>+		hlist_for_each_entry(h, n, &nf_conntrack_hash[hash], hnode) {
>>+			tmp = nf_ct_tuplehash_to_ctrack(h);
>>+			if (!test_bit(IPS_ASSURED_BIT, &tmp->status))
>>+				ct = tmp;
> 
> 
> It is incorrect: you should break nested loop here too.


No, as I said, we want the last entry of the chain.
