Return-Path: <linux-kernel-owner+w=401wt.eu-S1759025AbXH1KSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025AbXH1KSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 06:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbXH1KSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 06:18:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53242 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbXH1KSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 06:18:14 -0400
Date: Tue, 28 Aug 2007 12:18:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fix bogus hotplug cpu warning
Message-ID: <20070828101801.GA27153@elte.hu>
References: <20070828090709.GA24578@elte.hu> <Pine.LNX.4.64.0708281022440.17987@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708281022440.17987@blonde.wat.veritas.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.1.7-deb
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0999]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Hugh Dickins <hugh@veritas.com> wrote:

> > so if this check triggered for the cpu-offline code it's because 
> > keventd was _not_ per-cpu (perhaps because the cpu offline code 
> > broke its affinity?). So your patch hides a real bug.
> 
> No, keventd is properly per-cpu, but the task which is calling 
> current_is_keventd() is a normal user task, so smp_processor_id() did 
> warn about it.  It wouldn't make much sense to have a function 
> current_is_keventd() if you could only call it from a keventd, would 
> it ;-?  Take a look at it (kernel/workqueue.c), I believe what it does 
> is unusual (hence that comment about being "preempt-safe") but valid.

ok, you are right indeed.

	Ingo
