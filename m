Return-Path: <linux-kernel-owner+w=401wt.eu-S935238AbXJRWx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935238AbXJRWx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765285AbXJRWxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:53:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54677 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762818AbXJRWxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:53:41 -0400
Date: Thu, 18 Oct 2007 15:52:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Herbert Xu <herbert@gondor.apana.org.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] synchronize_irq needs a barrier
In-Reply-To: <1192745137.7367.40.camel@pasglop>
Message-ID: <alpine.LFD.0.999.0710181549330.26902@woody.linux-foundation.org>
References: <E1IiWnJ-0000ne-00@gondolin.me.apana.org.au>
 <1192745137.7367.40.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 19 Oct 2007, Benjamin Herrenschmidt wrote:
> 
> The barrier would guarantee that ioc->active (and in fact the write to
> the chip too above) are globally visible

No, it doesn't really guarantee that.

The thing is, there is no such thing as "globally visible".

There is a "ordering of visibility wrt CPU's", but it's not global, it's 
quite potentially per-CPU. So a barrier on one CPU doesn't guarantee 
anything at all without a barrier on the *other* CPU.

That said, the interrupt handling itself contains various barriers on the 
CPU's that receive interrupts, thanks to the spinlocking. But I do agree 
with Herbert that adding a "smb_mb()" is certainly in no way "obviously 
correct", because it doesn't talk about what the other side does wrt 
barriers and that word in memory.

		Linus
