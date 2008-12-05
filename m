Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbYLEMjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbYLEMjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 07:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbYLEMj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 07:39:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44875 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYLEMj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 07:39:28 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, a.p.zijlstra@chello.nl,
       paulus@samba.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       eranian@googlemail.com, dada1@cosmosbay.com, robert.richter@amd.com,
       arjan@infradead.org, hpa@zytor.com, rostedt@goodmis.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
From: Andi Kleen <andi@firstfloor.org>
References: <20081205081137.GB2030@elte.hu>
	<20081205.001717.216522767.davem@davemloft.net>
	<20081205082431.GD2030@elte.hu>
	<20081205.002701.172921476.davem@davemloft.net>
	<20081205084233.GE2030@elte.hu>
Date: Fri, 05 Dec 2008 13:39:43 +0100
In-Reply-To: <20081205084233.GE2030@elte.hu> (Ingo Molnar's message of "Fri, 5 Dec 2008 09:42:33 +0100")
Message-ID: <87ej0mx0c0.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> Note that more notification record types is actually where latest 
> hardware is going: for example in Nehalem there's a PEBS notification 
> record type that has cachemiss latency included in the record. I.e. we 
> can get profiles with _cachemiss latency_ included (as measured from 
> issuing the instruction to completion).

One problem is that you have to find out the correct RIP for that PEBS
cache miss you have to disassemble from the last basic block because
the IP in PEBS points to the next instruction. 

If such a thing is ever implemented it should be in user space
I think.

Also in general some of the more useful PEBS information requires
disassembling unfortunately. For example if you want a address
histogram you get the register contents, but you have to interpret the
code to compute the EA. While the kernel has a x86 interpreter now for
this I suspect doing it in kernel space would be quite complicated
and at least I would consider doing it in user space cleaner too.

Given these are more obscure features, but not being able to fit
them easily into your model from the start isn't a very promising sign
for the long term extensibility of the design.

-Andi

-- 
ak@linux.intel.com
