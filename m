Return-Path: <linux-kernel-owner+w=401wt.eu-S1761572AbYAKR5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572AbYAKR5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 12:57:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762497AbYAKR45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 12:56:57 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:41855 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762459AbYAKR44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 12:56:56 -0500
Date: Fri, 11 Jan 2008 09:56:54 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       suresh.b.siddha@intel.com, Arjan van de Ven <arjan@infradead.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: CPA patchset
In-Reply-To: <alpine.DEB.0.999999.0801110856230.9361@twinlark.arctic.org>
Message-ID: <alpine.DEB.0.999999.0801110948590.21298@twinlark.arctic.org>
References: <20080103424.989432000@suse.de> <20080110093126.GA360@elte.hu> <20080110095337.GK25945@bingen.suse.de> <20080110100443.GB28209@elte.hu> <20080110100712.GO25945@bingen.suse.de> <20080110105726.GD28209@elte.hu> <20080110111248.GR25945@bingen.suse.de>
 <20080111071936.GA16175@elte.hu> <alpine.DEB.0.999999.0801110856230.9361@twinlark.arctic.org>
User-Agent: Alpine 0.999999 (DEB 847 2007-12-06)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008, dean gaudet wrote:

> On Fri, 11 Jan 2008, Ingo Molnar wrote:
> 
> > * Andi Kleen <ak@suse.de> wrote:
> > 
> > > Cached requires the cache line to be read first before you can write 
> > > it.
> > 
> > nonsense, and you should know it. It is perfectly possible to construct 
> > fully written cachelines, without reading the cacheline first. MOVDQ is 
> > SSE1 so on basically in every CPU today - and it is 16 byte aligned and 
> > can generate full cacheline writes, _without_ filling in the cacheline 
> > first.
> 
> did you mean to write MOVNTPS above?

btw in case you were thinking a normal store to WB rather than a 
non-temporal store... i ran a microbenchmark streaming stores to every 16 
bytes of a 16MiB region aligned to 4096 bytes on a xeon 53xx series CPU 
(4MiB L2) + 5000X northbridge and the avg latency of MOVNTPS is 12 cycles 
whereas the avg latency of MOVAPS is 20 cycles.

the inner loop is unrolled 16 times so there are literally 4 cache lines 
worth of stores being stuffed into the store queue as fast as possible... 
and there's no coalescing for normal stores even on this modern CPU.

i'm certain i'll see the same thing on AMD... it's a very hard thing to do 
in hardware without the non-temporal hint.

-dean


