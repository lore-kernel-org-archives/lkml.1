Return-Path: <linux-kernel-owner+w=401wt.eu-S1422696AbXDRJ2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422696AbXDRJ2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 05:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422714AbXDRJ2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 05:28:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60757 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422696AbXDRJ2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 05:28:14 -0400
Date: Wed, 18 Apr 2007 11:28:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Pfister <christophpfister@gmail.com>
Cc: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org, Michael Lothian <mike@fireburn.co.uk>,
       Christophe Thommeret <hftom@free.fr>, Jurgen Kofler <kaffeine@gmx.net>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: Kaffeine problem with CFS
Message-ID: <20070418092805.GA23125@elte.hu>
References: <200704141959.50076.caglar@pardus.org.tr> <20070415161348.GA30625@elte.hu> <20070415162508.GA4526@elte.hu> <19a3b7a80704150955x4e1d809eh929b0f931f842a06@mail.gmail.com> <20070418082744.GA14009@elte.hu> <19a3b7a80704180157g604f4cecna51a49bd1f4c7d38@mail.gmail.com> <20070418090117.GA20764@elte.hu> <19a3b7a80704180213i1ac84b2ch2b35220b62e3b67a@mail.gmail.com> <20070418091714.GA23446@elte.hu> <19a3b7a80704180225x3c8d6d60g366126862f05150@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19a3b7a80704180225x3c8d6d60g366126862f05150@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Pfister <christophpfister@gmail.com> wrote:

> >which thread would be the most interesting to you - 9324?
> 
> The thread which should wake the main thread - but hmm ... 9303 seems 
> to be rather dead-locked than doing pthread_cond_timedwait() ?

ok, here it is, 9303 with better symbol names:

#0  0xffffe410 in __kernel_vsyscall ()
#1  0x4a2538ce in __lll_mutex_lock_wait () from /lib/libpthread.so.0
#2  0x4a24f71c in _L_mutex_lock_79 () from /lib/libpthread.so.0
#3  0x4a24f24d in pthread_mutex_lock () from /lib/libpthread.so.0
#4  0xb79f64f9 in xine_play () from /usr/lib/libxine.so.1
#5  0xb7a9b0fb in KXineWidget::slotSeekToPosition ()
   from /usr/lib/kde3/libxinepart.so
#6  0xb7a9b3bc in KXineWidget::wheelEvent () from /usr/lib/kde3/libxinepart.so
#7  0x4b5f9150 in QWidget::event () from /usr/lib/qt-3.3/lib/libqt-mt.so.3
#8  0x4b55353b in QApplication::internalNotify ()
   from /usr/lib/qt-3.3/lib/libqt-mt.so.3
#9  0x4b55526e in QApplication::notify ()
   from /usr/lib/qt-3.3/lib/libqt-mt.so.3
#10 0x4a72065e in KApplication::notify () from /usr/lib/libkdecore.so.4
#11 0x4b4dd5de in QETWidget::translateWheelEvent ()
   from /usr/lib/qt-3.3/lib/libqt-mt.so.3
#12 0x4b4eb41d in QETWidget::translateMouseEvent ()
   from /usr/lib/qt-3.3/lib/libqt-mt.so.3
#13 0x4b4e9766 in QApplication::x11ProcessEvent ()
   from /usr/lib/qt-3.3/lib/libqt-mt.so.3
#14 0x4b4fb38b in QEventLoop::processEvents ()
   from /usr/lib/qt-3.3/lib/libqt-mt.so.3
#15 0x4b56ce30 in QEventLoop::enterLoop ()
   from /usr/lib/qt-3.3/lib/libqt-mt.so.3
#16 0x4b56cce6 in QEventLoop::exec () from /usr/lib/qt-3.3/lib/libqt-mt.so.3
#17 0x4b55317f in QApplication::exec () from /usr/lib/qt-3.3/lib/libqt-mt.so.3
#18 0x0806fc1a in QWidget::setUpdatesEnabled ()
#19 0x49f9df10 in __libc_start_main () from /lib/libc.so.6
#20 0x0806f7e1 in QWidget::setUpdatesEnabled ()

does this make more sense to you?

	Ingo
