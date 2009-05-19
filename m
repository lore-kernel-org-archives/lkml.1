Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbZESWhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbZESWhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 18:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbZESWhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 18:37:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34586 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbZESWhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 18:37:38 -0400
Subject: Re: [PATCH]cpuset: add new API to change cpuset top group's cpus
From: Peter Zijlstra <peterz@infradead.org>
To: Len Brown <lenb@kernel.org>
Cc: Shaohua Li <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
In-Reply-To: <alpine.LFD.2.00.0905191429440.29241@localhost.localdomain>
References: <20090519073942.GA10864@sli10-desk.sh.intel.com>
	 <1242722454.26820.461.camel@twins>
	 <20090519084852.GA13682@sli10-desk.sh.intel.com>
	 <1242723364.26820.466.camel@twins> <1242729538.26820.497.camel@twins>
	 <alpine.LFD.2.00.0905191429440.29241@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 20 May 2009 00:36:41 +0200
Message-Id: <1242772601.26820.527.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-19 at 15:01 -0400, Len Brown wrote:
> > ... the point is, we
> > don't need a new interface to force a cpu idle. Hotplug does that.
> >
> > Furthermore, we should not want anything outside of that, either the cpu
> > is there available for work, or its not -- halfway measures don't make
> > sense.
> > 
> > Furthermore, we already have power aware scheduling which tries to
> > aggregate idle time on cpu/core/packages so as to maximize the idle time
> > power savings. Use it there.
> 
> Some context...

<snip default story of thermal overcommit>

> > > > Besides, a hot removed cpu will do a dead loop halt, which isn't power saving
> > > > efficient. To make hot removed cpu enters deep C-state is in whish list for a
> > > > long time, but still not available. The acpi_processor_idle is a module, and
> > > > cpuidle governor potentially can't handle offline cpu.
> > > 
> > > Then fix that hot-unplug idle loop. I agree that the hlt thing is silly,
> > > and I've no idea why its still there, seems like a much better candidate
> > > for your efforts than this.
> 
> CONFIG_HOTPLUG_CPU has been problematic in the past.
> It does more than what we need here, so we thought
> a lighter-weight and lower-latency method that simply
> didn't schedule to the idled cpu would suffice.

> We are fixing the hotplug-unplug idle loop, but there
> turns out to be some issues with it related to idle
> processors with interrupts disabled that don't actually
> get down into the deep C-states we request:-(
> 
> So this is why you see a patch for a "halfway measure",
> it does what is necessary, and does nothing more.

Its broken, its ill-defined and its not going to happen.

Ripping cpus out of the top cpuset might upset the cpuset configuration
and has no regards for any realtime processes. And I must take back my
earlier suggestion, hotplug is a bad solution too.

There's just too much user policy (cpuset configuration) to upset.

The IBM folks are working on a scheduler based solution, please talk to
them.


