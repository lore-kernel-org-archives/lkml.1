Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbZHXPdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbZHXPdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 11:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZHXPdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 11:33:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:56569 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbZHXPdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 11:33:21 -0400
Subject: Re: [PATCH 12/15] sched: Allow NODE domain to be parent of MC
 instead of CPU domain
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20090820134245.GA29327@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
	 <20090820134245.GA29327@alberich.amd.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Aug 2009 17:32:40 +0200
Message-Id: <1251127960.7538.298.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 15:42 +0200, Andreas Herrmann wrote:
> The level of NODE domain's child domain is provided in s_data.numa_child_level.
> Then several adaptions are required when creating the domain hierarchy.
> In case NODE domain is parent of MC domain we have to:
> - limit NODE domains' span in sched_domain_node_span() to not exceed
>   corresponding topology_core_cpumask.
> - fix CPU domain span to cover entire cpu_map
> - fix CPU domain sched groups to cover entire physical groups instead of
>   covering a node (a node sched_group might be a proper subset of a CPU
>   sched_group).
> - use correct child domain in init_numa_sched_groups_power() when
>   calculating sched_group.__cpu_power in NODE domain
> - calculate group_power of NODE domain after its child domain
> 
> Note: As I have no idea when the ALLNODES domain is required
>       I assumed that an ALLNODES domain exists only if NODE domain
>       is parent of CPU domain.

I think its only used when the regular node level is too large, then we
split it into smaller bits. SGI folks who run crazy large machines use
this.

/me mumbels about renaming the domain level, CPU is the physical socket
level, right? stupid names.

Patch sounds funky though, numa_child_level should be effident from the
tree build.
