Return-Path: <linux-kernel-owner+w=401wt.eu-S1763804AbXJQHXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763804AbXJQHXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 03:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbXJQHX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 03:23:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38583 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270AbXJQHX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 03:23:28 -0400
Date: Wed, 17 Oct 2007 09:23:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ken Chen <kenchen@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] sched: schedstat needs a diet
Message-ID: <20071017072323.GB18044@elte.hu>
References: <b040c32a0710161337l24d61d45h61be0ded72b54a9f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0710161337l24d61d45h61be0ded72b54a9f@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ken Chen <kenchen@google.com> wrote:

> schedstat is useful in investigating CPU scheduler behavior.  Ideally, 
> I think it is beneficial to have it on all the time.  However, the 
> cost of turning it on in production system is quite high, largely due 
> to number of events it collects and also due to its large memory 
> footprint.
> 
> Most of the fields probably don't need to be full 64-bit on 64-bit 
> arch.  Rolling over 4 billion events will most like take a long time 
> and user space tool can be made to accommodate that.  I'm proposing 
> kernel to cut back most of variable width on 64-bit system.  (note, 
> the following patch doesn't affect 32-bit system).

thanks, applied.

note that current -git has a whole bunch of new schedstats fields in 
/proc/<PID>/sched which can be used to track the exact balancing 
behavior of tasks. It can be cleared via echoing 0 to the file - so 
overflow is not an issue. Most of those new fields should probably be 
unsigned int too. (they are u64 right now.)

	Ingo
