Return-Path: <linux-kernel-owner+w=401wt.eu-S936187AbXGWVKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936187AbXGWVKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759749AbXGWVKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:10:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:21260 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757576AbXGWVKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:10:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,572,1175497200"; 
   d="scan'208";a="253756357"
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
From: "Li, Tong N" <tong.n.li@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <p73ir8aubzx.fsf@bingen.suse.de>
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com>
	 <p73ir8aubzx.fsf@bingen.suse.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 23 Jul 2007 14:10:15 -0700
Message-Id: <1185225015.3593.15.camel@tongli.jf.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
X-OriginalArrivalTime: 23 Jul 2007 21:10:16.0313 (UTC) FILETIME=[DE01AE90:01C7CD6D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I benchmarked an early version of this code (against 2.6.21) with
SPECjbb, SPEComp, kernbench, etc. on an 8-processor system, and didn't
see any slowdown compared to the stock scheduler. I'll generate the data
again with this version of the code. On the other hand, if locking does
become a problem for certain systems/workloads, increasing
sysctl_base_round_slice can reduce the locking frequency and alleviate
the problem, at the cost of being relatively less fair across the CPUs. 

  tong

On Mon, 2007-07-23 at 22:00 +0200, Andi Kleen wrote:
> Tong Li <tong.n.li@intel.com> writes:
> > +
> > +        read_lock_irqsave(&dwrr_highest_lock, flags);
> 
> That lock looks like it would bounce between CPUs like crazy.
> Did you try any benchmarks on a larger system? 
> 
> -Andi
