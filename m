Return-Path: <linux-kernel-owner+w=401wt.eu-S1761677AbXGYVP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761677AbXGYVP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 17:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbXGYVPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 17:15:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:11522 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbXGYVPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 17:15:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,581,1175497200"; 
   d="scan'208";a="272700956"
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
From: "Li, Tong N" <tong.n.li@intel.com>
To: Chris Snook <csnook@redhat.com>
Cc: Chris Friesen <cfriesen@nortel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <46A7B8A9.4040400@redhat.com>
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com>
	 <20070725110159.GA15076@elte.hu> <20070725120358.GA30755@elte.hu>
	 <Pine.LNX.4.64.0707251014520.14515@tongli.jf.intel.com>
	 <20070725192442.GC4463@elte.hu> <46A7B4DE.4030301@nortel.com>
	 <46A7B8A9.4040400@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 25 Jul 2007 14:15:48 -0700
Message-Id: <1185398148.3162.5.camel@tongli.jf.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
X-OriginalArrivalTime: 25 Jul 2007 21:15:49.0183 (UTC) FILETIME=[F93D1CF0:01C7CF00]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-25 at 16:55 -0400, Chris Snook wrote:
> Chris Friesen wrote:
> > Ingo Molnar wrote:
> > 
> >> the 3s is the problem: change that to 60s! We no way want to 
> >> over-migrate for SMP fairness, the change i did gives us reasonable 
> >> long-term SMP fairness without the need for high-rate rebalancing.
> > 
> > Actually, I do have requirements from our engineering guys for 
> > short-term fairness.  They'd actually like decent fairness over even 
> > shorter intervals...1 second would be nice, 2 is acceptable.
> > 
> > They are willing to trade off random peak performance for predictability.
> > 
> > Chris
> > 
> 
> The sysctls for CFS have nanosecond resolution.  They default to 
> millisecond-order values, but you can set them much lower.  See sched_fair.c for 
> the knobs and their explanations.
> 
> 	-- Chris

This is incorrect. Those knobs control local-CPU fairness granularity
but have no control over fairness across CPUs.

I'll do some benchmarking as Ingo suggested.

  tong
