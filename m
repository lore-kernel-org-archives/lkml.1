Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbZI1SDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbZI1SDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 14:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbZI1SDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 14:03:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:55612 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbZI1SDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 14:03:32 -0400
Date: Mon, 28 Sep 2009 20:03:17 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Adrian Bunk <bunk@stusta.de>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 02/12] Immediate Values - Architecture Independent Code
Message-ID: <20090928200317.64a419ff@infradead.org>
In-Reply-To: <20090928104617.9c4b868a.akpm@linux-foundation.org>
References: <20090924132626.485545323@polymtl.ca>
	<20090924133359.218934235@polymtl.ca>
	<20090924212013.d27226c4.akpm@linux-foundation.org>
	<20090928012337.GC1656@one.firstfloor.org>
	<20090928104617.9c4b868a.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Sep 2009 10:46:17 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> Kernel gets a lot of cache misses, but that's usually against
> userspace, pagecache, net headers/data, etc.  I doubt if it gets many
> misses against a small number of small, read-mostly data items which
> is what this patch addresses.
> 
> And it is a *small* number of things to which this change is
> applicable.  This is because the write operation for these read-mostly
> variables becomes very expensive indeed.  This means that we cannot
> use "immediate values" for any variable which can conceivable be
> modified at high frequency by any workload.

btw just to add to this:
caches are unified code/data after L1 in general... it then does not
matter much if you encode the "almost constant" in the codestream or
slightly farther away, in both cases it takes up cache space.
(you can argue "but in the data case it might pull in a whole cacheline
just for this".. but that's a case for us to pack such read mostly
things properly)

And for L1.. well.. the L2 latency is not THAT much bigger. And L1 is 
tiny. more icache pressure hurts just as much as having more dcache
pressure there.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
