Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbXD0Tpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbXD0Tpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757170AbXD0Tpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 15:45:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:55277 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755959AbXD0To4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 15:44:56 -0400
X-Authenticated: #420190
X-Provags-ID: V01U2FsdGVkX180tE12jUo0oPKJjMsHOFvrehRAhrJYow8mjvgJgw
	JNXxEsV9qjIG4V
Message-ID: <4632527C.6090509@gmx.net>
Date: Fri, 27 Apr 2007 21:43:56 +0200
From: Marko Macek <marko.macek@gmx.net>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
 FS is under heavy write load (massive starvation)
References: <1177660767.6567.41.camel@Homer.simpson.net> <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org> <alpine.DEB.0.98.0704271139190.29118@sigma.j-a-k-j.com> <alpine.LFD.0.98.0704270852480.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704270852480.9964@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 27 Apr 2007, John Anthony Kazos Jr. wrote:
>> Could[/should] this stuff be changed from ratios to amounts? Or a quick 
>> boot-time test to use a ratio if the memory is small and an amount (like 
>> tax brackets, I would expect) if it's great?
> 
> Yes, the "percentage" thing was likely wrong. That said, there *is* some 
> correlation between "lots of memory" and "high-end machine", and that in 
> turn tends to correlate with "fast disk", so I don't think the percentage 
> approach is really *horribly* wrong.
> 
> The main issue with the percentage is that we do export them as such 
> through the /proc/ interface, and they are easy to change and understand. 
> So changing them to amounts is non-trivial if you also want to support the 
> old interfaces - and the advantage isn't obvious enough that it's a 
> clear-cut case.

I wonder if it would be useful if the limit was 'data we can write out 
in 1 (configurable) second. This would typically mean either one 50mb 
(depending on disk) contigous block or 100-200 scattered blocks (since 
the typical disk latency is about 5-10ms).

Has anyone tried something like this?

Mark
