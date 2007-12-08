Return-Path: <linux-kernel-owner+w=401wt.eu-S1752011AbXLHSK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbXLHSK0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 13:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbXLHSKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 13:10:18 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38089 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750701AbXLHSKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 13:10:16 -0500
Date: Sat, 8 Dec 2007 10:09:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52,
 [2.6.24-rc4-git5: Reported regressions from 2.6.23]
Message-Id: <20071208100950.a3547868.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org>
References: <200712080340.49546.rjw@sisk.pl>
	<20071208093039.GA28054@elte.hu>
	<20071208163749.GI19691@waste.org>
	<alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org>
	<alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007 09:54:06 -0800 (PST) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 8 Dec 2007, Linus Torvalds wrote:
> > 
> > But I'll apply it anyway, because it looks "obviously correct" from the 
> > standpoint that the _other___slob user already clears the end result 
> > explicitly later on, and we simply should never pass down __GFP_ZERO to 
> > the actual page allocator.
> 
> Actually, I take that back. The other slob users are different. They share 
> pages, this codepath does not.
> 
> So I think a more proper solution would be:
>  (a) Something like this patch (which includes my previous mm/slub.c 
>      change)
>  (b) don't warn about atomic GFP_ZERO's - unless they have GFP_HIGHMEM set 
>      *too*.
> 
> So which warning is it that triggers the bogus error?

It's a kmap_atomic() debugging patch which I wrote ages ago and whcih Ingo
sucked into his tree.  I don't _think_ this warning is present in your tree
at all.

http://lkml.org/lkml/2007/11/29/157 is where it starts.

I had a lenghty back-and-forth with Christoph on this within the past
couple of months and I cannot locate the thread and I don't recall what the
upshot was and Christoph is still offline.

Knocking out __GFP_ZERO at the point where the slab allocator(s) call the
page allocator seems like a good approach to me.

But I don't think we need to do anything for 2.6.24..
