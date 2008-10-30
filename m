Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbYJ3UXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbYJ3UXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbYJ3UXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:23:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:49231 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbYJ3UXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:23:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,517,1220252400"; 
   d="scan'208";a="457318155"
Date: Thu, 30 Oct 2008 13:23:23 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
       "jeremy.fitzhardinge@citrix.com" <jeremy.fitzhardinge@citrix.com>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>
Subject: Re: [patch] generic-ipi: fix the smp_mb() placement
Message-ID: <20081030202322.GM30573@linux-os.sc.intel.com>
References: <20081029224229.GK30573@linux-os.sc.intel.com> <20081030185322.GE17822@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030185322.GE17822@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 11:53:22AM -0700, Ingo Molnar wrote:
> 
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > Subject: generic-ipi: fix the smp_mb() placement
> >
> > smp_mb() is needed (to make the memory operations visible globally)
> > before sending the ipi on the sender and the receiver (on Alpha
> > atleast) needs smp_read_barrier_depends() in the handler before
> > reading the call_single_queue list in a lock-free fashion.
> >
> > On x86, x2apic mode register accesses for sending IPI's don't have
> > serializing semantics. So the need for smp_mb() before sending the
> > IPI becomes more critical in x2apic mode.
> >
> > Remove the unnecessary smp_mb() in csd_flag_wait(), as the presence
> > of that smp_mb() doesn't mean anything on the sender, when the ipi
> > receiver is not doing any thing special (like memory fence) after
> > clearing the CSD_FLAG_WAIT.
> 
> nice! Did you see an actual lockup due to this?

We didn't see the lockup in our tests but Xen folks reported similar failures
with their smp call function code.

> Seems like a v2.6.28 fix to me in any case.

Yes.

thanks,
suresh
