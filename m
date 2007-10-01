Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbXJAJoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbXJAJoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 05:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbXJAJoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 05:44:11 -0400
Received: from ozlabs.org ([203.10.76.45]:48499 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbXJAJoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 05:44:11 -0400
Subject: Re: [RFC][PATCH] make module refcounts use percpu_counters
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070928230057.2712A579@kernel>
References: <20070928230057.2712A579@kernel>
Content-Type: text/plain
Date: Mon, 01 Oct 2007 19:43:53 +1000
Message-Id: <1191231833.26950.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-28 at 16:00 -0700, Dave Hansen wrote:
> Module refcounts currently use a percpu counter stored
> in the 'struct module'.  However, we also have a more
> generic implementation that does stuff like handle
> hotplug cpus.
> 
> I'm not actually all that convinced that this refcount
> actually does a lot of good, with cpus racing bumping
> the counters at the same time that they're being
> summed up.  But, it certainly isn't any worse than
> what was there before.

That's why we look at the counters inside stop_machine_run().

Note that (1) the module implementation handles hotplug CPUs, and (2)
percpu_counter_sum() doesn't have to either (that's just for
percpu_counter_read()).

But it might be a useful cleanup (although a slight de-optimization).
If you want I'll queue for 2.6.24 (there are several other module
patches pending too).

In an ideal world, (1) we would have percpu pointers using the same
percpu mechanism as percpu variables, (2) we would have a modal variant
of percpu counters which would collapse to a single counter when we
cared about the precise value (probably using stop_machine for the
transition).  This would be useful for many other cases.

Cheers,
Rusty.

