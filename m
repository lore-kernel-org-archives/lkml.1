Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbYFBHJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbYFBHJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 03:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYFBHJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 03:09:47 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48504 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbYFBHJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 03:09:46 -0400
Date: Mon, 02 Jun 2008 16:09:18 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] vmallocinfo: Add NUMA informations 
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <48439916.2070108@cosmosbay.com>
References: <48439916.2070108@cosmosbay.com>
Message-Id: <20080602160548.B6D4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Christoph recently added /proc/vmallocinfo file to get information about 
> vmalloc allocations.
> 
> This patch adds NUMA specific information, giving number of pages 
> allocated on each memory node.
> 
> This should help to check that vmalloc() is able to respect NUMA policies.

good patch :)


> +static void show_numa_infos(struct seq_file *m, struct vm_struct *v)
> +{
> +	if (NUMA_BUILD) {
> +		unsigned int *counters, nr;
> +
> +		counters = kzalloc(MAX_NUMNODES * sizeof(unsigned int),
> +				   GFP_KERNEL);
> +		if (!counters)
> +			return;
> +
> +		for (nr = 0; nr < v->nr_pages; nr++)
> +			counters[page_to_nid(v->pages[nr])]++;
> +
> +		for (nr = 0; nr < MAX_NUMNODES; nr++)
> +			if (counters[nr])
> +				seq_printf(m, " N%u=%u", nr, counters[nr]);
> +

for_each_node_state(n, N_HIGH_MEMORY) is better?
because MAX_NUMNODES has offten very large value.




