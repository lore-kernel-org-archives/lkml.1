Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbZA0AY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbZA0AY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 19:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZA0AYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 19:24:47 -0500
Received: from viefep19-int.chello.at ([62.179.121.39]:22307 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbZA0AYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 19:24:46 -0500
X-SourceIP: 62.24.72.246
From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: Unexpected cascaded epoll behavior - my mistake or kernel bug
Date: Tue, 27 Jan 2009 01:24:40 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200901230109.55706.pisa@cmp.felk.cvut.cz> <alpine.DEB.1.10.0901261235000.26576@alien.or.mcafeemobile.com> <alpine.DEB.1.10.0901261259540.26576@alien.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0901261259540.26576@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901270124.40683.pisa@cmp.felk.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 January 2009 22:04:05 Davide Libenzi wrote:
> On Mon, 26 Jan 2009, Davide Libenzi wrote:
> > On Mon, 26 Jan 2009, Davide Libenzi wrote:
> > > On Mon, 26 Jan 2009, Pavel Pisa wrote:
> > > > Hello Davide,
> > > >
> > > > thanks for fast reply and effort.
> > > >
> > > > I have tested your patch with patched and unpatched 2.6.28.2 kernel.
> > > > The outputs are attached. The patched kernel passes all your tests.
> > > >
> > > > But I have bad news. My library code does not fall into busy loop
> > > > after your patching but my FIFO tests do not work even in
> > > > single level epoll scenario. The strace output is attached as well.
> > > > I try to do more testing tomorrow. I have returned from weekend trip
> > > > at the evening today and I have not much time for deeper analysis.
> > > >
> > > > But it looks like write level sensitive events are not triggering
> > > > for epoll at all. The pipe is not fill by any character and specified
> > > > timeout is triggered with next message as fail results.
> > > >   @ pipe #X evptrig wr timeout
> > > >   @ pipe #X evptrig rd timeout
> > > >
> > > > If you want to test the code on your box, download library
> > > >
> > > > http://cmp.felk.cvut.cz/~pisa/ulan/ul_evpoll-090123.tar.gz
> > > >
> > > > The simple "make" in the top directory should work.
> > >
> > > It'd be really great if you could spare me having to dig into few
> > > thousands lines of userspace library code, and you could isolate a
> > > little bit better what is the expected result, and the error result.
> >
> > Never mind, I looked myself and I'm able to replicate it with the simple
> > attached test program. Looking into it ...
>
> Alright, found it. Both mine and your test programs works fine now.

Hello Davide,

thanks much for fast testing and patches. I have run different combination
of the yours and mine tests on 2.6.28.2 patched by your latest fix
and all have passed.

Excuse me for long code. I have not been fast enough to prepare simpler
test. I have tried to log straces documenting the problem at least.
There has been another problem with test reduction, that behavior
has been timing dependant. Your pipe ping pong test works OK
on unpatched 2.6.28.2 for some reasons for example. The mine code
changed behavior according to log level and output redirection.
My updated version of code does not trigger problem as well. Only that
archived version has been relatively "reliable" in problem exposing.

I am running patched kernel on my laptop to test it in daily use now.

There are some questions to you (if you find time to reply):

1) is the original problem only exposed by epoll over epoll?
    If yes, then I expect, that I can use epoll over poll (glib)
    even on older kernels.

2) If there could be other scenario to invoke event stuck on unpatched
    kernel, what does exist some operation with epoll  set gets event
    reports into sync?  I would add it as workaround into library.

3) the epoll with level triggered events is most simple as poll replacement,
     but EPOLLONESHOT and EPOLLET could cause less overhead on
     the kernel side. Have you some idea about expected throughput
     change?

Thanks much again,

                      Pavel
