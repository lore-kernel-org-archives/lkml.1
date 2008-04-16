Return-Path: <linux-kernel-owner+w=401wt.eu-S1761089AbYDPAph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761089AbYDPAph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 20:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbYDPApY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 20:45:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55352 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752951AbYDPApX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 20:45:23 -0400
Date: Tue, 15 Apr 2008 17:45:21 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Joe Perches <joe@perches.com>
Subject: Re: [patch] mm: sparsemem memory_present() memory corruption fix
In-Reply-To: <20080416004010.GA26776@elte.hu>
Message-ID: <Pine.LNX.4.64.0804151742010.6876@schroedinger.engr.sgi.com>
References: <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org>
 <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com>
 <20080415195430.GA23015@elte.hu> <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com>
 <20080415201734.GA25628@elte.hu> <4805115D.5030703@cs.helsinki.fi>
 <20080415204025.GA29784@elte.hu> <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org>
 <20080416000356.GA24737@elte.hu> <20080416003449.GA26633@elte.hu>
 <20080416004010.GA26776@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> fix memory corruption and crash on 32-bit x86 systems.
> 
> if a !PAE x86 kernel is booted on a 32-bit system with more than
> 4GB of RAM, then we call memory_present() with a start/end that
> goes outside the scope of MAX_PHYSMEM_BITS.

So its a general issue that has been there for years that we are now 
noticing because we are now testing with memory sizes > 4GB. This also 
affects the enterprise releases (SLES10, RHEL5). Argh!

I wonder why this did not show up earlier in testing? Running a kernel 
that cannot access all of memory is unusual I guess.


