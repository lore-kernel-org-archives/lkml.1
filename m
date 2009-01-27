Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbZA0BD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbZA0BD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 20:03:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbZA0BDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 20:03:20 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:50853 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZA0BDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 20:03:19 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 26 Jan 2009 17:03:17 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Pavel Pisa <pisa@cmp.felk.cvut.cz>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unexpected cascaded epoll behavior - my mistake or kernel bug
In-Reply-To: <200901270124.40683.pisa@cmp.felk.cvut.cz>
Message-ID: <alpine.DEB.1.10.0901261652150.8049@alien.or.mcafeemobile.com>
References: <200901230109.55706.pisa@cmp.felk.cvut.cz> <alpine.DEB.1.10.0901261235000.26576@alien.or.mcafeemobile.com> <alpine.DEB.1.10.0901261259540.26576@alien.or.mcafeemobile.com> <200901270124.40683.pisa@cmp.felk.cvut.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009, Pavel Pisa wrote:

> Hello Davide,
> 
> thanks much for fast testing and patches. I have run different combination
> of the yours and mine tests on 2.6.28.2 patched by your latest fix
> and all have passed.
> 
> Excuse me for long code. I have not been fast enough to prepare simpler
> test. I have tried to log straces documenting the problem at least.
> There has been another problem with test reduction, that behavior
> has been timing dependant. Your pipe ping pong test works OK
> on unpatched 2.6.28.2 for some reasons for example. The mine code
> changed behavior according to log level and output redirection.
> My updated version of code does not trigger problem as well. Only that
> archived version has been relatively "reliable" in problem exposing.

The epoll pipe ping-pong only fails in the first version patch I sent you. 
It was a bug in the patch. Older kernel, and the ones using the new 
version of the patch are fine, WRT that test.



> 1) is the original problem only exposed by epoll over epoll?
>     If yes, then I expect, that I can use epoll over poll (glib)
>     even on older kernels.

No. Epoll's poll() was broken, that means you could not add the epoll fd 
inside any container (poll and select). Well, you can, but you get 
spurious wakeups.



> 2) If there could be other scenario to invoke event stuck on unpatched
>     kernel, what does exist some operation with epoll  set gets event
>     reports into sync?  I would add it as workaround into library.

Look at how the epoll_test.c program I sent you, does.



> 3) the epoll with level triggered events is most simple as poll replacement,
>      but EPOLLONESHOT and EPOLLET could cause less overhead on
>      the kernel side. Have you some idea about expected throughput
>      change?

It all depends on the application. EPOLLET departs from other event fetch 
machanisms, so if you have a generic library, you may want to be careful 
in its usage.



- Davide


