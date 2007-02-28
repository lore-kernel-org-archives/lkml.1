Return-Path: <linux-kernel-owner+w=401wt.eu-S932454AbXB1Vqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbXB1Vqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932456AbXB1Vqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:46:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55339 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932450AbXB1Vqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:46:42 -0500
Date: Wed, 28 Feb 2007 22:39:38 +0100
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
Subject: [patch 00/12] Syslets, Threadlets, generic AIO support, v5
Message-ID: <20070228213938.GA945@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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


this is the v5 release of the syslet/threadlet subsystem:

   http://redhat.com/~mingo/syslet-patches/

this release took 4 days to get out, but there were a couple of key 
changes that needed some time to settle down:

 - ported the code from v2.6.20 to current -git (v2.6.20-rc2 should be 
   fine as a base)

 - 64-bit support in terms of a x86_64 port. Jens has updated the FIO
   syslet code to work on 64-bit too. (kernel/async.c was pretty 64-bit
   clean already, it needed minimal changes for basic x86_64 support.)

 - 32-bit user-space on 64-bit kernel compat support. 32-bit syslet and
   threadlet binaries work fine on 64-bit kernels.

 - various cleanups and simplifications

the v4->v5 delta is:

 17 files changed, 327 insertions(+), 271 deletions(-)

amongst the plans for v6 are cleanups/simplifications to the syslet 
engine API, a number of suggestions have been made for that already.

the linecount increase in v5 is mostly due to the x86_64 port. The ABI 
had to change again - see the async-test userspace code for details.

the x86_64 patch is a bit monolithic at the moment, i'll split it up 
further in v6.

As always, comments, suggestions, reports are welcome!

	Ingo
