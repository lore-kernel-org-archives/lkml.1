Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbZBIBiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbZBIBiZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 20:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbZBIBiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 20:38:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbZBIBiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 20:38:16 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Marchand <jmarchan@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ptrace_untrace: use wake_up_process() instead of bogus
	signal_wake_up()
In-Reply-To: Oleg Nesterov's message of  Sunday, 8 February 2009 19:47:27 +0100 <20090208184727.GA27081@redhat.com>
References: <20090208184727.GA27081@redhat.com>
X-Windows: garbage at your fingertips.
Message-Id: <20090209013804.C99B3FC330@magilla.sf.frob.com>
Date: Sun,  8 Feb 2009 17:38:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Both ptrace_stop() and do_signal_stop() pathes always take ->siglock and
> do recalc_sigpending() after wakeup.

Yes, that's true.  But so what?  Why is this a reason to introduce yet
another unconditional (i.e. wrong) wake_up_process?  signal_wake_up does
the job fine, i.e. it calls wake_up_state the right way.  For exactly the
reasons you cited, setting TIF_SIGPENDING is both superfluous and
harmless--its effects will happen upon resume whether it was set or not.
So what's wrong with signal_wake_up?


Thanks,
Roland
