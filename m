Return-Path: <linux-kernel-owner+w=401wt.eu-S1030299AbXBGWxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030299AbXBGWxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 17:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422807AbXBGWxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 17:53:07 -0500
Received: from mga06.intel.com ([134.134.136.21]:6588 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030299AbXBGWxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 17:53:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,297,1167638400"; 
   d="scan'208"; a="194117277:sNHT110345767"
Date: Wed, 7 Feb 2007 14:19:19 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: mingo@elte.hu
Cc: Ingo Molnar <mingo@elte.hu>, vatsa@in.ibm.com, clameter@sgi.com,
       tglx@linutronix.de, arjan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Patch: dynticks: idle load balancing
Message-ID: <20070207141919.C19581@unix-os.sc.intel.com>
References: <20061211155304.A31760@unix-os.sc.intel.com> <20061213224317.GA2986@elte.hu> <20061213231316.GA13849@elte.hu> <20061213150314.B12795@unix-os.sc.intel.com> <20061213233157.GA20470@elte.hu> <20061213151926.C12795@unix-os.sc.intel.com> <20061219201247.GA12648@elte.hu> <20061219131223.E23105@unix-os.sc.intel.com> <20070116113505.GA6294@elte.hu> <20070130135709.B32010@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
In-Reply-To: <20070130135709.B32010@unix-os.sc.intel.com>; from suresh.b.siddha@intel.com on Tue, Jan 30, 2007 at 01:57:09PM -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 01:57:09PM -0800, Siddha, Suresh B wrote:
> Please let me know if you still see this issue with the latest -rt kernel.
> 
> On Tue, Jan 16, 2007 at 12:35:05PM +0100, Ingo Molnar wrote:
> > on the latest -rt kernel, when the dynticks load-balancer is enabled, 
> > then a dual-core Core2 Duo test-system increases its irq rate from the 
> > normal 15/17 per second to 300-400/sec - on a completely idle system(!). 
> > Any idea what's going on? I'll disable the load balancer for now.

Ok. got time to look into this.

The answer is simple. load_balancing in the recent kernels is happening
using SCHED_SOFTIRQ and in -rt tree that happens not in the idle process
context but in the context of softirqd for SCHED_SOFTIRQ.

This breaks the dynticks load balancer and also the regular idle load balancing
too :(

Am on to fixing the problem now :)

thanks,
suresh
