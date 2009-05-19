Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbZESItB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbZESItB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 04:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbZESIsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 04:48:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:39649 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbZESIsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 04:48:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,214,1241420400"; 
   d="scan'208";a="413692768"
Date: Tue, 19 May 2009 16:48:52 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "menage@google.com" <menage@google.com>
Subject: Re: [PATCH]cpuset: add new API to change cpuset top group's cpus
Message-ID: <20090519084852.GA13682@sli10-desk.sh.intel.com>
References: <20090519073942.GA10864@sli10-desk.sh.intel.com> <1242722454.26820.461.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242722454.26820.461.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 04:40:54PM +0800, Peter Zijlstra wrote:
> On Tue, 2009-05-19 at 15:39 +0800, Shaohua Li wrote:
> > ACPI 4.0 defines processor aggregator device. The device can notify OS to idle
> > some CPUs to save power. This isn't to hot remove cpus, but just makes cpus
> > idle.
> > 
> > This patch adds one API to change cpuset top group's cpus. If we want to
> > make one cpu idle, simply remove the cpu from cpuset top group's cpu list,
> > then all tasks will be migrate to other cpus, and other tasks will not be
> > migrated to this cpu again. No functional changes.
> > 
> > We will use this API in new ACPI processor aggregator device driver later.
> 
> I don't think so. There really is a lot more to do than move processes
> about.
no processor running is good enough for us, we don't care about interrupts/softirq/
timers so far.

> Furthermore, I object to being able to remove online cpus from the top
> cpuset, that just doesn't make sense.
> 
> I'd suggest using hotplug for this.
cpu hotplug involves too much things, and we are afraid it's not reliable.
Besides, a hot removed cpu will do a dead loop halt, which isn't power saving
efficient. To make hot removed cpu enters deep C-state is in whish list for a
long time, but still not available. The acpi_processor_idle is a module, and
cpuidle governor potentially can't handle offline cpu.

Thanks,
Shaohua
