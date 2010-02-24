Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab0BXANi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 19:13:38 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47965 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0BXANg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 19:13:36 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 24 Feb 2010 09:09:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Righi <arighi@develer.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/2] memcg: dirty pages accounting and limiting
 infrastructure
Message-Id: <20100224090958.ddca8ff1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100223092853.GB1882@linux>
References: <1266765525-30890-1-git-send-email-arighi@develer.com>
	<1266765525-30890-2-git-send-email-arighi@develer.com>
	<20100222161442.GE3063@balbir.in.ibm.com>
	<20100223092853.GB1882@linux>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010 10:28:53 +0100
Andrea Righi <arighi@develer.com> wrote:

> On Mon, Feb 22, 2010 at 09:44:42PM +0530, Balbir Singh wrote:
> [snip]
> > > +void mem_cgroup_charge_dirty(struct page *page,
> > > +			enum zone_stat_item idx, int charge)
> > > +{
> > > +	struct mem_cgroup *mem;
> > > +	struct mem_cgroup_stat_cpu *cpustat;
> > > +	unsigned long flags;
> > > +	int cpu;
> > > +
> > > +	if (mem_cgroup_disabled())
> > > +		return;
> > > +	/* Translate the zone_stat_item into a mem_cgroup_stat_index */
> > > +	switch (idx) {
> > > +	case NR_FILE_DIRTY:
> > > +		idx = MEM_CGROUP_STAT_FILE_DIRTY;
> > > +		break;
> > > +	case NR_WRITEBACK:
> > > +		idx = MEM_CGROUP_STAT_WRITEBACK;
> > > +		break;
> > > +	case NR_WRITEBACK_TEMP:
> > > +		idx = MEM_CGROUP_STAT_WRITEBACK_TEMP;
> > > +		break;
> > > +	case NR_UNSTABLE_NFS:
> > > +		idx = MEM_CGROUP_STAT_UNSTABLE_NFS;
> > > +		break;
> > > +	default:
> > > +		return;
> > > +	}
> > > +	/* Charge the memory cgroup statistics */
> > > +	mem = get_mem_cgroup_from_page(page);
> > > +	if (!mem) {
> > > +		mem = root_mem_cgroup;
> > > +		css_get(&mem->css);
> > > +	}
> > > +
> > > +	local_irq_save(flags);
> > > +	cpu = get_cpu();
> > 
> > Kamezawa is in the process of changing these, so you might want to
> > look at and integrate with those patches when they are ready.
> 
> OK, I'll rebase the patch to -mm. Are those changes already included in
> mmotm?
> 
yes.

-Kame

> Thanks,
> -Andrea

