Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbZE0UdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbZE0UdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbZE0Ucm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:32:42 -0400
Received: from www.tglx.de ([62.245.132.106]:50297 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007AbZE0Uck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:32:40 -0400
Date: Wed, 27 May 2009 22:32:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: Jon Hunter <jon-hunter@ti.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] Dynamic Tick: Prevent clocksource wrapping during
 idle
In-Reply-To: <1243455615.7440.17.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0905272229190.3397@localhost.localdomain>
References: <4A1D52E3.3040204@ti.com>  <alpine.LFD.2.00.0905271731070.3397@localhost.localdomain> <1243455615.7440.17.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, john stultz wrote:
> >   Why do you want to recalculate the whole stuff over and over ?
> > 
> >   That computation can be done when the clock source is initialized or
> >   any fundamental change of the clock parameters happens.
> > 
> >   Stick that value into the clocksource struct and just read it out.
> 
> Sigh. 
> 
> I was hoping to avoid hanging another bit of junk off of the clocksource
> struct. 

Sure, but buying that 8 bytes with Einsteinian insanity is nuts.
 
> But I guess we could compute that value on registration and keep it
> around. Changes to mult could effect things, but should be well within
> the 6% safety net we give ourselves.

That was my thought as well, but even if we have to go to 12% it's way
better than doing repeated nonsense on the way to idle.

Thanks,

	tglx
