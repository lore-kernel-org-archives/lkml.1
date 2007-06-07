Return-Path: <linux-kernel-owner+w=401wt.eu-S1764544AbXFGWZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764544AbXFGWZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765977AbXFGWZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:25:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:50761 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932654AbXFGWZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:25:04 -0400
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel
	internal errnos
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <alpine.LFD.0.98.0706070852390.4205@woody.linux-foundation.org>
References: <20070606105900.DE5E94D0592@magilla.localdomain>
	 <alpine.LFD.0.98.0706060811470.4205@woody.linux-foundation.org>
	 <87sl949eyx.wl%takeuchi_satoru@jp.fujitsu.com>
	 <alpine.LFD.0.98.0706070852390.4205@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 08:24:27 +1000
Message-Id: <1181255068.14818.77.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-07 at 08:54 -0700, Linus Torvalds wrote:
> 
> On Thu, 7 Jun 2007, Satoru Takeuchi wrote:
> > 
> > I tested your patch and my problem didn't occur again, so it seems to my
> > this case at least.
> 
> Ok. I applied Roland's slightly bigger patch instead, since Ben and Paul
> pointed out that some kernel threads depend on dequeue_signal clearing the 
> bit. You might want to test that one too (or just get current git), just 
> in case there are any differences in behaviour (not bloody likely, but 
> still..)

Looks good to me. Do you think we need to do something about the DRM
notifier thingy too ? Or just let the code as-is, that is use the
notifier/mask (if any) of the task doing the dequeue_signal() ? I don't
see anybody insane enough to use signalfd read() with the DRM lock held
but who knows ...

Oh and Roland patch doesn't prevent signalfd() from stealing synchronous
signals such as SIGSEGV etc... which I think would result in random
behaviour.... do you want a patch for that or we just consider it broken
API usage and let it as it is ?

Cheers,
Ben.


