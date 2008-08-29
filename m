Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbYH2NSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbYH2NSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 09:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbYH2NSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 09:18:40 -0400
Received: from ditditdahdahdah-dahditditditdit.dl5rb.org.uk ([217.169.26.26]:34551
	"EHLO ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753202AbYH2NSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 09:18:39 -0400
X-Greylist: delayed 1588 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Aug 2008 09:18:37 EDT
Date: Fri, 29 Aug 2008 13:49:16 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <npiggin@suse.de>, Gregory Haskins <ghaskins@novell.com>,
       mingo@elte.hu, srostedt@redhat.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, gregory.haskins@gmail.com,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 3/6] sched: make double-lock-balance fair
Message-ID: <20080829124916.GE16101@linux-mips.org>
References: <20080826173131.16413.17862.stgit@dev.haskins.net> <20080826173500.16413.40514.stgit@dev.haskins.net> <1219825295.6462.54.camel@twins> <20080827102646.GA5818@wotan.suse.de> <1219833668.6462.72.camel@twins> <20080827105615.GB5818@wotan.suse.de> <1219835224.6462.81.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219835224.6462.81.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 01:07:04PM +0200, Peter Zijlstra wrote:

> > BTW. I wonder about other architectures that are of interest to -rt? Like
> > mips or arm perhaps... Any plans to implement ticket locks on those, or
> > do they not tend to be used in SMP configurations on -rt yte?
> 
> I think both are starting to show more and more SMP machines, so yes,
> eventually we'll want ticket locks for them too.
> 
> That said, I'm not aware of anyone working on it - I suppose we could
> poke the regular arch maintainers.. Ralf, Russell ?

I looked into this a bit and we definately need it.  One large MIPS user
already had converted his kernel to ticket locks due to an excessive
number of cacheline bounces having been observed.

  Ralf
