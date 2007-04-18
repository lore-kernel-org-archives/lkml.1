Return-Path: <linux-kernel-owner+w=401wt.eu-S1161459AbXDRI54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161459AbXDRI54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 04:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161460AbXDRI54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 04:57:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:15043 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161459AbXDRI5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 04:57:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i+Er+n576BCPYjz0bxwetFkN3bc9O6mhbSE3oVjUEX3/7rJLrAKLTDbnzxcuBXzfZMFYXFQ0i7c409LsmsB69B2aaCLaYbQ3jr2FeGM6v8h4XrBuWKv83HN/uUhduUjZB5mGUdqOOjgOz/D3Z7uMHcL2/ND8HGTbZ6p+Eyswm4Q=
Message-ID: <19a3b7a80704180157g604f4cecna51a49bd1f4c7d38@mail.gmail.com>
Date: Wed, 18 Apr 2007 10:57:54 +0200
From: "Christoph Pfister" <christophpfister@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Kaffeine problem with CFS
Cc: "=?ISO-8859-9?Q?S.=C7a=F0lar_Onur?=" <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org, "Michael Lothian" <mike@fireburn.co.uk>,
       "Christophe Thommeret" <hftom@free.fr>,
       "Jurgen Kofler" <kaffeine@gmx.net>,
       "Ulrich Drepper" <drepper@redhat.com>
In-Reply-To: <20070418082744.GA14009@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070413202100.GA9957@elte.hu>
	 <200704141809.58737.caglar@pardus.org.tr>
	 <20070414160939.GB3099@elte.hu>
	 <200704141959.50076.caglar@pardus.org.tr>
	 <20070415161348.GA30625@elte.hu> <20070415162508.GA4526@elte.hu>
	 <19a3b7a80704150955x4e1d809eh929b0f931f842a06@mail.gmail.com>
	 <20070418082744.GA14009@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2007/4/18, Ingo Molnar <mingo@elte.hu>:
>
> [ i've Cc:-ed Ulrich Drepper, this CFS-triggered hang seems to have some
>   futex and pthread_cond_wait() relevance. ]
>
> * Christoph Pfister <christophpfister@gmail.com> wrote:
>
> > >> > [1] http://cekirdek.pardus.org.tr/~caglar/strace.kaffeine
> >
> > Could you try xine-ui or gxine? Because I suspect rather xine-lib for
> > freezing issues. In any way I think a gdb backtrace would be much
> > nicer - but if you can't reproduce the freeze issue with other xine
> > based players and want to run kaffeine in gdb, you need to execute
> > "gdb --args kaffeine --nofork".
>
> update: i've reproduced one kind of a hang but i'm not sure it's the
> same hang Ismail is seeing. It was quite hard to trigger it under CFS, i
> had to do wild forward/backward button seeks on a real DVD and i mixed
> it with CPU-intense workloads on the same box. Here are the straces and
> gdb backtraces:
>
> kaffeine thread PID 9303, waiting for other threads to do something,
> stuck in pthread_mutex_lock():
>
>   futex(0xb07409e0, FUTEX_WAIT, 2, NULL <unfinished ...>
>
> backtrace:
>
>  #0  0xffffe410 in __kernel_vsyscall ()
>  #1  0x4a2538ce in __lll_mutex_lock_wait () from /lib/libpthread.so.0
>  #2  0x4a24f71c in _L_mutex_lock_79 () from /lib/libpthread.so.0
>  #3  0x4a24f24d in pthread_mutex_lock () from /lib/libpthread.so.0
>  #4  0xb79f64f9 in xine_play () from /usr/lib/libxine.so.1
>  #5  0xb7a9b0fb in KXineWidget::slotSeekToPosition () from /usr/lib/kde3/libxinepart.so
>  #6  0xb7a9b3bc in KXineWidget::wheelEvent () from /usr/lib/kde3/libxinepart.so
>  #7  0x4b5f9150 in QWidget::event () from /usr/lib/qt-3.3/lib/libqt-mt.so.3
>  #8  0x4b55353b in QApplication::internalNotify () from /usr/lib/qt-3.3/lib/libqt-mt.so.3
>  #9  0x4b55526e in QApplication::notify ()   from /usr/lib/qt-3.3/lib/libqt-mt.so.3
>  #10 0x4a72065e in KApplication::notify () from /usr/lib/libkdecore.so.4
>  #11 0x4b4dd5de in QETWidget::translateWheelEvent ()   from /usr/lib/qt-3.3/lib/libqt-mt.so.3
>  #12 0x4b4eb41d in QETWidget::translateMouseEvent ()   from /usr/lib/qt-3.3/lib/libqt-mt.so.3
>  #13 0x4b4e9766 in QApplication::x11ProcessEvent ()   from /usr/lib/qt-3.3/lib/libqt-mt.so.3
>  #14 0x4b4fb38b in QEventLoop::processEvents ()   from /usr/lib/qt-3.3/lib/libqt-mt.so.3
>  #15 0x4b56ce30 in QEventLoop::enterLoop ()   from /usr/lib/qt-3.3/lib/libqt-mt.so.3
>  #16 0x4b56cce6 in QEventLoop::exec () from /usr/lib/qt-3.3/lib/libqt-mt.so.3
>  #17 0x4b55317f in QApplication::exec () from /usr/lib/qt-3.3/lib/libqt-mt.so.3
>  #18 0x0806fc1a in QWidget::setUpdatesEnabled ()
>  #19 0x49f9df10 in __libc_start_main () from /lib/libc.so.6
>  #20 0x0806f7e1 in QWidget::setUpdatesEnabled ()
>
> Kaffeine thread 9324, seems to be in an infinite pthread_cond_wait()
> loop that does:
>
>  futex(0xb0740b78, FUTEX_WAIT, 3559, NULL) = 0
>  futex(0xb0740b5c, FUTEX_WAKE, 1)        = 0
>  munmap(0xaacb1000, 1662976)             = 0
>  mmap2(NULL, 1662976, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xaacb1000
>  gettimeofday({1176891363, 347259}, NULL) = 0
>  munmap(0xab309000, 1662976)             = 0
>
> backtrace:
>
>  #0  0xffffe410 in __kernel_vsyscall ()
>  #1  0x4a2510c6 in pthread_cond_wait@@GLIBC_2.3.2 () from /lib/libpthread.so.0
>  #2  0xb79fd1a8 in QWidget::setUpdatesEnabled () from /usr/lib/libxine.so.1
>  #3  0xb7a030ab in QWidget::setUpdatesEnabled () from /usr/lib/libxine.so.1
>  #4  0x4a24d2db in start_thread () from /lib/libpthread.so.0
>  #5  0x4a05820e in clone () from /lib/libc.so.6

This backtrace is useless - QWidget::setUpdatesEnabled() is certainly
_not_ defined in libxine. So the function names in #2 and #3 are wrong
because the addresses seem to belong to libxine.

> Kaffine thread 9325 does a loop of short pthread_cond_wait() futex
> sleeps:
>
>  1176891721.419314 futex(0xb07527e8, FUTEX_WAIT, 8537, NULL) = 0 <0.011710>
>  1176891721.431068 futex(0xb07527cc, FUTEX_WAKE, 1) = 0 <0.000006>
>  1176891721.431429 futex(0xb0740c04, 0x5 /* FUTEX_??? */, 1) = 1 <0.000008>
>  1176891721.431458 futex(0xb0740be8, FUTEX_WAKE, 1) = 1 <0.000012>
>  1176891721.431489 futex(0xb07527e8, FUTEX_WAIT, 8539, NULL) = 0 <0.007339>
>  1176891721.439008 futex(0xb07527cc, FUTEX_WAKE, 1) = 0 <0.000052>
>  1176891721.439510 futex(0xb0740c04, 0x5 /* FUTEX_??? */, 1) = 1 <0.000055>
>  1176891721.439636 futex(0xb0740be8, FUTEX_WAKE, 1) = 1 <0.000089>
>  1176891721.439789 futex(0xb07527e8, FUTEX_WAIT, 8541, NULL) = 0 <0.007045>
>  1176891721.447017 futex(0xb07527cc, FUTEX_WAKE, 1) = 0 <0.000054>
>  1176891721.447682 futex(0xb0740c04, 0x5 /* FUTEX_??? */, 1) = 1 <0.000065>
>
> backtrace:
>
>  #0  0xffffe410 in __kernel_vsyscall ()
>  #1  0x4a2510c6 in pthread_cond_wait@@GLIBC_2.3.2 () from /lib/libpthread.so.0
>  #2  0xb79fd1a8 in QWidget::setUpdatesEnabled () from /usr/lib/libxine.so.1
>  #3  0xb7a04079 in QWidget::setUpdatesEnabled () from /usr/lib/libxine.so.1
>  #4  0x4a24d2db in start_thread () from /lib/libpthread.so.0
>  #5  0x4a05820e in clone () from /lib/libc.so.6

Dito.

> library versions:
>
>  xine-lib-1.1.5-1.fc7
>  xine-plugin-1.0-3.fc7
>  glibc-headers-2.5.90-21
>  glibc-common-2.5.90-21
>  glibc-2.5.90-21
>  glibc-devel-2.5.90-21
>  gxine-0.5.11-3.fc7
>  kaffeine-0.8.3-4.fc7
>  xine-0.99.4-11.lvn7
>  xine-lib-extras-1.1.5-1.fc7
>  gxine-mozplugin-0.5.11-3.fc7
>
> what's weird is that all threads are in a pthread op and seem to be kind
> of busy-looping. Maybe xine-lib has some buggy use of pthread condvars
> that CFS happens to trigger? (If CFS broke futexes in general i think
> we'd be seeing far more widespread breakage.)
>
>         Ingo

Christoph
