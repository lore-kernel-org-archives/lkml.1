Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbXB1Ulr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbXB1Ulr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 15:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932234AbXB1Ulr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 15:41:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59998 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224AbXB1Ulr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 15:41:47 -0500
Date: Wed, 28 Feb 2007 21:41:44 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: Wanted: simple, safe x86 stack overflow detection
Message-ID: <20070228204144.GA32316@one.firstfloor.org>
References: <45E5913D.3080505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E5913D.3080505@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28, 2007 at 09:27:09AM -0500, Chuck Ebbert wrote:
> Can we just put a canary in the threadinfo and check it on every
> task switch? What are the drawbacks?

Likely already too late then -- if critical state is overwritten
you crashed before. Also a lot of stack intensive codes
relatively large unused holes so it might miss the canary completely

Anyways if you want a crash on context switch in the non
hole case you can probably get it by just rearranging thread_info a bit.
e.g. put preempt_count first. Any corruption of that will lead
to schedule complaining.

Don't think it is worth it though.

I suppose one could have a CONFIG_DEBUG_STACK_OVERFLOW that gets
the stacks from vmalloc which would catch any overflow with its
guard pages. This is you would need to change __pa() to handle
that too because there might be still some drivers that do
DMA on stack addresses.  Would be somewhat ugly but doable.

But I have my doubts it is worth it again -- in my experience static
analysis works well enough to trace them down and 
there are not that many anyways.

-Andi
