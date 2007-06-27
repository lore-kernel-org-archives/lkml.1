Return-Path: <linux-kernel-owner+w=401wt.eu-S1760178AbXF0M3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178AbXF0M3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 08:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbXF0M3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 08:29:43 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:7999 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157AbXF0M3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 08:29:42 -0400
Message-ID: <4682582D.7080501@sw.ru>
Date: Wed, 27 Jun 2007 16:29:33 +0400
From: Vasily Averin <vvs@sw.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: netfilter-devel@lists.netfilter.org, rusty@rustcorp.com.au,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       "David S. Miller" <davem@davemloft.net>, devel@openvz.org
Subject: Re: [NETFILTER] early_drop() imrovement (v4)
References: <4615FE1D.80206@sw.ru>	<20070406102433.d3a670a5.dada1@cosmosbay.com>	<4616203A.80203@sw.ru> <4616626C.9020100@trash.net>	<4617845F.7080203@sw.ru> <461789CF.8000106@cosmosbay.com>	<46187770.1070106@sw.ru> <46417137.5080501@sw.ru>	<467FC8D2.5070102@trash.net> <46811292.1010501@sw.ru>	<468223D0.90305@sw.ru> <46822540.2010004@trash.net> <4682523F.6000002@trash.net>
In-Reply-To: <4682523F.6000002@trash.net>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> +	for (i = 0; i < NF_CT_EVICTION_RANGE; i++) {
> +		hlist_for_each_entry(h, n, &nf_conntrack_hash[hash], hnode) {
> +			tmp = nf_ct_tuplehash_to_ctrack(h);
> +			if (!test_bit(IPS_ASSURED_BIT, &tmp->status))
> +				ct = tmp;
> +		}
> +		if (ct) {
> +			atomic_inc(&ct->ct_general.use);
> +			break;
> +		}
> +		hash = (hash + 1) % nf_conntrack_htable_size;

it is incorrect,
We should count the number of checked _conntracks_, but you count the number of
hash buckets. I.e "i" should be incremented/checked inside the nested loop.

Thank you,
	Vasily Averin
