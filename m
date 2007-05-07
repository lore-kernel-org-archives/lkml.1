Return-Path: <linux-kernel-owner+w=401wt.eu-S966005AbXEGRN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966005AbXEGRN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 13:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965979AbXEGRNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 13:13:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:3443 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965977AbXEGRNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 13:13:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,502,1170662400"; 
   d="scan'208";a="240354865"
Date: Mon, 7 May 2007 10:11:29 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, akpm@linux-foundation.org,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Add percpu smp cacheline align section
Message-ID: <20070507171129.GA21638@linux-os.sc.intel.com>
References: <33E1C72C74DBE747B7B59C1740F7443701A2F0AB@orsmsx417.amr.corp.intel.com> <20070505001222.GA26142@linux-os.sc.intel.com> <Pine.LNX.4.64.0705050951040.27326@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705050951040.27326@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 09:52:27AM -0700, Christoph Lameter wrote:
> On Fri, 4 May 2007, Fenghua Yu wrote:
>
> > This is follow-up for Suresh's runqueue align in smp patch at:
> > [1]http://www.uwsg.iu.edu/hypermail/linux/kernel/0704.1/0340.html
> >
> > The patches place all of smp cacheline aligned percpu data into
> > .data.percpu.cacheline_aligned_in_smp. Other percpu data is still in
> > data.percpu section. The patches can reduce cache line access in SMP and
> > reduce alignment gap waste. The patches also define PERCPU macro for
> > vmlinux.lds.S for code clean up.
>
> Ummm... The per cpu area is for exclusive use of a particular processor.
> If there is contention in the per cpu area then a data object needs to be
> removed from the per cpu area because the object is *not* accessed only
> from a certain cpu.

Christoph, This data(that is being accessed by other cpus) also needs
to be defined for each cpu and as such it is getting appended (and
clearly seperated in a different section) to the data which is accessed
only by the local cpu.

Not sure what your concern is.

thanks,
suresh
