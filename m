Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbYEUSnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbYEUSnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764004AbYEUSmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:42:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759384AbYEUSmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:42:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signals: sigqueue_free: don't free sigqueue if it is queued
In-Reply-To: Oleg Nesterov's message of  Wednesday, 21 May 2008 15:54:14 +0400 <20080521115414.GA147@tv-sign.ru>
References: <20080517151420.GA9496@tv-sign.ru>
	<20080521022046.1501F26FA1C@magilla.localdomain>
	<20080521115414.GA147@tv-sign.ru>
Emacs: freely redistributable; void where prohibited by law.
Message-Id: <20080521184245.5BABF26FA24@magilla.localdomain>
Date: Wed, 21 May 2008 11:42:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oh well. I just realized SIGQUEUE_CANCELLED breaks sys_sigpending() ?

Yes, it does.  Well, POSIX says after timer_delete "the disposition of
pending signals for the deleted timer is unspecified".  So perhaps one can
say that "unspecified" here can include sigpending() says it's pending but
it will disappear when delivered or accepted (means sigwait()).  But it's a
bit of a stretch.

Just properly removing the sigqueue entry and fixing the pending set is
looking pretty good.  Why was it we didn't do that?


Thanks,
Roland
