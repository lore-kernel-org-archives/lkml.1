Return-Path: <linux-kernel-owner+w=401wt.eu-S1758325AbXFZQ7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325AbXFZQ7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 12:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbXFZQ72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 12:59:28 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48471 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748AbXFZQ71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 12:59:27 -0400
Subject: Re: [patch, v2.6.22-rc6] sys_time() speedup
From: john stultz <johnstul@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070626145825.GA31076@elte.hu>
References: <20070625200601.GA18980@elte.hu> <46805C4F.1050200@rtr.ca>
	 <20070626145825.GA31076@elte.hu>
Content-Type: text/plain
Date: Tue, 26 Jun 2007 09:59:24 -0700
Message-Id: <1182877164.1437.49.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-26 at 16:58 +0200, Ingo Molnar wrote:
> * Mark Lord <lkml@rtr.ca> wrote:
> 
> > Ingo Molnar wrote:
> > >Subject: [patch] sys_time() speedup
> > >From: Ingo Molnar <mingo@elte.hu>
> > >
> > >improve performance of sys_time(). sys_time() returns time in seconds, 
> > >but it does so by calling do_gettimeofday() and then returning the 
> > >tv_sec portion of the GTOD time. But the data structure "xtime", which 
> > >is updated by every timer/scheduler tick, already offers HZ granularity 
> > >time.
> > 
> > How well synchronized is xtime with real-time ?
> 
> it's updated by every jiffy.

Well, NTP_INTERVAL_LENGTH to be specific which is every jiffie with one
exception: With dynticks this is a bit more complicated, and xtime is
updated only twice a second.

thanks
-john

