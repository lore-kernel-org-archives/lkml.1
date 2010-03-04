Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab0CDIu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 03:50:28 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:13115
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754145Ab0CDIuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 03:50:25 -0500
X-SpamScore: -24
X-BigFish: VPS-24(zz1432R98dN936eM62a3Lzz1202hzzz32i6bh2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KYR1VN-02-GN1-02
X-M-MSG: 
Date: Thu, 4 Mar 2010 09:50:07 +0100
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       eranian@google.com, fweisbec@gmail.com
Subject: Re: [RFC][PATCH 06/11] perf, x86: PEBS infrastructure
Message-ID: <20100304085007.GM13205@erda.amd.com>
References: <20100303163936.906011640@chello.nl>
 <20100303164306.299625712@chello.nl>
 <20100303173802.GL13205@erda.amd.com>
 <1267638168.25158.98.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1267638168.25158.98.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 Mar 2010 08:50:08.0342 (UTC) FILETIME=[B14A4F60:01CABB77]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.03.10 18:42:48, Peter Zijlstra wrote:
> On Wed, 2010-03-03 at 18:38 +0100, Robert Richter wrote:
> > > +     fake_cpuc = kmalloc(sizeof(*fake_cpuc), GFP_KERNEL | __GFP_ZERO);
> > > +     if (!fake_cpuc)
> > > +             return -ENOMEM;
> > > +
> > > +     c = x86_pmu.get_event_constraints(fake_cpuc, event);
> > > +
> > > +     if (!c || !c->weight)
> > > +             ret = -ENOSPC;
> > > +
> > > +     if (x86_pmu.put_event_constraints)
> > > +             x86_pmu.put_event_constraints(fake_cpuc, event);
> > 
> > A fake cpu with the struct filled with zeros will cause a null pointer
> > exception in amd_get_event_constraints():
> > 
> >         struct amd_nb *nb = cpuc->amd_nb;
> 
> That should result in nb == NULL, right? which is checked slightly
> further in the function.

Yes, right. The problem was in your earlier version of this code where
fake_cpuc was a null pointer. The check in amd_get_event_constraints()
for nb should work.

-Robert

> 
> > Shouldn't x86_schedule_events() sufficient to decide if a single
> > counter is available? I did not yet look at group events, this might
> > happen there too.
> 
> Sure, but we will only attempt scheduling them at enable time, this is a
> creation time check, failing to create an unschedulable event seems
> prudent.
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

