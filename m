Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbYCODsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbYCODsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 23:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbYCODsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 23:48:35 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46989 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbYCODsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 23:48:35 -0400
Subject: Re: [PATCH 7/8] Remove current_tick_length()
From: john stultz <johnstul@us.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <Pine.LNX.4.64.0803150429500.1791@scrub.home>
References: <20080314184001.695807682@linux-m68k.org>
	 <20080314195737.153531685@linux-m68k.org>
	 <1205548860.6122.55.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0803150429500.1791@scrub.home>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 20:48:29 -0700
Message-Id: <1205552909.6122.63.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-03-15 at 04:32 +0100, Roman Zippel wrote:
> Hi,
> 
> On Fri, 14 Mar 2008, john stultz wrote:
> 
> > On Fri, 2008-03-14 at 19:40 +0100, zippel@linux-m68k.org wrote:
> > > plain text document attachment (tick_length)
> > > current_tick_length used to do a little more, but now it just returns
> > > tick_length, which we can also access directly at the few places, where
> > > it's needed.
> > > 
> > > Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
> > 
> > Hrm. I'm not sure I like using a global variable instead of using an
> > accessor function. At least with the accessor function folks couldn't
> > just tweak the value outside ntp as easily.
> 
> Why would someone do something silly like this?

Its not a huge deal, but we've seen globally scoped timekeeping
variables misused either accidentally or intentionally. Awhile back ppc
was corrupting time_offset by using it for a timezone offset value. 

So I think its a valid maintainability issue.

> > Is there any additional rational for this change?
> 
> Useless bloat?

I agree its a trade off. But do you have performance numbers to make the
maintainability trade off worth it? (I admit, it is used in the
timer_interrupt, so it may very well be worth it, but we might want to
check first).

thanks
-john


