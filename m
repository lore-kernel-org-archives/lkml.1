Return-Path: <linux-kernel-owner+w=401wt.eu-S933416AbXBXHrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416AbXBXHrU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 02:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933415AbXBXHrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 02:47:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60086 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933410AbXBXHrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 02:47:19 -0500
Date: Sat, 24 Feb 2007 08:41:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patchset] Syslets/threadlets, generic AIO support, v4
Message-ID: <20070224074111.GA7599@elte.hu>
References: <20070221211355.GA7302@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221211355.GA7302@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


this is the v4 release of the syslet/threadlet subsystem:

    http://redhat.com/~mingo/syslet-patches/

v4 is a smaller update than v3 (so i wont send out the full queue to 
lkml - see the broken out queue in the patches-v4 directory at the URL 
above). Changes since v3:

- the threadlet API changed: the sys_async_threadlet() syscall now takes
  a 'completion event' pointer, and auto-completes it into the
  completion ring. I've updated the test-threadlet.c code to make use of
  it. So completion of threadlets and syslets is quite similar now -
  sharing even more infrastructure. (To get true pthread compatibility a
  sys_exit() driven CLEARTID completion method will be added too in the
  future).

- a small performance fix for syslet rescheduling. The syslet ABI has
  not changed.

- test-threadlet.c fixes a thread stack leak, and the other tests too
  have a number of small fixes and cleanups.

	Ingo
