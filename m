Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbYCHTDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbYCHTDw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 14:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbYCHTDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 14:03:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbYCHTDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 14:03:44 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH] signals: print_fatal_signal: fix the signr "calculation"
In-Reply-To: Oleg Nesterov's message of  Saturday, 8 March 2008 20:24:53 +0300 <20080308172453.GA28323@tv-sign.ru>
References: <20080308172453.GA28323@tv-sign.ru>
Emacs: because you deserve a brk today.
Message-Id: <20080308190311.779B326F990@magilla.localdomain>
Date: Sat,  8 Mar 2008 11:03:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intent of your change is to get the printk for each thread, right?
I don't really see the point.  The thread that actually had the fault will
dequeue a non-SIGKILL signal and report its status.  We only need one
thread per signal to the print-out.

Hmm.  I see that non-coredump signals that hit the optimized fatal case in
__group_complete_signal will cause every thread to have a pending SIGKILL.
So that will be seen first and prevent the print-out.  So that's what you
intend to change?

I'm not sure print-fatal-signals was really ever intended for non-coredump
signals.  It doesn't seem like it would be all that useful.  It's probably
even undesireable for every normal C-c killing something to cause a printk.


Thanks,
Roland
