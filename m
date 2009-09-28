Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbZI1WKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbZI1WKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 18:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbZI1WKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 18:10:01 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:53795 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752981AbZI1WJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 18:09:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgEFAE3OwEpMROOX/2dsb2JhbACBUdVthB4F
Date: Mon, 28 Sep 2009 18:05:00 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Adrian Bunk <bunk@stusta.de>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 02/12] Immediate Values - Architecture Independent Code
Message-ID: <20090928220500.GC27947@Krystal>
References: <20090924132626.485545323@polymtl.ca> <20090924133359.218934235@polymtl.ca> <20090924212013.d27226c4.akpm@linux-foundation.org> <20090928012337.GC1656@one.firstfloor.org> <20090928104617.9c4b868a.akpm@linux-foundation.org> <20090928200317.64a419ff@infradead.org> <20090928195444.GF1656@one.firstfloor.org> <20090928223735.74267e3e@infradead.org> <4AC12B6E.7010805@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4AC12B6E.7010805@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 18:02:50 up 41 days,  8:52,  5 users,  load average: 0.16, 0.29,
	0.27
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> On 09/28/2009 01:37 PM, Arjan van de Ven wrote:
> > 
> > this makes me wonder what happens when a variable is used in multiple
> > places... that makes the icache overhead multiply right?
> > 
> 
> On x86, the icache overhead can often be zero or close to zero -- or
> even negative in a fairly common subcase[1] -- simply because you are
> dropping a displacement used to fetch a global variable with an
> immediate in the code itself.
> 
> For 8- or 16-bit data items this is even more of a win in terms of
> icache space; for 64-bit data it is always a lose.
> 
> It is also worth noting that the way this is implemented as a graft-on
> rather than with compiler support means that the full instruction set
> cannot exploited -- x86 can often use a memory operand or immediate as
> part of an operation.  This adds icache pressure.

Indeed, these cases could make good use of compiler support to let
immediate values be added to a wider range of operations. Currently,
being limited to "mov" is somewhat limiting on x86. We could definitely
do better.

Mathieu

> 
> 	-hpa
> 
> [1] Common subcase:
> 
> 	movl global, %reg	; 6 bytes (unless reg is eax on 32 bits)
> 	movl $immed, %reg	; 5 bytes
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
