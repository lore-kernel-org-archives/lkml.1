Return-Path: <linux-kernel-owner+w=401wt.eu-S1753585AbYCOESk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbYCOESk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 00:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbYCOESd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 00:18:33 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:60831 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbYCOESc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 00:18:32 -0400
Date: Sat, 15 Mar 2008 05:18:24 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 7/8] Remove current_tick_length()
In-Reply-To: <1205552909.6122.63.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0803150511580.1791@scrub.home>
References: <20080314184001.695807682@linux-m68k.org> 
 <20080314195737.153531685@linux-m68k.org>  <1205548860.6122.55.camel@localhost.localdomain>
  <Pine.LNX.4.64.0803150429500.1791@scrub.home> <1205552909.6122.63.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 14 Mar 2008, john stultz wrote:

> > Why would someone do something silly like this?
> 
> Its not a huge deal, but we've seen globally scoped timekeeping
> variables misused either accidentally or intentionally. Awhile back ppc
> was corrupting time_offset by using it for a timezone offset value. 
> 
> So I think its a valid maintainability issue.

ppc used to do a whole lot more than that, so I don't think that counts as 
a valid example.
tick_length is overwritten at every timer and modifying it would have 
barely any effect compared to other values which are already exported.

> > > Is there any additional rational for this change?
> > 
> > Useless bloat?
> 
> I agree its a trade off. But do you have performance numbers to make the
> maintainability trade off worth it? (I admit, it is used in the
> timer_interrupt, so it may very well be worth it, but we might want to
> check first).

It depends on the architecture, but it's effects regularly executed code 
and every byte counts.

bye, Roman
