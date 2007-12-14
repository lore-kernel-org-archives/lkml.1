Return-Path: <linux-kernel-owner+w=401wt.eu-S1761470AbXLNGRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761470AbXLNGRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 01:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbXLNGQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 01:16:56 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:44055 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbXLNGQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 01:16:55 -0500
Date: Fri, 14 Dec 2007 01:15:54 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Christoph Lameter <clameter@sgi.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.58.0712140106470.11089@gandalf.stny.rr.com>
References: <1197049846.1645.68.camel@localhost.localdomain>
 <20071211143336.GA17866@elte.hu> <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Christoph,

Welcome back from your vacation! :-)

On Thu, 13 Dec 2007, Christoph Lameter wrote:
>
> In an extreme case (boot with slub_min_order=9 to get huge page sized
> slabs) SLUB can win against SLAB:
>
> N=10 Time: 0.338	Minimally faster
> N=20 Time: 0.560	10% faster
> N=50 Time: 1.353	15% faster
>

I booted back to slub with slub_min_order=9 on the 64way and you are
indeed right about this.

# tests/hackbench 90
Time: 2.109
# chrt -f 10 tests/hackbench 90
Time: 3.775
# tests/hackbench 90
Time: 1.583
# chrt -f 10 tests/hackbench 90
Time: 1.833
# tests/hackbench 90
Time: 1.601
# chrt -f 10 tests/hackbench 90
Time: 3.078
# tests/hackbench 90
Time: 1.321
# chrt -f 10 tests/hackbench 90
Time: 1.933



A flux between 1.321 and 3.775 (*)(the rt runs were higher). But still,
good job at narrowing this down. Now the hard part. Figuring out a way
that will be nice to all users.

-- Steve

(*) The previous runs (without the command line option) were 13 seconds or
so.
