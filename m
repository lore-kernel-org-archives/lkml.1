Return-Path: <linux-kernel-owner+w=401wt.eu-S932090AbZJHKkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090AbZJHKkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 06:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756594AbZJHKkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 06:40:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:43704 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192AbZJHKkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 06:40:18 -0400
Message-ID: <4ACDC11D.4030007@kernel.org>
Date: Thu, 08 Oct 2009 19:38:21 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: cl@linux-foundation.org
CC: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V6 1/7] this_cpu_ops: page allocator conversion
References: <20091007211024.442168959@gentwo.org> <20091007211052.229772418@gentwo.org>
In-Reply-To: <20091007211052.229772418@gentwo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 08 Oct 2009 10:38:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

cl@linux-foundation.org wrote:
> +/*
> + * Boot pageset table. One per cpu which is going to be used for all
> + * zones and all nodes. The parameters will be set in such a way
> + * that an item put on a list will immediately be handed over to
> + * the buddy list. This is safe since pageset manipulation is done
> + * with interrupts disabled.
> + *
> + * The boot_pagesets must be kept even after bootup is complete for
> + * unused processors and/or zones. They do play a role for bootstrapping
> + * hotplugged processors.
> + *
> + * zoneinfo_show() and maybe other functions do
> + * not check if the processor is online before following the pageset pointer.
> + * Other parts of the kernel may not check if the zone is available.
> + */
> +static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch);
> +static DEFINE_PER_CPU(struct per_cpu_pageset, boot_pageset);

This looks much better but I'm not sure whether it's safe.  percpu
offsets have not been set up before setup_per_cpu_areas() is complete
on most archs but if all that's necessary is getting the page
allocator up and running as soon as static per cpu areas and offsets
are set up (which basically means as soon as cpu init is complete on
ia64 and setup_per_cpu_areas() is complete on all other archs).  This
should be correct.  Is this what you're expecting?

Thanks.

-- 
tejun
