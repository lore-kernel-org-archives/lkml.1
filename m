Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbZLTPyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbZLTPyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 10:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbZLTPyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 10:54:17 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:60658 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbZLTPyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 10:54:16 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 20 Dec 2009 07:54:09 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Nikolai ZHUBR <zhubr@mail.ru>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re[3]: epoll'ing tcp sockets for reading
In-Reply-To: <1059651918.20091220032610@mail.ru>
Message-ID: <alpine.DEB.2.00.0912200750280.9679@makko.or.mcafeemobile.com>
References: <1257480306.20091219150206@mail.ru> <alpine.DEB.2.00.0912190953160.4482@makko.or.mcafeemobile.com> <203216314.20091220013854@mail.ru> <alpine.DEB.2.00.0912191437530.4482@makko.or.mcafeemobile.com> <1059651918.20091220032610@mail.ru>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Dec 2009, Nikolai ZHUBR wrote:

> Sunday, December 20, 2009, 1:56:22 AM, Davide Libenzi wrote:
> [trim]
> > The kernel cannot make decisions based on something whose knowledge is 
> > userspace bound.
> I didn't mean that. I just meant it would be usefull to let the caller
> of epoll know also the size of data related to specific EPOLLIN event in
> some "atomic" manner immediately, because the kernel probably knows this
> size already.
> The same thing can approximately be "emulated" by requesting FIOREAD for
> all EPOLLIN-ready sockets just after epoll returns, before any other work.
> It just would look not very elegant IMHO.

No such a thing of "atomic matter", since by the time you read the event, 
more data might have come. It's just flawed, you see that?



> > What you define as "abstract/imprecise/overcomplicated" are simply 
> > decisions that you, as implementor of the upper layer protocol, have to 
> > take in order to implement your userspace code.
> > And I, personally, see nothing even close to be defined complicated in 
> > such code.
> > Whenever you're asking for an abstraction/API to implement a kind 
> > of software which exist in large quantities on a system, you've got to ask 
> > yourself how relevant such abstraction is at the end, if all the existing 
> > software have done w/out it.
> Ok, maybe that's what I should have asked at the first place. What would
> you recommend as a reference implementation showing clean, efficient,
> fail-safe usage of epoll with sockets?
> Actually I've been googling for about 2 weeks to find some, but the results
> are rather scarce and dubious.

My reference was not epoll in particular, but more in general all the 
network/server software that have been written using select/poll and the 
current POSIX APIs, w/out the need of knowing how much data there was on 
the link.



- Davide


