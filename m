Return-Path: <linux-kernel-owner+w=401wt.eu-S936911AbYEUTeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936911AbYEUTeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759711AbYEUTeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:34:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936606AbYEUTeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:34:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signals: sigqueue_free: don't free sigqueue if it
 is queued
In-Reply-To: Linus Torvalds's message of  Wednesday, 21 May 2008 11:49:57 -0700 <alpine.LFD.1.10.0805211146350.3081@woody.linux-foundation.org>
References: <20080517151420.GA9496@tv-sign.ru>
	<20080521022046.1501F26FA1C@magilla.localdomain>
	<20080521115414.GA147@tv-sign.ru>
	<20080521184245.5BABF26FA24@magilla.localdomain>
	<alpine.LFD.1.10.0805211146350.3081@woody.linux-foundation.org>
X-Windows: the art of incompetence.
Message-Id: <20080521193348.64E8C26FA24@magilla.localdomain>
Date: Wed, 21 May 2008 12:33:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I thought we didn't even know which queue it was pending on if it was 
> already on a thread-local queue. So we could remove the entry, but I 
> always objected to the games with the pending bit.

Removing the entry without fixing the pending set is the bug we're trying
to fix.  That's what it does now, and it's wrong.

Oleg had a patch that marked the sigqueue entry with whether it was on the
shared queue or not.  The caller in timer_delete knows which thread it is
when it's on a thread queue, and whether it's on the shared queue.  So it
could be the caller's responsibility to know, i.e. its sigqueue_free call
matches its send_sigqueue call.


Thanks,
Roland
