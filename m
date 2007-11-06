Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbXKFH7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbXKFH7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 02:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbXKFH73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 02:59:29 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:49441 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbXKFH73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 02:59:29 -0500
Date: Tue, 6 Nov 2007 07:58:40 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Christoph Lameter <clameter@sgi.com>,
       =?ISO-8859-1?Q?Oliv=E9r_Pint=E9r?= <oliver.pntr@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/2] slub: fix leakage
In-Reply-To: <b6a2187b0711052215x26b1e7e5r9d5af339d21e854f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0711060738100.30188@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com> 
 <Pine.LNX.4.64.0711031847450.13845@blonde.wat.veritas.com> 
 <Pine.LNX.4.64.0711031935510.15611@blonde.wat.veritas.com> 
 <Pine.LNX.4.64.0711031247250.5828@schroedinger.engr.sgi.com> 
 <Pine.LNX.4.64.0711031950300.17078@blonde.wat.veritas.com> 
 <Pine.LNX.4.64.0711031253580.6080@schroedinger.engr.sgi.com> 
 <Pine.LNX.4.64.0711032007060.17942@blonde.wat.veritas.com> 
 <Pine.LNX.4.64.0711031326450.6227@schroedinger.engr.sgi.com> 
 <Pine.LNX.4.64.0711041103030.8179@blonde.wat.veritas.com> 
 <Pine.LNX.4.64.0711051036250.13139@schroedinger.engr.sgi.com>
 <b6a2187b0711052215x26b1e7e5r9d5af339d21e854f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2007, Jeff Chua wrote:
> On Nov 6, 2007 2:45 AM, Christoph Lameter <clameter@sgi.com> wrote:
> 
> > 1. We can avoid going back to the page allocator for awhile since we will
> > find the almost free slab if the current slab is exhausted.
> 
> Does this impact SLAB as well?

No, it's in code peculiar to SLUB.

Of course, there might be a similar bug somewhere in SLAB.
More likely to be something else though.

> I'm getting out of memory with kernel
> 2.6.21, 2.6.22 and 2.6.23, so I'm stuck with 2.6.20-15 for systems
> running Oracle. It only happens with lots of activities.

It would help everybody if you could get more info on this.
Give 2.6.24-rc2 a try when it appears, if you can.

Do you think it's the SLAB which is growing?  If /proc/meminfo's
Slab count goes up and up, then use /proc/slabinfo to see what
it is that's leaking.  Then there's CONFIG_DEBUG_SLAB_LEAK.

With 2.6.22 or 2.6.23 you could CONFIG_SLUB instead, apply
the leak fix from this thread, and see if SLUB behaves the same
(using Documentation/vm/slabinfo.c instead of /proc/slabinfo); but
chances are the problem's above it, and it will behave the same.

Best start a new thread when you can report back.

Thanks,
Hugh
