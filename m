Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbZC0Wmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbZC0Wmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbZC0Wm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:42:27 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:58110 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbZC0Wm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:42:26 -0400
Message-ID: <49CD564E.6050101@msgid.tls.msk.ru>
Date: Sat, 28 Mar 2009 01:42:22 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: nicolas sitbon <nicolas.sitbon@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: epoll_ctl and const correctness
References: <84a01a8b0903250545n799a8727o1faad60c8eaf372e@mail.gmail.com>	 <49CAA055.5060603@goop.org>	 <84a01a8b0903251437l9f9059s3c548b5d35ea47d4@mail.gmail.com>	 <84a01a8b0903270244s146ca50cr2758d36c2d9d77cd@mail.gmail.com>	 <49CD4967.2090606@msgid.tls.msk.ru>	 <84a01a8b0903271517t668c6276l7fe098d74c24b836@mail.gmail.com> <84a01a8b0903271530of8d43ffhf77e7ba73e309f75@mail.gmail.com>
In-Reply-To: <84a01a8b0903271530of8d43ffhf77e7ba73e309f75@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nicolas sitbon wrote:
> I was looking at libevent of niels provos, and even him, is apparently
> doing a mistake :
> 
> static int
> epoll_add(void *arg, struct event *ev)
> {
> 	struct epollop *epollop = arg;
> 	struct epoll_event epev = {0, {0}};
> 
>         /* ... some code here ... */
> 	if (epoll_ctl(epollop->epfd, op, ev->ev_fd, &epev) == -1)
> 			return (-1);
> 
> 	/* Update events responsible */
> 	if (ev->ev_events & EV_READ)
> 		evep->evread = ev;
> 	if (ev->ev_events & EV_WRITE)
> 		evep->evwrite = ev;
> 
> 	return (0);
> }
> 
> the structure pointed to by &epev is allocated on the stack, so how
> the kernel could keep track of it?

I've no idea what are you talking about and what exactly
is your problem.  Both the examples (one at cplayer.org and
another above) gives correct usage of epoll.  If you don't
understand it, well, I'd suggest reading some documentation
first, maybe in kernel, maybe in glibc, maybe numerous
available on the net.  And all the numerous examples too,
which you quote as, for some reason, wrong.

/mjt
