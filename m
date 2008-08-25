Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbYHYXbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbYHYXbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 19:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYHYXb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 19:31:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38759 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbYHYXb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 19:31:26 -0400
Date: Tue, 26 Aug 2008 08:31:02 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mike Travis <travis@sgi.com>
Subject: Re: [RFC][PATCH 2/2] quicklist shouldn't be proportional to # of CPUs
Cc: kosaki.motohiro@jp.fujitsu.com, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, cl@linux-foundation.org,
       tokunaga.keiich@jp.fujitsu.com
In-Reply-To: <48B2FC9D.3020300@sgi.com>
References: <20080821.001322.236658980.davem@davemloft.net> <48B2FC9D.3020300@sgi.com>
Message-Id: <20080826082756.232C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike, 

> >>> +	num_cpus_per_node = cpus_weight_nr(node_to_cpumask(node));
> 
> I think the more correct usage would be:
> 
> 	{
> 		node_to_cpumask_ptr(v, node);
> 		num_cpus_per_node = cpus_weight_nr(*v);
> 		max /= num_cpus_per_node;
> 
> 		return max(max, min_pages);
> 	}
> 
> which should load 'v' with a pointer to the node_to_cpumask_map[node] entry
> [and avoid using stack space for the cpumask_t variable for those arch's
> that define a node_to_cpumask_map (or similar).]  Otherwise a local cpumask_t
> variable '_v' is created to which 'v' is pointing to and thus can be used
> directly as an arg to the cpu_xxx ops.

Thank you for your attension.
please see my latest patch (http://marc.info/?l=linux-mm&m=121966459713193&w=2)
it do that.



