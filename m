Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbZLSW40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbZLSW40 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 17:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbZLSW4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 17:56:25 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:34134 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbZLSW4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 17:56:24 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 19 Dec 2009 14:56:22 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Nikolai ZHUBR <zhubr@mail.ru>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re[2]: epoll'ing tcp sockets for reading
In-Reply-To: <203216314.20091220013854@mail.ru>
Message-ID: <alpine.DEB.2.00.0912191437530.4482@makko.or.mcafeemobile.com>
References: <1257480306.20091219150206@mail.ru> <alpine.DEB.2.00.0912190953160.4482@makko.or.mcafeemobile.com> <203216314.20091220013854@mail.ru>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Dec 2009, Nikolai ZHUBR wrote:

> > It is up to your application to handle data arrival correctly, according 
> > to the latency/throughput constraints of your software.
> > The "read until EAGAIN" that is cited inside the epoll man pages, does not 
> > mean that you have to exhaust the data in one single event processing loop.
> > After you have read and processed "enough data" (where enough depends on 
> > the nature and constraints of your software), you can just drop that fd 
> > into an "hot list" and pick the timeout for your next epoll_wait() 
> > depending on the fact that such list is empty or not (you'd pick zero if 
> > not empty). Proper handling of new and hot events will ensure that no 
> > connections will be starving for service.
> 
> Well, no doubt, terrible starvation can be avoided this way, ok.
> However doesn't this look like userspace code is forced to make decisions
> (when to pause reading new data and proceed to other sockets etc.) based on
> some rather abstract/imprecise/overcomplicated assumptions and/or with
> the help of additional syscalls, while a simple and reasonable hint for
> such a decision being wasted somewhere on the way from kernelspace to
> userspace?

The kernel cannot make decisions based on something whose knowledge is 
userspace bound.
What you define as "abstract/imprecise/overcomplicated" are simply 
decisions that you, as implementor of the upper layer protocol, have to 
take in order to implement your userspace code.
And I, personally, see nothing even close to be defined complicated in 
such code.
Whenever you're asking for an abstraction/API to implement a kind 
of software which exist in large quantities on a system, you've got to ask 
yourself how relevant such abstraction is at the end, if all the existing 
software have done w/out it.



- Davide


