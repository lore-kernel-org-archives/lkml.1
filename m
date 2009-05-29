Return-Path: <linux-kernel-owner+w=401wt.eu-S1756314AbZE2ITe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314AbZE2ITe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 04:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbZE2ITV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 04:19:21 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:63674 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbZE2ITU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 04:19:20 -0400
X-SourceIP: 213.93.53.227
Subject: Re: comments on Performance Counters for Linux (PCL)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: eranian@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <cel@us.ibm.com>, Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
In-Reply-To: <20090529065104.GO1065@one.firstfloor.org>
References: <7c86c4470905280758y6d359823h2a7517dfecb115e6@mail.gmail.com>
	 <1243527919.6645.75.camel@laptop>
	 <20090529065104.GO1065@one.firstfloor.org>
Content-Type: text/plain
Date: Fri, 29 May 2009 10:19:18 +0200
Message-Id: <1243585158.23657.175.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-29 at 08:51 +0200, Andi Kleen wrote:
> > >        Take Itanium, it has 4 priv levels and the PMU counters can monitor at
> > >        any priv levels or combination thereof?
> > 
> > x86 has more priv rings too, but linux only uses 2, kernel (ring 0) and
> > user (ring 2 iirc). Does ia64 expose more than 2 priv levels in linux?
> 
> In a hardware virtualized environment x86 Linux uses at least four.

You're talking about VT stuff, right? Does that virtualize the PMU too?
otherwise the point it moot since it will have to arbitrate the PMU and
the guest will likely never see the HV.

Or are you talking about Xen like horrors where they run 'guest' dom0
and domu in separate rings? That would still need to arbitrate the PMU
between guests.

> And yes ia64 also exposes more I believe, e.g. it has the fancy
> "system calls that run in user context"

Happen to have more details? If they really run in user context their
priv level would be the same right, otherwise they run in something
weird, not quite user not quite kernel. Now that might be the case, but
I'm utterly ignorant on itanic.

