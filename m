Return-Path: <linux-kernel-owner+w=401wt.eu-S940557AbXGSRgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940557AbXGSRgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939585AbXGSRgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:36:13 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:30846 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939472AbXGSRgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:36:11 -0400
Subject: Re: [PATCH] [15/58] i386: Rewrite sched_clock
From: Daniel Walker <dwalker@mvista.com>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <200707191922.34388.ak@suse.de>
References: <200707191154.642492000@suse.de> <200707191913.27946.ak@suse.de>
	 <1184865339.6458.21.camel@dhcp193.mvista.com>
	 <200707191922.34388.ak@suse.de>
Content-Type: text/plain
Date: Thu, 19 Jul 2007 10:31:56 -0700
Message-Id: <1184866316.6458.31.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-19 at 19:22 +0200, Andi Kleen wrote:
> On Thursday 19 July 2007 19:15:38 Daniel Walker wrote:
> > On Thu, 2007-07-19 at 19:13 +0200, Andi Kleen wrote:
> > > > What about using the cycles2ns() clocksource helpers, it would eliminate
> > > > the duplication of the shift/multiply math .
> > > 
> > > They are completely different from what clocksource provides.
> > 
> > How so?
> 
> The new sched_clock's works CPU local and relative to the last sync point. 
> 

Right, I guess I'm speaking more low-level than that .. Both function do
shift-multiply style math .. So between the two the cycles to
nanoseconds conversion code is duplicated, and the code to calculate the
multiply value is duplicated ..

>From my perspective a downside to sched_clock is that the math is
duplicated per architecture .. I think it would be a win to use the
generic functions if it's possible..

Daniel

