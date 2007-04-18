Return-Path: <linux-kernel-owner+w=401wt.eu-S1422704AbXDRJRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422704AbXDRJRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 05:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422696AbXDRJRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 05:17:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47785 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422694AbXDRJRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 05:17:33 -0400
Date: Wed, 18 Apr 2007 11:17:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Pfister <christophpfister@gmail.com>
Cc: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org, Michael Lothian <mike@fireburn.co.uk>,
       Christophe Thommeret <hftom@free.fr>, Jurgen Kofler <kaffeine@gmx.net>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: Kaffeine problem with CFS
Message-ID: <20070418091714.GA23446@elte.hu>
References: <200704141809.58737.caglar@pardus.org.tr> <20070414160939.GB3099@elte.hu> <200704141959.50076.caglar@pardus.org.tr> <20070415161348.GA30625@elte.hu> <20070415162508.GA4526@elte.hu> <19a3b7a80704150955x4e1d809eh929b0f931f842a06@mail.gmail.com> <20070418082744.GA14009@elte.hu> <19a3b7a80704180157g604f4cecna51a49bd1f4c7d38@mail.gmail.com> <20070418090117.GA20764@elte.hu> <19a3b7a80704180213i1ac84b2ch2b35220b62e3b67a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19a3b7a80704180213i1ac84b2ch2b35220b62e3b67a@mail.gmail.com>
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

> >are the updated backtraces in the followup mail i just sent more 
> >useful? (I still have that stuck session running so i can whatever 
> >debugging you'd like to see done.)
> 
> QWidget::setUpdatesEnabled() is (wrongly) present in every thread 
> except the main. So I'm afraid there's nothing which can be done :-/ 
> Btw the main thread is waiting for the first frame being displayed 
> after the seek.

i didnt have all the debuginfo packages installed. I installed some (but 
not all yet), here's an updated backtrace:

(gdb) bt
#0  0xffffe410 in __kernel_vsyscall ()
#1  0x4a2539e1 in __lll_mutex_unlock_wake () from /lib/libpthread.so.0
#2  0x4a2506f9 in _L_mutex_unlock_99 () from /lib/libpthread.so.0
#3  0x4a250370 in __pthread_mutex_unlock_usercnt () from /lib/libpthread.so.0
#4  0x4a2506f0 in pthread_mutex_unlock () from /lib/libpthread.so.0
#5  0xb79fce5a in QWidget::setUpdatesEnabled () from /usr/lib/libxine.so.1
#6  0xb7a4b90b in dvd_plugin_free_buffer (buf=0xb0745470) at input_dvd.c:570
#7  0xb7a030a2 in QWidget::setUpdatesEnabled () from /usr/lib/libxine.so.1
#8  0x4a24d2db in start_thread () from /lib/libpthread.so.0
#9  0x4a05820e in clone () from /lib/libc.so.6

at least the dvd_plugin_free_buffer() call has been resolved now. (I'll 
hunt for the other debuginfo packages too.)

which thread would be the most interesting to you - 9324?

	Ingo
