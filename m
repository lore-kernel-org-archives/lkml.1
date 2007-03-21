Return-Path: <linux-kernel-owner+w=401wt.eu-S933085AbXCUHlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbXCUHlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 03:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933059AbXCUHlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 03:41:00 -0400
Received: from brick.kernel.dk ([62.242.22.158]:27903 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933191AbXCUHk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 03:40:59 -0400
Date: Wed, 21 Mar 2007 08:40:14 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: AIO, FIO and Threads ...
Message-ID: <20070321074014.GD14389@kernel.dk>
References: <Pine.LNX.4.64.0703202146570.28960@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703202146570.28960@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20 2007, Davide Libenzi wrote:
> 
> I was looking at Jens FIO stuff, and I decided to cook a quick patch for 
> FIO to support GUASI (Generic Userspace Asyncronous Syscall Interface):
> 
> http://www.xmailserver.org/guasi-lib.html
> 
> I then ran a few tests on my Dual Opteron 252 with SATA drives (sata_nv) 
> and 8GB of RAM.
> Mind that I'm not FIO expert, like at all, but I got some interesting 
> results when comparing GUASI with libaio at 8/1000/10000 depths.
> If I read those result correctly (Jens may help), GUASI output is more 
> then double the libaio one.
> Lots of context switches, yes. But the throughput looks like 2+ times.
> Can someone try to repeat the measures and/or spot the error?
> Or tell me which other tests to run?
> This is kinda a suprise for me ...

I don't know guasi at all, but libaio requires O_DIRECT to be async. I'm
sure you know this, but you may not know that fio default to buffered IO
so you have to tell it to use O_DIRECT :-)

So try adding a --direct=1 (or --buffered=0, same thing) as an extra
option when comparing depths > 1.

I'll add your guasi engine, but disable it. Unfortunately fio still
doesn't have a nifty configure setup, so these things are still
manual...

-- 
Jens Axboe

