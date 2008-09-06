Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbYIFOV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbYIFOV7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 10:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYIFOVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 10:21:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46773 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbYIFOVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 10:21:49 -0400
Subject: Re: [RFC:Patch: 008/008](memory hotplug) remove_pgdat() function
From: Peter Zijlstra <peterz@infradead.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080731210326.2A51.E1E9C6FF@jp.fujitsu.com>
References: <20080731203549.2A3F.E1E9C6FF@jp.fujitsu.com>
	 <20080731210326.2A51.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain
Date: Sat, 06 Sep 2008 16:21:35 +0200
Message-Id: <1220710895.8687.12.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-31 at 21:04 +0900, Yasunori Goto wrote:

> +int remove_pgdat(int nid)
> +{
> +	struct pglist_data *pgdat = NODE_DATA(nid);
> +
> +	if (cpus_busy_on_node(nid))
> +		return -EBUSY;
> +
> +	if (sections_busy_on_node(pgdat))
> +		return -EBUSY;
> +
> +	node_set_offline(nid);
> +	synchronize_sched();
> +	synchronize_srcu(&pgdat_remove_srcu);
> +
> +	free_pgdat(nid, pgdat);
> +
> +	return 0;
> +}

FWIW synchronize_sched() is the wrong function to use here,
synchronize_rcu() is the right one.

