Return-Path: <linux-kernel-owner+w=401wt.eu-S1760339AbXFVS17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760339AbXFVS17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760416AbXFVS04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:26:56 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:39271 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760701AbXFVS0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:26:55 -0400
Message-Id: <20070622182051.859570787@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 22 Jun 2007 14:20:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru
Subject: [RFC PATCH 0/5 v2] Convert all tasklets to workqueues V2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-- 

This is version 2 of the tasklet to workqueue conversion.

Changes from version 1.

- removed config option and simply replace the old implementation
  with the work queue one (recommended by Ingo Molnar).

- replaced clear_bit with test_and_clear_bit to avoid the race of
  executing the tasklet function twice. (thanks to Oleg Nesterov
  for pointing that out).

- Removed most of the pr_debug prints. (Kept one)
  (recommended by Ingo Molnar)

- Removed call to softirq_init.

- Added Author credit to Dipankar Sarma for the RCU tasklet to
  softirq conversion.

- Tested on my Powerbook to add another arch to the mix :-)
  Funny that booting with this change was the first time that
  the bcm43xx didn't get stuck for several seconds on bootup.
  It's also one of the few drivers that use tasklet_disable_nosync.
  So either this shows that the change fixed something, or that
  it broke something (or was just a fluke).


-- Steve

