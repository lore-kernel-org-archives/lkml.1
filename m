Return-Path: <linux-kernel-owner+w=401wt.eu-S934293AbZKYHZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934293AbZKYHZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 02:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZKYHZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 02:25:14 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36285 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186AbZKYHZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 02:25:13 -0500
Message-ID: <4B0CDBDE.8090307@cs.helsinki.fi>
Date: Wed, 25 Nov 2009 09:25:18 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>,
       paulmck@linux.vnet.ibm.com, linux-mm@kvack.org,
       Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: lockdep complaints in slab allocator
References: <84144f020911192249l6c7fa495t1a05294c8f5b6ac8@mail.gmail.com>	 <1258709153.11284.429.camel@laptop>	 <84144f020911200238w3d3ecb38k92ca595beee31de5@mail.gmail.com>	 <1258714328.11284.522.camel@laptop> <4B067816.6070304@cs.helsinki.fi>	 <1258729748.4104.223.camel@laptop> <1259002800.5630.1.camel@penberg-laptop>	 <1259003425.17871.328.camel@calx> <4B0ADEF5.9040001@cs.helsinki.fi>	 <1259080406.4531.1645.camel@laptop>	 <20091124170032.GC6831@linux.vnet.ibm.com>	 <1259082756.17871.607.camel@calx> <1259086459.4531.1752.camel@laptop>	 <1259090615.17871.696.camel@calx>  <1259095580.4531.1788.camel@laptop>	 <1259096004.17871.716.camel@calx> <1259096519.4531.1809.camel@laptop>	 <alpine.DEB.2.00.0911241302370.6593@chino.kir.corp.google.com>	 <1259097150.4531.1822.camel@laptop>	 <alpine.DEB.2.00.0911241313220.12339@chino.kir.corp.google.com> <1259098552.4531.1857.camel@laptop>
In-Reply-To: <1259098552.4531.1857.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra kirjoitti:
> Then maybe we should toss SLUB? But then there's people who say SLUB is
> better for them. Without forcing something to happen we'll be stuck with
> multiple allocators forever.

SLUB is good for NUMA, SLAB is pretty much a disaster with it's alien 
tentacles^Hcaches. AFAIK, SLQB hasn't received much NUMA attention so 
it's not obvious whether or not it will be able to perform as well as 
SLUB or not.

The biggest problem with SLUB is that most of the people (excluding 
Christoph and myself) seem to think the design is unfixable for their 
favorite workload so they prefer to either stay with SLAB or work on SLQB.

I really couldn't care less which allocator we end up with as long as 
it's not SLAB. I do think putting more performance tuning effort into 
SLUB would give best results because the allocator is pretty rock solid 
at this point. People seem underestimate the total effort needed to make 
a slab allocator good enough for the general public (which is why I 
think SLQB still has a long way to go).

			Pekka
