Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbZI1SpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbZI1SpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 14:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbZI1SpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 14:45:16 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:56954 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752729AbZI1SpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 14:45:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgEFALiawEpMROOX/2dsb2JhbACBUdYJhB4F
Date: Mon, 28 Sep 2009 14:40:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Adrian Bunk <bunk@stusta.de>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 02/12] Immediate Values - Architecture Independent Code
Message-ID: <20090928184016.GB10693@Krystal>
References: <20090924132626.485545323@polymtl.ca> <20090924133359.218934235@polymtl.ca> <20090924212013.d27226c4.akpm@linux-foundation.org> <20090928012337.GC1656@one.firstfloor.org> <20090928104617.9c4b868a.akpm@linux-foundation.org> <20090928200317.64a419ff@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090928200317.64a419ff@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:35:08 up 41 days,  5:24,  4 users,  load average: 0.20, 0.27,
	0.25
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven (arjan@infradead.org) wrote:
> On Mon, 28 Sep 2009 10:46:17 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > Kernel gets a lot of cache misses, but that's usually against
> > userspace, pagecache, net headers/data, etc.  I doubt if it gets many
> > misses against a small number of small, read-mostly data items which
> > is what this patch addresses.
> > 
> > And it is a *small* number of things to which this change is
> > applicable.  This is because the write operation for these read-mostly
> > variables becomes very expensive indeed.  This means that we cannot
> > use "immediate values" for any variable which can conceivable be
> > modified at high frequency by any workload.
> 
> btw just to add to this:
> caches are unified code/data after L1 in general... it then does not
> matter much if you encode the "almost constant" in the codestream or
> slightly farther away, in both cases it takes up cache space.

Standard read from memory will typically need to have the address of the
data to access as operand to the instruction in i-cache, plus the data
in d-cache.

Compared to this, immediate values remove the need to have a pointer in
the i-cache, so the overall footprint, even for L2 cache, is lower.

> (you can argue "but in the data case it might pull in a whole cacheline
> just for this".. but that's a case for us to pack such read mostly
> things properly)
> 
> And for L1.. well.. the L2 latency is not THAT much bigger. And L1 is 
> tiny. more icache pressure hurts just as much as having more dcache
> pressure there.

Immediate values does not add i-cache pressure. They just remove d-cache
pressure. So it saves L1 d-cache, and the L1 i-cache pressure stays
mostly unchanged.

Thanks,

Mathieu


> 
> 
> -- 
> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings, 
> visit http://www.lesswatts.org

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
