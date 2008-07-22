Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbYGVSLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbYGVSLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 14:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYGVSK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 14:10:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:3023 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbYGVSK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 14:10:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,232,1215414000"; 
   d="scan'208";a="420905543"
Date: Tue, 22 Jul 2008 11:10:56 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: add apic probe for genapic 64bit v2
Message-ID: <20080722181056.GD14380@linux-os.sc.intel.com>
References: <200807211836.27282.yhlu.kernel@gmail.com> <200807212208.22116.yhlu.kernel@gmail.com> <20080722175757.GC14380@linux-os.sc.intel.com> <86802c440807221105s77372df8re2e59440a8f644bd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807221105s77372df8re2e59440a8f644bd@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 11:05:17AM -0700, Yinghai Lu wrote:
> On Tue, Jul 22, 2008 at 10:57 AM, Suresh Siddha
> <suresh.b.siddha@intel.com> wrote:
> > Yinghai, though not directly realted to this probe cleanup, what is this
> > 'max_physical_apicid' doing.
> >
> > I don't understand the need for this commit.
> >
> >> commit e0da33646826b66ef933d47ea2fb7a693fd849bf
> >> Author: Yinghai Lu <yhlu.kernel@gmail.com>
> >> Date:   Sun Jun 8 18:29:22 2008 -0700
> >>
> >>     x86: introduce max_physical_apicid for bigsmp switching
> >>
> >>     a multi-socket test-system with 3 or 4 ioapics, when 4 dualcore cpus or
> >>     2 quadcore cpus installed, needs to switch to bigsmp or physflat.
> >>
> >>     CPU apic id is [4,11] instead of [0,7], and we need to check max apic
> >>     id instead of cpu numbers.
> >
> > for logical flat, it really shouldn't matter how large the physical apic id
> > is. In logical flat, OS programs the LDR and the limitation is the
> > number of cpu's which is '8'.
> 
> before i clean up 32bit, 64bit already used max_physical_apicid to
> check if need to switch to physflat.

No. It was introduced by your commit e0da33646826b66ef933d47ea2fb7a693fd849bf

we were using num_possible_cpus > 8 check before.

> for 32bit, if not switch to bigsmp, cpu with physical apic id >=8 can
> not be started by BSP.

why?

thanks,
suresh
