Return-Path: <linux-kernel-owner+w=401wt.eu-S1759596AbYDKIB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596AbYDKIB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 04:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758089AbYDKIBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 04:01:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39063 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997AbYDKIBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 04:01:39 -0400
Date: Fri, 11 Apr 2008 10:06:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Karsten Wiese <fzu@wemgehoertderstaat.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set_cyc2ns_scale() remove tsc_now and ns_now
Message-ID: <20080411080617.GP10019@one.firstfloor.org>
References: <200804102331.11815.fzu@wemgehoertderstaat.de> <873apsn8g7.fsf@basil.nowhere.org> <20080411075554.GA6834@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411075554.GA6834@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 09:55:54AM +0200, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > (actually it is still the wrong time -- really needs a grace period 
> > during which the TSC is not used 
> > ftp://firstfloor.org/pub/ak/quilt/patches/sched-clock implemented some 
> > of these ideas against an older kernel)
> 
> recent CPUs have constant-freq TSCs so it's mostly a legacy issue, but 

Actually there millions of non constant freq TSC CPUs shipped each
quarter ... 

> we dont really have to worry about complications like grace periods - 
> higher layers in the scheduler protect against temporary sched_clock() 
> outliers.

But you still get scheduling hickups even with the sanity check. If the 
scheduler depends on a smooth time that is not good and my (admittedly much less 
than yours) understanding of CFS is that it relies on that. Especially ondemand 
can cause quite a lot of cpufreq changes on some workloads.

> So i think this can all be done much simpler. Just get rid of 
> the global cpu_khz notion, sched_clock() should simply follow the ->freq 
> value - and that's it.

At some point you have to generate an offset to something and that
offset must be different for different frequencies, otherwise
you get large systematic errors

(<imagine complicated mathematical proof why this is so, but it should
be fairly obvious>)

-Andi

