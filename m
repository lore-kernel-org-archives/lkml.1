Return-Path: <linux-kernel-owner+w=401wt.eu-S1759746AbXFSWdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759746AbXFSWdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbXFSWc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:32:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33419
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755611AbXFSWc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:32:56 -0400
Date: Tue, 19 Jun 2007 15:33:15 -0700 (PDT)
Message-Id: <20070619.153315.118964582.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: john@stoffel.org, akpm@linux-foundation.org, tim.c.chen@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: Change in default vm_dirty_ratio
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.0.98.0706191201130.3593@woody.linux-foundation.org>
References: <20070618164711.9de1c38e.akpm@linux-foundation.org>
	<18040.9056.755569.67029@stoffel.org>
	<alpine.LFD.0.98.0706191201130.3593@woody.linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 19 Jun 2007 12:04:33 -0700 (PDT)

> 
> 
> On Tue, 19 Jun 2007, John Stoffel wrote:
> > 
> > Shouldn't the vm_dirty_ratio be based on the speed of the device, and
> > not the size of memory?
> 
> Yes. It should depend on:
>  - speed of the device(s) in question
>  - seekiness of the workload
>  - wishes of the user as per the latency of other operations.
> 
> However, nobody has ever found the required algorithm.
> 
> So "at most 10% of memory dirty" is a simple (and fairly _good_) 
> heuristic. Nobody has actually ever ended up complaining about the change 
> from 40% -> 10%, and as far as I know this was the first report (and it's 
> not so much because the change was bad, but because it showed up on a 
> benchmark - and I don't think that actually says anythign about anything 
> else then the behaviour of the benchmark itself)

I complained very early on that it makes my workstation basically just
hang doing disk writes when I do big git tree operations on my sparc64
workstation.

Restoring the old values makes that go away.

It's an arbitrary number because the correct setting is dependant
upon what you're doing and how fast your disks are.

So I really think the "only benchmarks like the old settings"
argument doesn't really apply.

