Return-Path: <linux-kernel-owner+w=401wt.eu-S1759961AbYF2MkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbYF2MkZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 08:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbYF2MkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 08:40:13 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59201 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754008AbYF2MkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 08:40:12 -0400
Message-ID: <486782A9.9060704@sgi.com>
Date: Sun, 29 Jun 2008 05:40:09 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       mm-commits@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] x86: Add check for node passed to node_to_cpumask
 V3
References: <200806090918.m599Ib0G012837@imap1.linux-foundation.org>	 <19f34abd0806090420r4100241cgb4b828441de3b102@mail.gmail.com>	 <20080609113547.GA1534@elte.hu> <484D54F2.4070603@sgi.com>	 <20080626113229.GB29619@elte.hu> <4863C334.2090007@sgi.com>	 <486452CC.8050502@sgi.com> <48651EF5.5090808@sgi.com>	 <19f34abd0806271024j53b383ddq33ab2b58debfbb65@mail.gmail.com>	 <48652B6A.7060007@sgi.com> <19f34abd0806290434l836e858p47850eb96addd0b3@mail.gmail.com>
In-Reply-To: <19f34abd0806290434l836e858p47850eb96addd0b3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> On Fri, Jun 27, 2008 at 8:03 PM, Mike Travis <travis@sgi.com> wrote:
>>> So if CONFIG_DEBUG_RODATA=y, I believe we'll see first this warning,
>>> then a panic (after all). Would it be better to make cpu_mask_none
>>> non-const, in spirit of trying to continue as far as possible? I don't
>>> really know if it matters, though. It seems that fedora kernels at
>>> least ship with a default of DEBUG_RODATA=y.
>>>
> 
> ...
> 
>> Ingo asked me to add the "const".  But it would be a mistake to use
>> node_to_cpumask_ptr to modify the map... numa_set/clear_node is the
>> proper way to modify the maps.  Hmm, maybe I should add "const" to
>> the real node_to_cpumask_ptr function, at least then the compiler
>> would help spot illegal usages.
> 
> That sounds like a brilliant idea, as long as none of the callers
> expect it to be non-const.

Being that I modified all the callers to use this new function, I did
verify that each caller expected it to be read only... ;-)
> 
> I changed it to return const to see, and built allmodconfig + a few
> randconfigs without error (well, warning). There are not that many
> users of this function anyway.

Did any violate the read-only nature of the call?
> 
> BTW, what's up with the topology.h/setup_percpu.c mismatch, when
> topology.c exists as well?

Topology.h supplies the generic usage which is to define a local cpumask
variable, fill it, and then return a pointer to it.  This is for arch's
that do not maintain a separate node_to_cpumask_map[] but allows a
compatible call interface.
> 
> 
> Vegard
> 

Thanks!
Mike

