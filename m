Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbZLWRIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbZLWRIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 12:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbZLWRIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 12:08:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39287 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbZLWRIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 12:08:34 -0500
Date: Wed, 23 Dec 2009 18:08:32 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Mark Hounschell <markh@compro.net>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>, Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28
Message-ID: <20091223170832.GH20539@basil.fritz.box>
References: <alpine.LFD.2.00.0912220922250.31313@localhost.localdomain> <4B310879.9050701@compro.net> <1261525076.16916.4.camel@localhost.localdomain> <4B3162BC.9000508@cfl.rr.com> <4B3214EC.6020308@compro.net> <6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com> <4B32386B.2060509@compro.net> <alpine.LFD.2.00.0912230828230.6879@localhost.localdomain> <87bphpd4rt.fsf@basil.nowhere.org> <alpine.LFD.2.00.0912230845550.6879@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912230845550.6879@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 08:49:38AM -0800, Linus Torvalds wrote:
> 
> 
> On Wed, 23 Dec 2009, Andi Kleen wrote:
> > 
> > I suspect it's a system where the APIC timer stops in deeper idle
> > states and it supports them. In this case CPU #0 does timer broadcasts
> > when needed to wake the other CPUs up from deep C, but for that it has
> > to run with HPET. At least the other ones can still enjoy the LAPIC
> > timer.
> 
> Ahh, ok, that makes sense. I was assuming the broadcast timer would act in 
> that capacity, but..

The "broadcasts" are done using IPIs from cpu #08 and only when that target 
CPU is deep idle.  That's more efficient than letting the hardware
always broadcast.

> 
> > This might suggest that Mark's floppy controller doesn't like
> > deep C? Mark, did you try booting with processor.max_cstate=1
> > and HPET enabled?
> 
> We have indeed had historical issues with floppy and sleep states before. 

I removed that code when moving to 64bit (floppy driver disabling C1),
but perhaps we need some variant of it again (but it's the first such
report in many years). Although it would be sad to have it again on all 
systems.

-Andi
