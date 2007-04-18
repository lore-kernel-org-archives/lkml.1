Return-Path: <linux-kernel-owner+w=401wt.eu-S1422756AbXDRJwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422756AbXDRJwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 05:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422757AbXDRJwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 05:52:32 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:60581 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422756AbXDRJwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 05:52:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=J9AZejUXgLfGLxj3L7BO6fBYWIU43iHQv6nZ3uaotqzHB9NRGdKL4ny7uBuZ3mKFEksRP62nJkMX/x5rb3VleFd8JoMhOOusy1EsfEgOUnK2KZ6rT+kPJAZPAkYSBfQwly5NsInwW5vMFWBn+giB2gZWr+D+H4LqnYhoxGv51bc=
Message-ID: <19a3b7a80704180252j72c955bcna5df5cb7057e6756@mail.gmail.com>
Date: Wed, 18 Apr 2007 11:52:30 +0200
From: "Christoph Pfister" <christophpfister@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Kaffeine problem with CFS
Cc: "=?ISO-8859-9?Q?S.=C7a=F0lar_Onur?=" <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org, "Michael Lothian" <mike@fireburn.co.uk>,
       "Christophe Thommeret" <hftom@free.fr>,
       "Jurgen Kofler" <kaffeine@gmx.net>,
       "Ulrich Drepper" <drepper@redhat.com>
In-Reply-To: <20070418092805.GA23125@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200704141959.50076.caglar@pardus.org.tr>
	 <20070415162508.GA4526@elte.hu>
	 <19a3b7a80704150955x4e1d809eh929b0f931f842a06@mail.gmail.com>
	 <20070418082744.GA14009@elte.hu>
	 <19a3b7a80704180157g604f4cecna51a49bd1f4c7d38@mail.gmail.com>
	 <20070418090117.GA20764@elte.hu>
	 <19a3b7a80704180213i1ac84b2ch2b35220b62e3b67a@mail.gmail.com>
	 <20070418091714.GA23446@elte.hu>
	 <19a3b7a80704180225x3c8d6d60g366126862f05150@mail.gmail.com>
	 <20070418092805.GA23125@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/4/18, Ingo Molnar <mingo@elte.hu>:
>
> * Christoph Pfister <christophpfister@gmail.com> wrote:
>
> > >which thread would be the most interesting to you - 9324?
> >
> > The thread which should wake the main thread - but hmm ... 9303 seems
> > to be rather dead-locked than doing pthread_cond_timedwait() ?
>
> ok, here it is, 9303 with better symbol names:
>
> #0  0xffffe410 in __kernel_vsyscall ()
> #1  0x4a2538ce in __lll_mutex_lock_wait () from /lib/libpthread.so.0
> #2  0x4a24f71c in _L_mutex_lock_79 () from /lib/libpthread.so.0
> #3  0x4a24f24d in pthread_mutex_lock () from /lib/libpthread.so.0
> #4  0xb79f64f9 in xine_play () from /usr/lib/libxine.so.1
> #5  0xb7a9b0fb in KXineWidget::slotSeekToPosition ()
>    from /usr/lib/kde3/libxinepart.so
> #6  0xb7a9b3bc in KXineWidget::wheelEvent () from /usr/lib/kde3/libxinepart.so
> #7  0x4b5f9150 in QWidget::event () from /usr/lib/qt-3.3/lib/libqt-mt.so.3
> #8  0x4b55353b in QApplication::internalNotify ()
>    from /usr/lib/qt-3.3/lib/libqt-mt.so.3
> #9  0x4b55526e in QApplication::notify ()
>    from /usr/lib/qt-3.3/lib/libqt-mt.so.3
> #10 0x4a72065e in KApplication::notify () from /usr/lib/libkdecore.so.4
> #11 0x4b4dd5de in QETWidget::translateWheelEvent ()
>    from /usr/lib/qt-3.3/lib/libqt-mt.so.3
> #12 0x4b4eb41d in QETWidget::translateMouseEvent ()
>    from /usr/lib/qt-3.3/lib/libqt-mt.so.3
> #13 0x4b4e9766 in QApplication::x11ProcessEvent ()
>    from /usr/lib/qt-3.3/lib/libqt-mt.so.3
> #14 0x4b4fb38b in QEventLoop::processEvents ()
>    from /usr/lib/qt-3.3/lib/libqt-mt.so.3
> #15 0x4b56ce30 in QEventLoop::enterLoop ()
>    from /usr/lib/qt-3.3/lib/libqt-mt.so.3
> #16 0x4b56cce6 in QEventLoop::exec () from /usr/lib/qt-3.3/lib/libqt-mt.so.3
> #17 0x4b55317f in QApplication::exec () from /usr/lib/qt-3.3/lib/libqt-mt.so.3
> #18 0x0806fc1a in QWidget::setUpdatesEnabled ()
> #19 0x49f9df10 in __libc_start_main () from /lib/libc.so.6
> #20 0x0806f7e1 in QWidget::setUpdatesEnabled ()
>
> does this make more sense to you?

It's nearly impossible for me to find out which mutex is deadlocking.
There are 4 mutexs locked / released during xine_play (or one of the
possibly inlined functions) and to be honest I have little idea which
other thread is also involved in the deadlock (maybe some xine-lib
junkie could help you more with that).
It would be great if you could reproduce the same problem with a
xine-lib which has been compiled with debug support (so you'd get line
numbers in the back trace - that makes life _a lot_ easier and maybe I
could identify the problem that way) and the least optimization
possible ... :-)

>         Ingo

Christoph
