Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab0CDRIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:08:10 -0500
Received: from fallback.mail.elte.hu ([157.181.151.13]:56392 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356Ab0CDRIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 12:08:05 -0500
Date: Thu, 4 Mar 2010 12:04:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       paulus@samba.org, eranian@google.com, robert.richter@amd.com
Subject: Re: [RFC][PATCH 07/11] perf: Provide PERF_SAMPLE_REGS
Message-ID: <20100304110429.GC21977@elte.hu>
References: <20100303163936.906011640@chello.nl>
 <20100303164306.375353163@chello.nl>
 <20100303220249.GF5194@nowhere>
 <1267693087.25158.148.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267693087.25158.148.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2010-03-03 at 23:02 +0100, Frederic Weisbecker wrote:
> > On Wed, Mar 03, 2010 at 05:39:43PM +0100, Peter Zijlstra wrote:
> > > Simply copy out the provided pt_regs in a u64 aligned fashion.
> > > 
> > > XXX: do task_pt_regs() and get_irq_regs() always clear everything or
> > >      are we now leaking data?
> > 
> > 
> > It looks like there is a leak in case of non trace syscalls.
> > where we don't appear to save r12-15.
> > 
> > Then task_pt_regs() may leak the top of a process stack...?
> 
> Right, I was afraid of that. I've put this PERF_SAMPLE_REGS thing in the 
> freezer for now as people seem unsure how to deal with it.

Also, we dont want to expose PEBS nor LBR on an ABI level without there being 
a user-space component making good use of it.

For example tools/perf/ support would qualify. Raw libraries alone dont really 
count as they generally lag plus there's no guarantee for a full feedback loop 
either.

Adding ABI details is always a tricky business and we only want to do it if 
there's direct, immediate, close involvement with the user-space side, and 
real, immediate benefits to users.

Thanks,

	Ingo
