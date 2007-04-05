Return-Path: <linux-kernel-owner+w=401wt.eu-S1767342AbXDEVg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767342AbXDEVg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 17:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767340AbXDEVg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 17:36:59 -0400
Received: from smtp.osdl.org ([65.172.181.24]:53514 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767343AbXDEVg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 17:36:58 -0400
Date: Thu, 5 Apr 2007 14:36:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH] timekeeping: drop irq-context clocksource polling
Message-Id: <20070405143641.a751f43e.akpm@linux-foundation.org>
In-Reply-To: <1175808319.28526.26.camel@localhost>
References: <20070405210316.785839431@mvista.com>
	<1175808319.28526.26.camel@localhost>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Apr 2007 14:25:19 -0700
john stultz <johnstul@us.ibm.com> wrote:

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

The patch does add the appropriate locking to change_clocksource(),
doesn't it?

It looks like a good change to me - we avoid taking the kernel-wide
clocksource_lock every tick?

