Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbZC0WmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbZC0WmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbZC0WmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:42:07 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:49145 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbZC0WmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:42:06 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 27 Mar 2009 15:40:42 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: nicolas sitbon <nicolas.sitbon@gmail.com>
cc: Michael Tokarev <mjt@tls.msk.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: epoll_ctl and const correctness
In-Reply-To: <84a01a8b0903271530of8d43ffhf77e7ba73e309f75@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0903271535350.31272@makko.or.mcafeemobile.com>
References: <84a01a8b0903250545n799a8727o1faad60c8eaf372e@mail.gmail.com>  <49CAA055.5060603@goop.org>  <84a01a8b0903251437l9f9059s3c548b5d35ea47d4@mail.gmail.com>  <84a01a8b0903270244s146ca50cr2758d36c2d9d77cd@mail.gmail.com>  <49CD4967.2090606@msgid.tls.msk.ru>
  <84a01a8b0903271517t668c6276l7fe098d74c24b836@mail.gmail.com> <84a01a8b0903271530of8d43ffhf77e7ba73e309f75@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009, nicolas sitbon wrote:

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

Oh, I see, Niels is doing mistakes, whereas you've all figured out.



- Davide


