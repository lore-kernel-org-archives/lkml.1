Return-Path: <linux-kernel-owner+w=401wt.eu-S1767176AbXDEVax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767176AbXDEVax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 17:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767326AbXDEVax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 17:30:53 -0400
Received: from homer.mvista.com ([63.81.120.158]:35224 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1767176AbXDEVaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 17:30:52 -0400
Subject: Re: [PATCH] timekeeping: drop irq-context clocksource polling
From: Daniel Walker <dwalker@mvista.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu
In-Reply-To: <1175808319.28526.26.camel@localhost>
References: <20070405210316.785839431@mvista.com>
	 <1175808319.28526.26.camel@localhost>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 14:29:27 -0700
Message-Id: <1175808567.15973.137.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 14:25 -0700, john stultz wrote:
> On Thu, 2007-04-05 at 14:03 -0700, Daniel Walker wrote:
> > Before this change the timekeeping code would poll the clocksource
> > list every interrupt. This changes that so the clocksource list is
> > only checked when there has been and update, and no longer checks
> > in interrupt context.
> > 
> > This also has a few small space and line cleanups.
> > 
> > Boot tested on i386, compile tested on x86_64 .. However, I couldn't
> > find a !GENERIC_TIME that compiled without this change so it's untested..
> > 
> > Signed-Off-By: Daniel Walker <dwalker@mvista.com>
> 
> Err.. I think you need to be holding a write on the xtime_lock (as is
> done before calling update_wall_time()) when changing the clocksource.

I added a write_seqlock_irqsave() on xtime_lock in
change_clocksource() .. Did I need more (different) protection than
that?

Daniel

