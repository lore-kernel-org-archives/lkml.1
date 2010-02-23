Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab0BWJ25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 04:28:57 -0500
Received: from trinity.develer.com ([83.149.158.210]:42403 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab0BWJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 04:28:55 -0500
Date: Tue, 23 Feb 2010 10:28:53 +0100
From: Andrea Righi <arighi@develer.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/2] memcg: dirty pages accounting and limiting
 infrastructure
Message-ID: <20100223092853.GB1882@linux>
References: <1266765525-30890-1-git-send-email-arighi@develer.com>
 <1266765525-30890-2-git-send-email-arighi@develer.com>
 <20100222161442.GE3063@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100222161442.GE3063@balbir.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 09:44:42PM +0530, Balbir Singh wrote:
[snip]
> > +void mem_cgroup_charge_dirty(struct page *page,
> > +			enum zone_stat_item idx, int charge)
> > +{
> > +	struct mem_cgroup *mem;
> > +	struct mem_cgroup_stat_cpu *cpustat;
> > +	unsigned long flags;
> > +	int cpu;
> > +
> > +	if (mem_cgroup_disabled())
> > +		return;
> > +	/* Translate the zone_stat_item into a mem_cgroup_stat_index */
> > +	switch (idx) {
> > +	case NR_FILE_DIRTY:
> > +		idx = MEM_CGROUP_STAT_FILE_DIRTY;
> > +		break;
> > +	case NR_WRITEBACK:
> > +		idx = MEM_CGROUP_STAT_WRITEBACK;
> > +		break;
> > +	case NR_WRITEBACK_TEMP:
> > +		idx = MEM_CGROUP_STAT_WRITEBACK_TEMP;
> > +		break;
> > +	case NR_UNSTABLE_NFS:
> > +		idx = MEM_CGROUP_STAT_UNSTABLE_NFS;
> > +		break;
> > +	default:
> > +		return;
> > +	}
> > +	/* Charge the memory cgroup statistics */
> > +	mem = get_mem_cgroup_from_page(page);
> > +	if (!mem) {
> > +		mem = root_mem_cgroup;
> > +		css_get(&mem->css);
> > +	}
> > +
> > +	local_irq_save(flags);
> > +	cpu = get_cpu();
> 
> Kamezawa is in the process of changing these, so you might want to
> look at and integrate with those patches when they are ready.

OK, I'll rebase the patch to -mm. Are those changes already included in
mmotm?

Thanks,
-Andrea
