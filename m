Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbXDXPGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbXDXPGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 11:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbXDXPGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 11:06:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:24182 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbXDXPGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 11:06:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="218704496:sNHT20143662"
Date: Fri, 20 Apr 2007 13:11:01 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
Message-ID: <20070420201101.GC5475@linux-os.sc.intel.com>
References: <20070418175017.GA5250@elte.hu> <20070418212645.GU2986@holomorphy.com> <Pine.LNX.4.64.0704201223280.21417@schroedinger.engr.sgi.com> <20070420192906.GB2986@holomorphy.com> <Pine.LNX.4.64.0704201231250.21514@schroedinger.engr.sgi.com> <20070420193856.GC2986@holomorphy.com> <Pine.LNX.4.64.0704201243280.21514@schroedinger.engr.sgi.com> <20070420200322.GD2986@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420200322.GD2986@holomorphy.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 01:03:22PM -0700, William Lee Irwin III wrote:
> On Fri, 20 Apr 2007, William Lee Irwin III wrote:
> >> I'm not really convinced it's all that worthwhile of an optimization,
> >> essentially for the same reasons as you, but presumably there's a
> >> benchmark result somewhere that says it matters. I've just not seen it.
> 
> On Fri, Apr 20, 2007 at 12:44:55PM -0700, Christoph Lameter wrote:
> > If it is true that we frequently remotely write the per cpu runqueue 
> > data then we may have a NUMA scalability issue.
> 
> From the discussion on Suresh's thread, it appears to have sped up a
> database benchmark 0.5%.
> 
> Last I checked it was workload-dependent, but there were things that
> hammer it. I mostly know of the remote wakeup issue, but there could
> be other things besides wakeups that do it, too.

remote wakeup was the main issue and the 0.5% improvement was seen
on a two node platform. Aligning it reduces the number of remote
cachelines that needs to be touched as part of this wakeup.

thanks,
suresh
