Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbZESI71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbZESI71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 04:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbZESI7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 04:59:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:41159 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbZESI7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 04:59:14 -0400
Subject: Re: [PATCH]cpuset: add new API to change cpuset top group's cpus
From: Peter Zijlstra <peterz@infradead.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "menage@google.com" <menage@google.com>
In-Reply-To: <20090519084852.GA13682@sli10-desk.sh.intel.com>
References: <20090519073942.GA10864@sli10-desk.sh.intel.com>
	 <1242722454.26820.461.camel@twins>
	 <20090519084852.GA13682@sli10-desk.sh.intel.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 19 May 2009 10:56:04 +0200
Message-Id: <1242723364.26820.466.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-19 at 16:48 +0800, Shaohua Li wrote:
> On Tue, May 19, 2009 at 04:40:54PM +0800, Peter Zijlstra wrote:
> > On Tue, 2009-05-19 at 15:39 +0800, Shaohua Li wrote:
> > > ACPI 4.0 defines processor aggregator device. The device can notify OS to idle
> > > some CPUs to save power. This isn't to hot remove cpus, but just makes cpus
> > > idle.
> > > 
> > > This patch adds one API to change cpuset top group's cpus. If we want to
> > > make one cpu idle, simply remove the cpu from cpuset top group's cpu list,
> > > then all tasks will be migrate to other cpus, and other tasks will not be
> > > migrated to this cpu again. No functional changes.
> > > 
> > > We will use this API in new ACPI processor aggregator device driver later.
> > 
> > I don't think so. There really is a lot more to do than move processes
> > about.
> no processor running is good enough for us, we don't care about interrupts/softirq/
> timers so far.

Well, I don't care for this interface.

> > Furthermore, I object to being able to remove online cpus from the top
> > cpuset, that just doesn't make sense.
> > 
> > I'd suggest using hotplug for this.

> cpu hotplug involves too much things, and we are afraid it's not reliable.

Then make it more reliable instead of providing ugly ass shit like this.

> Besides, a hot removed cpu will do a dead loop halt, which isn't power saving
> efficient. To make hot removed cpu enters deep C-state is in whish list for a
> long time, but still not available. The acpi_processor_idle is a module, and
> cpuidle governor potentially can't handle offline cpu.

Then fix that hot-unplug idle loop. I agree that the hlt thing is silly,
and I've no idea why its still there, seems like a much better candidate
for your efforts than this.
