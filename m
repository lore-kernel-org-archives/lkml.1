Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbXLUQ04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbXLUQ04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 11:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbXLUQ0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 11:26:49 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40971 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750763AbXLUQ0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 11:26:48 -0500
Date: Fri, 21 Dec 2007 08:26:47 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <20071221122628.GA18002@elte.hu>
Message-ID: <Pine.LNX.4.64.0712210818360.29372@schroedinger.engr.sgi.com>
References: <1197049846.1645.68.camel@localhost.localdomain>
 <20071211143336.GA17866@elte.hu> <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com>
 <20071221120908.GA15926@elte.hu> <20071221122628.GA18002@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007, Ingo Molnar wrote:

> and this is not the only regression:
> 
>     http://lkml.org/lkml/2007/10/4/290
> 
> _6%_ TPC-C regression. That's _a lot_ in TPC-C terms.
> 
> and just like in this case there were very clear profiles posted. I 
> proffer, reading back the whole thread, that if you fix hackbench you 
> have fixed TPC-C as well.

There are patches pending to address these issues. AFAICT Intel is 
testing if the regression is still there. There is no way for me to verify what 
is going  on there and there is the constant difficulty of getting 
detailed information about what is going on at Intel. Every couple of 
month I get a result from that test. Its a really crappy situation where a 
lot of confusing information is passed around.

> So i believe you should either send some sensible fixes _NOW_, or admit 
> that the "no queues" NIH nonsense of SLUB doesnt work and do an edible, 
> incremental patchset against SLAB to bring in the debuggability features 
> of SLUB without killing SLAB's performance. (And fix the NUMA alien 
> cache problem along the lines suggested before - perhaps initially by 
> making 'noaliencache' the default bootup option.) And we obviously must 
> revert the default in 2.6.24 to SLAB as well.

The fixes to the alien that you proposed do not work since we would still 
have to check for the need to put the object into alien cache. The checks 
for the locality of each object are the main cause of trouble when freeing 
in SLAB.

SLUB is generally performance wise superior to SLAB as demonstrated by my 
measurements that you reviewed too. In addition SLUB has many improvements 
over SLAB. Its not only the runtime debuggability which would be difficult 
to add since there would be numerous runtime checks in critical code paths 
that would cause regressions.

