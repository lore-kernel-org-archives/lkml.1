Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbYCIUVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbYCIUVt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 16:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYCIUVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 16:21:42 -0400
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:18811 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbYCIUVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 16:21:41 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: quicklists confuse meminfo
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de>
	<20080309111456.GA21690@elte.hu>
	<20080309210000.C6DE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080309120940.GA1695@elte.hu> <20080309123432.GA3267@elte.hu>
	<20080309114640.85c9c3eb.akpm@linux-foundation.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 09 Mar 2008 21:21:38 +0100
In-Reply-To: <20080309114640.85c9c3eb.akpm@linux-foundation.org>
Message-ID: <8763vv1wdp.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Mar 2008 20:15:07.0174 (UTC) FILETIME=[449DA460:01C88222]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Sun, 9 Mar 2008 13:34:32 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > the right solution is to get rid of quicklists altogether
> 
> Yes, I think so.
> 
> - They are pretty marginal from a performance POV (iirc)

One general issue -- as noted again by Christoph Lameter recently --
is that the order 0 fast path in page_alloc.c isn't actually very 
fast. That is why people keep inventing their own...

 > - As I said when we merged them (under protest): Private object caches
>   like this are just a bad idea - caches should be *shared*, because some
>   other code path which wants a zeroed page wants a cache-warm one, not a
>   cache-cold one from the allocator (iirc there was doubt over how
>   cache-warm these pages are, however).
> 
>   Making __GFP_ZERO smarter/more efficient would be a preferable way of
>   addressing any performance problems we have in there.

To do the same as quicklists you would need a __free_pages_zeroed()
and separate buddy lists I think.  Later is probably somewhat ugly.
Or perhaps do it only for order 0?

Or perhaps idle time zeroing should be reinvestigated on modern CPUs,
but I'm always a little sceptical of that.

-Andi
