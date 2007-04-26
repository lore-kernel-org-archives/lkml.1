Return-Path: <linux-kernel-owner+w=401wt.eu-S1031367AbXDZR5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031367AbXDZR5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031376AbXDZR5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:57:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:20597 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031367AbXDZR5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:57:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,456,1170662400"; 
   d="scan'208";a="79671382"
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
From: "Li, Tong N" <tong.n.li@intel.com>
To: Willy Tarreau <w@1wt.eu>
Cc: William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
In-Reply-To: <20070425201309.GA5646@1wt.eu>
References: <20070424212717.GR31925@holomorphy.com>
	 <5FD5754DDBA0B1499B5A0B4BB5419485F72D3C@fmsmsx411.amr.corp.intel.com>
	 <20070425094403.GA3290@elte.hu> <20070425115840.GT31925@holomorphy.com>
	 <20070425201309.GA5646@1wt.eu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 26 Apr 2007 10:57:48 -0700
Message-Id: <1177610268.3360.35.camel@tongli.jf.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 26 Apr 2007 17:57:50.0142 (UTC) FILETIME=[6799CDE0:01C7882C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-25 at 22:13 +0200, Willy Tarreau wrote:
> On Wed, Apr 25, 2007 at 04:58:40AM -0700, William Lee Irwin III wrote:
> 
> > Adjustments to the lag computation for for arrivals and departures
> > during execution are among the missing pieces. Some algorithmic devices
> > are also needed to account for the varying growth rates of lags of tasks
> > waiting to run, which arise from differing priorities/weights.
> 
> that was the principle of my proposal of sorting tasks by expected completion
> time and using +/- credit to compensate for too large/too short slice used.
> 
> Willy

Yeah, it's a good algorithm. It's a variant of earliest deadline first
(EDF). There are also similar ones in the literature such as earliest
eligible virtual deadline first (EEVDF) and biased virtual finishing
time (BVFT). Based on wli's explanation, I think Ingo's approach would
also fall into this category. With careful design, all such algorithms
that order tasks based on some notion of time can achieve good fairness.
There are some subtle differences. Some algorithms of this type can
achieve a constant lag bound, but some only have a constant positive lag
bound, but O(N) negative lag bound, meaning some tasks could receive
much more CPU time than it would under ideal fairness when the number of
tasks is high.

On the other hand, the log(N) complexity of this type of algorithms has
been a concern in the research community. This motivated O(1)
round-robin based algorithms such as deficit round-robin (DRR) and
smoothed round-robin (SRR) in networking, and virtual-time round-robin
(VTRR), group ratio round-robin (GP3) and grouped distributed queues
(GDQ) in OS scheduling, as well as the distributed weighted round-robin
(DWRR) one I posted earlier.

  tong
