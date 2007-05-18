Return-Path: <linux-kernel-owner+w=401wt.eu-S1761273AbXERSml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761273AbXERSml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 14:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbXERSme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 14:42:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:8484 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755315AbXERSme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 14:42:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,553,1170662400"; 
   d="scan'208";a="229613770"
Date: Fri, 18 May 2007 11:39:41 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, mingo@elte.hu, ak@suse.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Zou, Nanhai" <nanhai.zou@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Packard, Keith" <keith.packard@intel.com>
Subject: Re: [patch] x86_64, irq: check remote IRR bit before migrating level triggered irq
Message-ID: <20070518183941.GA28957@linux-os.sc.intel.com>
References: <20070518010119.GB12088@linux-os.sc.intel.com> <m1veeqjitm.fsf@ebiederm.dsl.xmission.com> <20070518180749.GA26081@linux-os.sc.intel.com> <86802c440705181128t28652911w39d6de0c43d99a45@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440705181128t28652911w39d6de0c43d99a45@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 11:28:25AM -0700, Yinghai Lu wrote:
> On 5/18/07, Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:
> >
> > If the vector number stays same during irq migration and if we reset remote
> > IRR bit using the above method(edge and then back to level) during
> > irq migration, then we have a problem. A new interrupt arriving on a new
> > cpu will set the remote IRR bit and now the old inflight EOI broadcast
> > reaches IOAPIC RTE(resetting the remote IRR bit, because the vector in the
> > broadcast msg is same), while the kernel code still assumes that the remote
> > IRR bit is still set. This will lead to more problems and issues.
> 
> coud add some line __assign_irq_vector. to make sure old_vector!=vector.

hmm..
what happens when there is second(and very quick) irq migration which brings the
irq back to old cpu(or to a third cpu) with old vector.

Point is, we are not taking care of the inflight messages(which can perhaps,
theoretically, can get delayed for long time)

thanks,
suresh
