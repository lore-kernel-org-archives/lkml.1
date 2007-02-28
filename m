Return-Path: <linux-kernel-owner+w=401wt.eu-S1752215AbXB1XVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbXB1XVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 18:21:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbXB1XVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 18:21:08 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:26352 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbXB1XVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 18:21:05 -0500
Date: Wed, 28 Feb 2007 15:20:47 -0800
From: Bill Irwin <bill.irwin@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Wanted: simple, safe x86 stack overflow detection
Message-ID: <20070228232047.GB10643@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Andi Kleen <andi@firstfloor.org>, Chuck Ebbert <cebbert@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <45E5913D.3080505@redhat.com> <20070228204144.GA32316@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228204144.GA32316@one.firstfloor.org>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28, 2007 at 09:41:44PM +0100, Andi Kleen wrote:
> Likely already too late then -- if critical state is overwritten
> you crashed before. Also a lot of stack intensive codes
> relatively large unused holes so it might miss the canary completely
> Anyways if you want a crash on context switch in the non
> hole case you can probably get it by just rearranging thread_info a bit.
> e.g. put preempt_count first. Any corruption of that will lead
> to schedule complaining.
> Don't think it is worth it though.
> I suppose one could have a CONFIG_DEBUG_STACK_OVERFLOW that gets
> the stacks from vmalloc which would catch any overflow with its
> guard pages. This is you would need to change __pa() to handle
> that too because there might be still some drivers that do
> DMA on stack addresses.  Would be somewhat ugly but doable.
> But I have my doubts it is worth it again -- in my experience static
> analysis works well enough to trace them down and 
> there are not that many anyways.

I don't know about the rest of the world, but halting the system in the
case of memory corruption sounds like an extremely good idea to me.


-- wli
