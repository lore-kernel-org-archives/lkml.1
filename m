Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbXLARuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbXLARuD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 12:50:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbXLARty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 12:49:54 -0500
Received: from lazybastard.de ([212.112.238.170]:47199 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbXLARtx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 12:49:53 -0500
Date: Sat, 1 Dec 2007 16:16:50 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>, Mark Lord <lkml@rtr.ca>,
       Pavel Machek <pavel@ucw.cz>, Mark Lord <liml@rtr.ca>,
       Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071201151650.GA5031@lazybastard.org>
References: <473C7495.40805@rtr.ca> <20071115181418.GA6603@ucw.cz> <473C825E.3030307@rtr.ca> <20071115193424.GA31691@elte.hu> <20071115193612.GA751@elte.hu> <20071130125628.GA30773@lazybastard.org> <20071130133546.GB29679@elte.hu> <20071130134312.GA32273@elte.hu> <20071130183510.GA1570@lazybastard.org> <20071130184625.GB9928@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20071130184625.GB9928@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 November 2007 19:46:25 +0100, Ingo Molnar wrote:
> * Jörn Engel <joern@logfs.org> wrote:
> > 
> > It compiles.  It boots with a 512M RAM (384M was too little with all
> > the other debug options on).  But it seems to lock up when running
> > trace-cmd.  On a rerun it locks up again, but with different output.
> 
> hm, you should decrease MAX_TRACE in kernel/latency_tracing.c from 1 
> million to 16K or so. 1 million entries probably depletes lowmem quite 
> seriously.

That's ok.  RAM is cheap.

> > Rerun was captured:
> > http://logfs.org/~joern/trace1.jpg
> 
> hm, that looks weird. if you disable CONFIG_PROVE_LOCKING, does that 
> improve things? (or just turns a noisy lockup into a silent lockup?)

Not much, although the dumps look different now:
http://logfs.org/~joern/trace3.jpg
http://logfs.org/~joern/trace4.jpg

I have to change my qemu setup a little to see the top of those
dumps...

> > I should do a couple of runs, but my girlfriend claims realtime 
> > priority for the evening.
> 
> yeah, SCHED_IDLE is not generally well received by them.

...as soon as more urgent tasks has finished (weekend is over).

Jörn

-- 
It does not matter how slowly you go, so long as you do not stop.
-- Confucius
