Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbYFXTLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbYFXTLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 15:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYFXTLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 15:11:37 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:30193 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbYFXTLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 15:11:36 -0400
Subject: Re: [RFC][PATCH] putback_lru_page()/unevictable page handling
	rework v3
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20080624105527.d9e9eba0.akpm@linux-foundation.org>
References: <20080621185408.E832.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080624114006.D81C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <1214327453.6563.14.camel@lts-notebook>
	 <20080624105527.d9e9eba0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Organization: HP/OSLO
Date: Tue, 24 Jun 2008 15:11:29 -0400
Message-Id: <1214334689.6563.63.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-24 at 10:55 -0700, Andrew Morton wrote:
> On Tue, 24 Jun 2008 13:10:53 -0400 Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> 
> > On Tue, 2008-06-24 at 11:43 +0900, KOSAKI Motohiro wrote:
> > > Hi
> > > 
> > > > I merged kamezawa-san's SHMEM related fix.
> > > > this patch works well >2H.
> > > > and, I am going to test on stress workload during this week end.
> > > > 
> > > > but I hope recieve review at first.
> > > > thus I post it now.
> > > 
> > > Unfortunately, my machine crashed last night ;-)
> > > I'll dig it.
> > 
> > 
> > I ran 26-rc5-mm3 with 5 split/unevictable lru patches that you posted on
> > 19june.  I replaced patch 5 of that series with the subject patch
> > [rework v3, merged SHMEM fix].  This kernel ran my 'usex' stress load
> > overnight for 23+ hours on both ia64 and x86_64 platforms with no
> > problems.  I evidently did not hit the problem you did.
> > 
> > I'm rebuilding with a patch to a small problem that I discovered along
> > with your recent patch to "prevent incorrect oom...".  I'll let you know
> > how that goes as well.
> > 
> > I'll send along two additional patches shortly.
> > 
> 
> My chances of working out which patches I need to apply to -mm are
> near-zero.  I'm working through my vacation backlog in reverse order
> and haven't got up to this topic yet.
> 
> As you've been paying attention it would be appreciated if you could
> send me some stuff, please.

I saw your prior mail to Rik about this, but seem to have deleted it :(.

The stack that I'm currently running atop 26-rc5-mm3 contains the
following:

>From Kosaki Motohiro ~19jun:
[-mm][PATCH 1/5]  fix munlock page table walk
[-mm][PATCH 2/5] migration_entry_wait fix.
[-mm][PATCH 3/5] collect lru meminfo statistics from correct offset
[-mm][PATCH 4/5]  fix incorrect Mlocked field of /proc/meminfo.
The following patch replaces 5/5:
[RFC][PATCH] putback_lru_page()/unevictable page handling rework v3
The following "rfc" was acked by Rik:
[RFC][PATCH] prevent incorrect oom under split_lru

Two that I posted today [24Jun]--fixes to the "rework v3" patch:
[PATCH] fix to putback_lru_page()/unevictable page handling rework
[PATCH] fix2 to putback_lru_page()/unevictable page handling
﻿
The resulting kernel has been running well on my largish ia64 and x86_64
platforms under a work load that I use to stress reclaim, swapping,
mlocking, ...  However, Kosaki-san is apparently still experiencing
panics with a cpuset migration scenario discovered by ﻿Daisuke
Nishimura.  We're still investigating the crash, but the patches listed
above, despite the "rfc" on a couple of them, are an improvement over
26-rc5-mm3.

I believe that Rik has at least one other fix related to "loopback over
tmpfs" or such.

Is the list above sufficient to extract the patches from your mail
backlog, or would you prefer that we resend them?

I'll also send along a patch to update the document to match the
reworked lru handling methodology that Kamezawa Hiroyuki did.

Lee

