Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbYHYXeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbYHYXeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 19:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYHYXeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 19:34:04 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46585 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbYHYXeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 19:34:04 -0400
Date: Tue, 26 Aug 2008 08:33:23 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mike Travis <travis@sgi.com>
Subject: Re: [RFC][PATCH 2/2] quicklist shouldn't be proportional to # of CPUs
Cc: kosaki.motohiro@jp.fujitsu.com, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, cl@linux-foundation.org,
       tokunaga.keiich@jp.fujitsu.com
In-Reply-To: <48B2FE79.8060709@sgi.com>
References: <20080821183648.22AF.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48B2FE79.8060709@sgi.com>
Message-Id: <20080826083243.232F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	int node = numa_node_id();
> > +	struct zone *zones = NODE_DATA(node)->node_zones;
> > +	int num_cpus_on_node;
> > +	node_to_cpumask_ptr(cpumask_on_node, node);
> >  
> >  	node_free_pages =
> >  #ifdef CONFIG_ZONE_DMA
> > @@ -38,6 +41,10 @@ static unsigned long max_pages(unsigned 
> >  		zone_page_state(&zones[ZONE_NORMAL], NR_FREE_PAGES);
> >  
> >  	max = node_free_pages / FRACTION_OF_NODE_MEM;
> > +
> > +	num_cpus_on_node = cpus_weight_nr(*cpumask_on_node);
> > +	max /= num_cpus_on_node;
> > +
> >  	return max(max, min_pages);
> 
> Exactly!  And (many thanks to them!) the sparc maintainers have
> implemented a similar internal function definition for node_to_cpumask_ptr().

Can I think get your Ack?


