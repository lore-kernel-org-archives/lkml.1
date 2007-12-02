Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbXLBLjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbXLBLjq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 06:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbXLBLjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 06:39:39 -0500
Received: from lazybastard.de ([212.112.238.170]:47237 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbXLBLjh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 06:39:37 -0500
Date: Sun, 2 Dec 2007 12:31:43 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>, Mark Lord <lkml@rtr.ca>,
       Pavel Machek <pavel@ucw.cz>, Mark Lord <liml@rtr.ca>,
       Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071202113143.GA9378@lazybastard.org>
References: <20071130133546.GB29679@elte.hu> <20071130134312.GA32273@elte.hu> <20071130183510.GA1570@lazybastard.org> <20071130184625.GB9928@elte.hu> <20071201151650.GA5031@lazybastard.org> <20071201183256.GA14052@elte.hu> <20071201204747.GA6458@lazybastard.org> <20071201205456.GA8231@elte.hu> <20071201234112.GA7209@lazybastard.org> <20071202085607.GA28966@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20071202085607.GA28966@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 December 2007 09:56:08 +0100, Ingo Molnar wrote:
> * Jörn Engel <joern@logfs.org> wrote:
> 
> > > ah. You should mark pit_read() function as notrace. PIT clocksource 
> > > is rare. (add the 'notrace' word to the function prototype)
> > 
> > Hardly a change at all.  Apart from some offsets, this dump is 
> > identical.
> > 
> > stopped custom tracer.
> > BUG: spinlock recursion on CPU#0, sh/954
> >  lock: c030f280, .magic: dead4ead, .owner: sh/954, .owner_cpu: 0
> > Pid: 954, comm: sh Not tainted 2.6.24-rc3-ge1cca7e8-dirty #3
> >  [<c0103a04>] show_trace_log_lvl+0x35/0x54
> >  [<c010450a>] show_trace+0x2c/0x2e
> >  [<c0104e6d>] dump_stack+0x84/0x8a
> >  [<c01ded7c>] spin_bug+0xa7/0xae
> >  [<c01def14>] _raw_spin_lock+0x45/0xfa
> >  [<c02a02b1>] _spin_lock_irqsave+0x68/0x7a
> >  [<c01087e2>] pit_read+0xf/0x91
> >  [<c0130ee1>] get_monotonic_cycles+0xf/0x2d
> >  [<c013c0e7>] now+0x2a/0x7c
> >  [<c013c333>] ____trace+0x4d/0x1e8
> >  [<c013dbeb>] __mcount+0x95/0xa6
> >  [<c010d354>] mcount+0x14/0x18
> >  [<c0135a3c>] lock_acquired+0xe/0x1d7
> >  [<c02a02b9>] _spin_lock_irqsave+0x70/0x7a
> >  [<c01087e2>] pit_read+0xf/0x91
> 
> hm, it seems lock_acquired() [in kernel/lockdep.c] needs to be marked 
> 'notrace' too - otherwise we recurse back into pit_read().

This time not even the offsets have changed.  Dump is identical.

Jörn

-- 
Mundie uses a textbook tactic of manipulation: start with some
reasonable talk, and lead the audience to an unreasonable conclusion.
-- Bruce Perens
