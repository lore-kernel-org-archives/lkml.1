Return-Path: <linux-kernel-owner+w=401wt.eu-S1759076AbYGKCD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076AbYGKCD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 22:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbYGKCDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 22:03:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752920AbYGKCDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 22:03:19 -0400
Date: Thu, 10 Jul 2008 19:02:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: <alpine.LFD.1.10.0807101824150.2936@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807101855020.2936@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain> <alpine.LFD.1.10.0807101459000.2936@woody.linux-foundation.org> <20080710224256.AD038154218@magilla.localdomain> <alpine.LFD.1.10.0807101549590.2936@woody.linux-foundation.org>
 <20080711005243.ADE90154218@magilla.localdomain> <alpine.LFD.1.10.0807101824150.2936@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Jul 2008, Linus Torvalds wrote:
> 
> So the x86-64 behaviour actually matches what the x86-32 behavior was at 
> the time before things split.
> 
> And I'd also like to point out another commit, namely "[PATCH] fix broken 
> vm86 interrupt/signal handling" (4031ff388138b58e5cd472dccce38828bcb8c706) 
> that fixed a bug with an endless loop you had introduced in that original 
> x86-32 code when you fixed this exact same issue back when.
> 
> Heh. That's the kind of thing that worries me.

That said, seeing the full history of this same thing on the x86-32 side 
actually makes me _much_ happier about the patch. Because now I can tell 
when we did it, and what problems it seems to have caused (answer: 
"apparently none that are possibly relevant on x86-64").

IOW, just seeing the fact that we used to behave the same, and then 
changed it on the 32-bit side (with no apparent big issues) and did it 
without updating the 64-bit side, makes me just much happier about your 
patch. Just because I know know the background to why this was x86-64 
only.

So now I'm considering just putting it in before the 2.6.26 release after 
all ;)

		Linus
