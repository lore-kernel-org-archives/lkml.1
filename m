Return-Path: <linux-kernel-owner+w=401wt.eu-S1758923AbYJMO4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923AbYJMO4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbYJMO4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:56:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:41575 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbYJMO4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:56:03 -0400
Date: Mon, 13 Oct 2008 10:55:59 -0400
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Karel Zak <kzak@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [kerneloops] regression in 2.6.27 wrt "lock_page" and the
 "hwclock" program
Message-ID: <20081013105559.15ccb67f@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0810121308210.3402@nehalem.linux-foundation.org>
References: <20081004174433.14a5e093@infradead.org>
	<20081004215225.2444d54b.akpm@linux-foundation.org>
	<20081005081145.30ba921b@infradead.org>
	<20081005102742.de8353b4.akpm@linux-foundation.org>
	<20081005103826.6771540a@infradead.org>
	<20081012200004.GI10429@nb.net.home>
	<alpine.LFD.2.00.0810121308210.3402@nehalem.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Oct 2008 13:16:12 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sun, 12 Oct 2008, Karel Zak wrote:
> >
> >  Any suggestion how to nicely implement "don't schedule me out"?
> 
> There's nothing you can do. If you take a page fault, you're done.
> Forget about any "can't schedule" or "don't enable interrupts". The
> kernel _has_ to handle the page fault, and that may involve IO and
> thus random pauses. No ifs, buts or maybe's about it.
> 
> This patch may or may not get rid of the warning, at least. It won't
> fix hwclock, but that's apparently unfixable from the kernel - the
> thing is just plain buggy.


it almost sounds like it's trying to do something that ... really the
kernel should be doing.

Karel: Can you describe what it WANTS to do so we can see if we can
just extend the linux kernel to do that the right way?

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
