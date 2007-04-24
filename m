Return-Path: <linux-kernel-owner+w=401wt.eu-S1161680AbXDXHXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161680AbXDXHXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 03:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161684AbXDXHXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 03:23:03 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:64258 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1161680AbXDXHXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 03:23:02 -0400
Date: Mon, 23 Apr 2007 23:45:53 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Ingo Molnar <mingo@elte.hu>
cc: Gene Heskett <gene.heskett@gmail.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       caglar@pardus.org.tr
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
In-Reply-To: <20070424070800.GA23463@elte.hu>
Message-ID: <Pine.LNX.4.63.0704232342440.7121@qynat.qvtvafvgr.pbz>
References: <200704220959.34978.kernel@kolivas.org>  <462DA1E8.9080201@bigpond.net.au>
 <20070424063633.GA17257@elte.hu>  <200704240300.07689.gene.heskett@gmail.com>
 <20070424070800.GA23463@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Ingo Molnar wrote:

> * Gene Heskett <gene.heskett@gmail.com> wrote:
>
>>> Gene has done some testing under CFS with X reniced to +10 and the
>>> desktop still worked smoothly for him.
>>
>> As a data point here, and probably nothing to do with X, but I did
>> manage to lock it up, solid, reset button time tonight, by wanting
>> 'smart' to get done with an update session after amanda had started.
>> I took both smart processes I could see in htop all the way to -19,
>> but when it was about done about 3 minutes later, everything came to
>> an instant, frozen, reset button required lockup.  I should have
>> stopped at -17 I guess. :(
>
> yeah, i guess this has little to do with X. I think in your scenario it
> might have been smarter to either stop, or to renice the workloads that
> took away CPU power from others to _positive_ nice levels. Negative nice
> levels can indeed be dangerous.
>
> (Btw., to protect against such mishaps in the future i have changed the
> SysRq-N [SysRq-Nice] implementation in my tree to not only change
> real-time tasks to SCHED_OTHER, but to also renice negative nice levels
> back to 0 - this will show up in -v6. That way you'd only have had to
> hit SysRq-N to get the system out of the wedge.)

if you are trying to unwedge a system it may be a good idea to renice all tasks 
to 0, it could be that a task at +19 is holding a lock that something else is 
waiting for.

David Lang
