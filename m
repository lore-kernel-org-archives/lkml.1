Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbXCEVLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbXCEVLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbXCEVLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:11:44 -0500
Received: from mail32.syd.optusnet.com.au ([211.29.132.63]:46755 "EHLO
	mail32.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752892AbXCEVLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:11:43 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] [RSDL 5/6] sched: implement rsdl cpu scheduler
Date: Tue, 6 Mar 2007 08:11:21 +1100
User-Agent: KMail/1.9.5
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>
References: <200703041806.22965.kernel@kolivas.org> <20070305203857.GQ16722@waste.org>
In-Reply-To: <20070305203857.GQ16722@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703060811.21316.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 March 2007 07:38, Matt Mackall wrote:
> On Sun, Mar 04, 2007 at 06:06:22PM +1100, Con Kolivas wrote:
> > + * This is the time all tasks within the same priority round robin.
> > + * Set to a minimum of 6ms.
> >   */
> > +#define RR_INTERVAL		((6 * HZ / 1001) + 1)
>
> What happens with small HZ? Like 100? I suppose 10ms is a reasonable
> number here. But in general, how well does this scheduler do without a
> time source other than jiffies?

Perfectly fine at 100. It only needs to do accounting during a busy tick, and 
on dynticks we always service a timer interrupt during that busy tick so it 
works fine there as well. In fact, choosing a lower HZ you are indirectly 
making a decision that you don't value latency as much as at the higher HZ 
and 10ms is fine for the scheduling there. It would be possible to service 
the cpu accounting with any timer that fired at at least 100HZ even if there 
was some way to turn ticks off fully when the cpu is busy (which there isn't 
currently a way to do).

-- 
-ck
