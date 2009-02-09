Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbZBIVgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbZBIVgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbZBIVgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:36:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:17816 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729AbZBIVgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:36:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,406,1231142400"; 
   d="scan'208";a="385383144"
Subject: Re: [PATCH] x86: Add clflush before monitor for Intel 7400 series
 - v2
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, H Peter Anvin <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200902091653.26570.nickpiggin@yahoo.com.au>
References: <20090207004728.GA17586@linux-os.sc.intel.com>
	 <20090207140245.1e91a88f@lxorguk.ukuu.org.uk>
	 <20090207164707.GA19149@linux-os.sc.intel.com>
	 <200902091653.26570.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 13:37:17 -0800
Message-Id: <1234215437.4286.396.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-08 at 21:53 -0800, Nick Piggin wrote:
> On Sunday 08 February 2009 03:47:07 Pallipadi, Venkatesh wrote:
> > On Sat, Feb 07, 2009 at 06:02:45AM -0800, Alan Cox wrote:
> > > On Fri, 6 Feb 2009 16:47:29 -0800
> > >
> > > "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:
> > > > For Intel 7400 series CPUs, the recommendation is to use a clflush on
> > > > the monitored address just before monitor and mwait pair [1]. This
> > > > clflush makes sure that there are no false wakeups from mwait when the
> > > > monitored address was recently written to.
> > >
> > > Given our mwait usages will very quickly go back to sleep in such a case
> > > and it would almost certainly be one sleep only is this really worth the
> > > effort ?
> >
> > Yes. If we only consider the CPU idle behavior, we really do not need the
> > patch as we will go back to idle. But, there are other factors:
> > - drivers/idle/i7300_idle.c  which tries to save memory power based on CPU
> >   idle time. It gets confused with these short idles.
> > - cpuidle menu governor  These platforms may also support more than one
> > C-state. C1 and CC3. So, we will go through the C-state policy in menu
> > governor, which again looks at idle time and may end up taking wrong
> > decisions due to these short idles.
> >
> > We can make the above code to be more clever, to ignore short idles. But,
> > this patch seems to be the easier and clean way as the errata is only in a
> > particular CPU model.
> 
> Have you benchmarked it? With something like tbench which IIRC should
> generate a good number of idle/busy transitions?
> 

We haven't run tbench specifically. But, we noticed this issue running
specpower workload on this platform. Especially the 10-20% point of
specpower, which also has notable idle/busy transitions, this patch
helps.

Thanks,
Venki


