Return-Path: <linux-kernel-owner+w=401wt.eu-S1751336AbXBUTxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336AbXBUTxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 14:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbXBUTxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 14:53:30 -0500
Received: from dev.kryptiva.com ([69.70.52.243]:18671 "EHLO mail.kryptiva.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751336AbXBUTx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 14:53:29 -0500
Message-ID: <45DCA6E1.7080903@kryptiva.com>
Date: Wed, 21 Feb 2007 15:09:05 -0500
From: Karim Yaghmour <karim.yaghmour@kryptiva.com>
Reply-To: karim.yaghmour@kryptiva.com
Organization: Kryptiva Inc.
User-Agent: Thunderbird 1.5.0.8 (X11/20061107)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       systemtap@sources.redhat.com, ltt-dev@shafik.org
Subject: Re: [PATCH 05/05] Linux Kernel Markers, non optimized architectures
References: <1171224207118-git-send-email-mathieu.desnoyers@polymtl.ca> <1171224209195-git-send-email-mathieu.desnoyers@polymtl.ca> <20070214231635.091c7169.akpm@linux-foundation.org> <20070215190919.GA31359@Krystal> <45D61361.6030200@kryptiva.com> <20070216233825.GB28087@Krystal>
In-Reply-To: <20070216233825.GB28087@Krystal>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

----- KRYPTIVA PACKAGED MESSAGE -----
PACKAGING TYPE: SIGNED

Hello Mathieu,

Mathieu Desnoyers wrote:
 > Yes, that was indeed the first way I implemented it, as a "disable" option. One of the main thing we have to figure out before I modify this is if we want to have the generic version of markers available in a "forced" manner at the marker site with the GEN_MARK macro instead of the MARK macro (this is the actual implementation). It has proven to be useful to instrument lockdep.c irq
 > enable/disable tracing functions. The reason why is because they are called just before the trap handler returns and I need it to do XMC on x86 and x86_64. It would therefore cause a recursive trap.
 >
 > I think it makes sense to have this kind of support for hard-to-instrument sites within the marker infrastructure, but the cost is to have two marker flavors : MARK and GEN_MARK (but really GEN_MARK is only intended for a few sites).

I must admit that I'm unsure about the use of different marker macros.
How about bitwise flags that could be coded as part of the marker
at the marker site? Something like "MARKER_TYPE_FORCED". This would
still allow some form of toplevel control at the macro definition.
Otherwise there's some digging to be done on a per-marker
basis ...

Karim
----- KRYPTIVA SIGNED MESSAGE -----
This email claims to have been packaged by Kryptiva.
To process this email and authenticate its origin, get
the free plugin from:
http://www.kryptiva.com/downloads

----- KRYPTIVA SIGNATURE START -----
AvWVqAAAAAIAAAABAAAAAAAATiACAQAAAAC3AQAIAAAAAgAAAAECABTXxT4xHdR4/1uU1hL2
+TaPrqNB0wMAFNa8GHXZWJH5Dz+D76vfh6JhvWLvBAAUpuIZcCAkCC+ldyaBuoAWxK50HiQF
ABRI38gc/foDHQsS6X3W0VP4xTukBwYAFB0lithGcxNZYBHaLDONjp6eo/LoBwAU6OwGS0m1
IVdBt6tKzhaPW8MOfncRABgAAAAAAABOIEXcozcACATMAAAAAAAAABkTAAQAAAAAAAAAggQA
mHAJeFbYUzxSX+zkI0DtoVKcqqSp2Ztc9GtY7ZtuLBmeqg5pW0rIbkhutQiztTXlJQ0Ye9bV
yzEVWd/m7GhDAgRBmyg3kCOt7g7potr1l5J3X5K8TiqtWXbNo3k6AHRlGZyn0190iIBSvf85
nVh3hKiNPsw8DYs1NKb+KMON+4g=
----- KRYPTIVA SIGNATURE END -----
