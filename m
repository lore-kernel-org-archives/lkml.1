Return-Path: <linux-kernel-owner+w=401wt.eu-S967702AbXFHDVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967702AbXFHDVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 23:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966962AbXFHDU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 23:20:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53485 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967318AbXFHDUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 23:20:55 -0400
Date: Thu, 7 Jun 2007 20:18:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel
 internal errnos
In-Reply-To: <1181255068.14818.77.camel@localhost.localdomain>
Message-ID: <alpine.LFD.0.98.0706072015520.4205@woody.linux-foundation.org>
References: <20070606105900.DE5E94D0592@magilla.localdomain> 
 <alpine.LFD.0.98.0706060811470.4205@woody.linux-foundation.org> 
 <87sl949eyx.wl%takeuchi_satoru@jp.fujitsu.com> 
 <alpine.LFD.0.98.0706070852390.4205@woody.linux-foundation.org>
 <1181255068.14818.77.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 Jun 2007, Benjamin Herrenschmidt wrote:
> 
> Looks good to me. Do you think we need to do something about the DRM
> notifier thingy too ?

No. I think that anybody who uses that gets whatever he deserves. It's 
designed for one particular usage scenario (where it should work fine), if 
you try to use it for something else across threads, you've already lost.

> Oh and Roland patch doesn't prevent signalfd() from stealing synchronous
> signals such as SIGSEGV etc... which I think would result in random
> behaviour.... do you want a patch for that or we just consider it broken
> API usage and let it as it is ?

I think Davide ack'ed your patch, but I also think that one clashes with 
the one I actually ended up applying. If you were to send me the signalfd 
part (tested, preferably), I'd apply it, considering that it seems to be 
the right thign to do, and it already got acked by Davide.

Or did I get confused by some other patches flying around?

(Gaah, there's been _way_ too much patching going on today, I'm not happy 
about how -rc4 seems to not be calming down)

		Linus
