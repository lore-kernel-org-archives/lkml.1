Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab0BCPMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 10:12:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34678 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab0BCPMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 10:12:43 -0500
Subject: Re: [RFC][PATCH] perf_events, x86: PEBS support
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       "David S. Miller" <davem@davemloft.net>,
       Jamie Iles <jamie.iles@picochip.com>, Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, perfmon2-devel@lists.sf.net
In-Reply-To: <bd4cb8901002030654g25026797xff6aa9786f029590@mail.gmail.com>
References: <1265129772.24455.329.camel@laptop>
	 <20100202182653.GB19320@elte.hu> <1265135588.24455.350.camel@laptop>
	 <bd4cb8901002030522s6306fdf4qbf4eb48c0674d980@mail.gmail.com>
	 <1265205361.24455.533.camel@laptop>
	 <bd4cb8901002030607y519c191av733231ba2aec2e9c@mail.gmail.com>
	 <1265206784.24455.568.camel@laptop>
	 <bd4cb8901002030630naaa83c1j397759750007ae4c@mail.gmail.com>
	 <1265208012.24455.592.camel@laptop>
	 <bd4cb8901002030654g25026797xff6aa9786f029590@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 16:12:31 +0100
Message-ID: <1265209951.24455.640.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 15:54 +0100, Stephane Eranian wrote:
> 
> PEBS is still very useful because it guarantees the state you capture
> is at retirement of an instruction which caused the event.
> 
> PEBS also gets way more interesting on Nehalem because of the
> ability to capture where cache misses occur. That's the load latency
> feature. You need to support that.

Simple things first. But yeah, we'll get to load-latency eventually.

> I believe you would need to abstract this in a generic fashion so it
> could be used on other architectures, such as AMD with IBS.

Right, Robert said he was working on IBS, I've still not made up my mind
on how to represent IBS properly, its a bit of a weird thing. 

> On Nehalem, it requires the following:
> 
> - only works if you sample on MEM_INST_RETIRED:LATENCY_ABOVE_THRESHOLD.

Yeah, and then you get to decode the data source thingy, not really a
nice interface. Also, it mostly contains L3 information, not L2/L1.

> - the threshold must be programmed into a dedicated MSR. The extra
>   difficulty is that this MSR is shared between CPU when HT is on. 

Lovely :/ One way is to program it to the lowest of the two and simply
discard events afterwards.

