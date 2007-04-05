Return-Path: <linux-kernel-owner+w=401wt.eu-S1767346AbXDEViJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767346AbXDEViJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 17:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767329AbXDEViI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 17:38:08 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:57604 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767348AbXDEViH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 17:38:07 -0400
Subject: Re: [PATCH] timekeeping: drop irq-context clocksource polling
From: john stultz <johnstul@us.ibm.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu
In-Reply-To: <1175808567.15973.137.camel@imap.mvista.com>
References: <20070405210316.785839431@mvista.com>
	 <1175808319.28526.26.camel@localhost>
	 <1175808567.15973.137.camel@imap.mvista.com>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 14:38:02 -0700
Message-Id: <1175809082.28526.28.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 14:29 -0700, Daniel Walker wrote:
> On Thu, 2007-04-05 at 14:25 -0700, john stultz wrote:
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
> I added a write_seqlock_irqsave() on xtime_lock in
> change_clocksource() .. Did I need more (different) protection than
> that?

Nope. You're ok there. I just missed it and then I tried to cancel my
mail from being sent, but apparently it still got out. whoops! :)

-john


