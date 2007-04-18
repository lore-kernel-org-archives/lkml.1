Return-Path: <linux-kernel-owner+w=401wt.eu-S2993080AbXDRT2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993080AbXDRT2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 15:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993081AbXDRT2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 15:28:39 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:41702 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993080AbXDRT2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 15:28:38 -0400
Message-ID: <4626713B.1040206@nortel.com>
Date: Wed, 18 Apr 2007 13:27:55 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Mark Glines <mark@glines.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       Bill Huey <billh@gnuppy.monkey.org>, Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, ck list <ck@vds.kolivas.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [ck] Re: [Announce] [patch] Modular Scheduler Core and Completely
 Fair Scheduler [CFS]
References: <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de>	<20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de>	<20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de>	<20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org> <20070418152355.GU11115@waste.org> <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org> <20070418104814.2c6fdda7@chirp>
In-Reply-To: <20070418104814.2c6fdda7@chirp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Apr 2007 19:28:00.0258 (UTC) FILETIME=[ACF9FE20:01C781EF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Glines wrote:

> One minor question: is it even possible to be completely fair on SMP?
> For instance, if you have a 2-way SMP box running 3 applications, one of
> which has 2 threads, will the threaded app have an advantage here?  (The
> current system seems to try to keep each thread on a specific CPU, to
> reduce cache thrashing, which means threads and processes alike each
> get 50% of the CPU.)

I think the ideal in this case would be to have both threads on one cpu, 
with the other app on the other cpu.  This gives inter-process fairness 
while minimizing the amount of task migration required.

More interesting is the case of three processes on a 2-cpu system.  Do 
we constantly migrate one of them back and forth to ensure that each of 
them gets 66% of a cpu?

Chris
