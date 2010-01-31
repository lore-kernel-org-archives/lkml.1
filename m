Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857Ab0AaS16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab0AaS16 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 13:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201Ab0AaS15
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 13:27:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:50456 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab0AaS15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 13:27:57 -0500
Date: Sun, 31 Jan 2010 10:28:46 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: High scheduler wake up times
Message-ID: <20100131102846.4d1e18aa@infradead.org>
In-Reply-To: <20100131034718.GE27390@mediacenter.gateway.2wire.net>
References: <20100130234551.GA27390@mediacenter.gateway.2wire.net>
	<20100130161114.07278221@infradead.org>
	<20100131003549.GC27390@mediacenter.gateway.2wire.net>
	<20100130164716.230dfe31@infradead.org>
	<20100131034718.GE27390@mediacenter.gateway.2wire.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jan 2010 21:47:18 -0600
Shawn Bohrer <shawn.bohrer@gmail.com> wrote:
> 
> Of course that patch makes my situation worse, which was my point.  We
> are depending on the _current_ epoll_wait() implementation which calls
> schedule_timeout(1).  

> You do agree that the current epoll_wait()
> implementation sleeps less than 1 msec with HZ == 1000 correct? 

I agree with your hypothesis, but I wouldn't call the behavior
correct ;-)

First of all, jiffies based timeouts are supposed to round *up*, not
down, and second.. it should really be just 1 msec.


> With the old kernel I can run 500 of these processes, and I'm hoping
> that I'm simply missing the knob I need to tweak to achieve similar
> performance on a recent kernel.

can you run powertop during your workload? maybe you're getting hit by
some C state exit latencies tilting the rounding over the top just too
many times...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
