Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbXDUNeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbXDUNeu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 09:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbXDUNeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 09:34:50 -0400
Received: from mail.tmr.com ([64.65.253.246]:44227 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442AbXDUNet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 09:34:49 -0400
Message-ID: <462A12BB.6050200@tmr.com>
Date: Sat, 21 Apr 2007 09:33:47 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Nick Piggin <npiggin@suse.de>, William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de> <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de> <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de> <20070418055525.GS11115@waste.org> <20070418063711.GH18452@wotan.suse.de> <20070418065534.GT11115@waste.org>
In-Reply-To: <20070418065534.GT11115@waste.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Wed, Apr 18, 2007 at 08:37:11AM +0200, Nick Piggin wrote:

>>> [2] It's trivial to construct two or more perfectly reasonable and
>>> desirable definitions of fairness that are mutually incompatible.
>> Probably not if you use common sense, and in the context of a replacement
>> for the 2.6 scheduler.
> 
> Ok, trivial example. You cannot allocate equal CPU time to
> processes/tasks and simultaneously allocate equal time to thread
> groups. Is it common sense that a heavily-threaded app should be able
> to get hugely more CPU than a well-written app? No. I don't want Joe's
> stupid Java app to make my compile crawl.
> 
> On the other hand, if my heavily threaded app is, say, a voicemail
> server serving 30 customers, I probably want it to get 30x the CPU of
> my gzip job.
> 
Matt, you tickled a thought... on one hand we have a single user running 
a threaded application, and it ideally should get the same total CPU as 
a user running a single thread process. On the other hand we have a 
threaded application, call it sendmail, nnrpd, httpd, bind, whatever. In 
that case each thread is really providing service for an independent 
user, and should get an appropriate share of the CPU.

Perhaps the solution is to add a means for identifying server processes, 
by capability, or by membership in a "server" group, or by having the 
initiating process set some flag at exec() time. That doesn't 
necessarily solve problems, but it may provide more information to allow 
them to be soluble.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
