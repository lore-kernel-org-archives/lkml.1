Return-Path: <linux-kernel-owner+w=401wt.eu-S1767351AbXDEVuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767351AbXDEVuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 17:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767352AbXDEVuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 17:50:44 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49540 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767351AbXDEVun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 17:50:43 -0400
Subject: Re: [PATCH] timekeeping: drop irq-context clocksource polling
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
In-Reply-To: <20070405143641.a751f43e.akpm@linux-foundation.org>
References: <20070405210316.785839431@mvista.com>
	 <1175808319.28526.26.camel@localhost>
	 <20070405143641.a751f43e.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 14:50:34 -0700
Message-Id: <1175809834.28526.34.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 14:36 -0700, Andrew Morton wrote:
> On Thu, 05 Apr 2007 14:25:19 -0700
> john stultz <johnstul@us.ibm.com> wrote:
> 
> > On Thu, 2007-04-05 at 14:03 -0700, Daniel Walker wrote:
> > > Before this change the timekeeping code would poll the clocksource
> > > list every interrupt. This changes that so the clocksource list is
> > > only checked when there has been and update, and no longer checks
> > > in interrupt context.
> > > 
> > > This also has a few small space and line cleanups.
> > > 
> > > Boot tested on i386, compile tested on x86_64 .. However, I couldn't
> > > find a !GENERIC_TIME that compiled without this change so it's untested..
> > > 
> > > Signed-Off-By: Daniel Walker <dwalker@mvista.com>
> > 
> > Err.. I think you need to be holding a write on the xtime_lock (as is
> > done before calling update_wall_time()) when changing the clocksource.
> 
> The patch does add the appropriate locking to change_clocksource(),
> doesn't it?

Yep. Sorry for the confusion, reading too hastily. 

> It looks like a good change to me - we avoid taking the kernel-wide
> clocksource_lock every tick?

Agreed.

Acked-by: John Stultz <johnstul@us.ibm.com>

-john


