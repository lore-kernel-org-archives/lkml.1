Return-Path: <linux-kernel-owner+w=401wt.eu-S1764719AbXFAUkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764719AbXFAUkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762968AbXFAUki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:40:38 -0400
Received: from mx1.suse.de ([195.135.220.2]:46723 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762465AbXFAUkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:40:37 -0400
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Dependent CPU core speed reporting not updated with CPUFREQ_SHARED_TYPE_HW?
References: <460C5D24.608@us.ibm.com>
	<653FFBB4508B9042B5D43DC9E18836F52DF4D8@scsmsx415.amr.corp.intel.com>
	<20070601184342.GA13751@tree.beaverton.ibm.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 Jun 2007 23:37:07 +0200
In-Reply-To: <20070601184342.GA13751@tree.beaverton.ibm.com>
Message-ID: <p73ejkvbblo.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Darrick J. Wong" <djwong@us.ibm.com> writes:

> On Thu, Mar 29, 2007 at 06:06:22PM -0700, Pallipadi, Venkatesh wrote:
> > thought of
> > making affected CPUs show the dependency in case of hw coord, but
> > retaining the percpu
> > control. But, it seemed complicated change for something that is
> > cosmetic.
> 
> Actually, it's not so cosmetic any more.  Our newest servers have a
> power meter that measures power consumption, and I'm writing a program
> to measure the power cost of various cpufreq transitions in order to
> enforce a power cap.  

How would that work? You would adjust the power cap dynamically during
runtime based on the power meter feedback?  How long would 
the adjustment interval be?

> Due to the under-reporting in affected_cpus, the
> app thinks that (taking your example above) CPUs 0 and 2 can be
> controlled independently.  Thus, a p-state transition of (x, x) ->
> (x, x-1) yields no energy saving at all, while (x, x-1) -> (x-1, x-1)
> does.  My program considers the effects of a single CPU's transition
> independently of which CPU it is and without considering what
> frequencies the other CPUs are operating at, which means that it will
> conclude that the cost of increasing speed (or the reward for decreasing
> it) is half of what it is ... sort of.  It's mildly broken as a result,
> though amusingly enough it still seems to work ok.  I suspect that it
> might flail around trying to hit a cap a bit more than it would if
> affected_cpus were more accurate.

Not sure affected CPUs is accurate enough for your purposes anyways.
It cannot express "other core can be independent if I'm idle, otherwise not"
which is common on Intel systems.

-Andi
