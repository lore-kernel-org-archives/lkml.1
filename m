Return-Path: <linux-kernel-owner+w=401wt.eu-S1756052AbYIDWJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbYIDWJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 18:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbYIDWJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 18:09:46 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:33848 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752516AbYIDWJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 18:09:46 -0400
Subject: Re: [RFC patch 0/4] TSC calibration improvements
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <alpine.LFD.1.10.0809041447570.3117@nehalem.linux-foundation.org>
References: <20080904150339.896115280@linutronix.de>
	 <20080904153620.GC7120@elte.hu>
	 <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>
	 <20080904160036.GA18382@elte.hu>
	 <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org>
	 <20080904190728.59634020@lxorguk.ukuu.org.uk>
	 <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org>
	 <1220564317.11753.70.camel@alok-dev1>
	 <alpine.LFD.1.10.0809041447570.3117@nehalem.linux-foundation.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 04 Sep 2008 15:09:44 -0700
Message-Id: <1220566184.11753.87.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-04 at 14:52 -0700, Linus Torvalds wrote:
> 
> On Thu, 4 Sep 2008, Alok Kataria wrote:
> >
> > The maximum count value that I see is 84.
> > In one single reboot run, on an average in about 70 iterations the val
> > returned from pit_expect_msb is > 50, and eventually we hit a condition
> > where the value is < 50 and we bail out of the fast method.
> >
> > So just to be on safer side can we be a little less generous and
> > increase the threshold to somewhere around 75 from 50 ? Or is there a
> > good reason not to ?
> 
> Why would you?
> 
> The reason the single run completed successfully was apparently that no
> actual virtualization event triggered, so it actually accessed the
> hardware successfully and without any real slowdown.  As shown also by the
> fact that the actual frequency was correct at the end.
> 
> The ones that failed presumably all had interrupts that happened in the
> VM, which then immediately triggered the "uhhuh, there was a bump" thing.
> 
> IOW, the code worked correctly as designed. It's not a
> "anti-virtualization" feature per se, it's a "detect when virtualization
> screws up timing". When virtualization (or SMI etc) does _not_ screw up
> timing, it all works fine.

Maybe i was just being too paranoid, the slow calibration method has
been known to work correctly even under extreme stress conditions for us
and wanted to make sure that we always take that path.

Anyways I understand your point so lets stick with this value, if there
are any false positives that I see with this i will get back.

Thanks,
Alok




> 
>                         Linus

