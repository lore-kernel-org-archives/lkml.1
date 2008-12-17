Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757331AbYLQBv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbYLQBv3 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 20:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYLQBvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 20:51:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57495 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbYLQBvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 20:51:18 -0500
To: William Cohen <wcohen@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Robert Richter <robert.richter@amd.com>,
        Eric Dumazet <dada1@cosmosbay.com>,
        Stephane Eranian <eranian@googlemail.com>,
        Paul Mackerras <paulus@samba.org>, Peter Anvin <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        perfctr-devel@lists.sourceforge.net,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Perfctr-devel] [patch] Performance Counters for Linux, v4
From: Andi Kleen <andi@firstfloor.org>
References: <20081214212829.GA9435@elte.hu> <494807D2.3060808@redhat.com>
Date: Wed, 17 Dec 2008 02:51:54 +0100
In-Reply-To: <494807D2.3060808@redhat.com> (William Cohen's message of "Tue, 16 Dec 2008 14:56:02 -0500")
Message-ID: <87prjr1scl.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Cohen <wcohen@redhat.com> writes:
>
> PERF_COUNT_CACHE_REFERENCES and PERF_COUNT_CACHE_MISSES are not single
> monolitic events on many processors. There are multiple cache
> levels. The L1 cache most processors have separate instruction and
> data caches and require multiple counters to implement. Would these
> refer to the last level of cache before memory and just be used to
> compute the hit/miss rate for that last level? Some processors in the
> same family have L2 and some processors have L3 cache. The setup code
> would need to distinguish between these processor variants.

The difference between L1 and L3 caches can be huge (in some cases
two orders of magnitude). With that I'm not sure a single cache
miss/hit event even makes any sense. 

On a modern CPU with L2 and L3 caches as soon as you fall out 
of the L2 you're going to perform more poorly on parallel workloads.

With that you really have to distingush some levels.

-Andi


-- 
ak@linux.intel.com
