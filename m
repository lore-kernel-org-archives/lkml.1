Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbZCLKLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbZCLKLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZCLKK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:10:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40482 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbZCLKK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:10:58 -0400
Date: Thu, 12 Mar 2009 11:10:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/6] futex: add double_unlock_hb()
Message-ID: <20090312101028.GA7157@elte.hu>
References: <20090312075349.9856.83687.stgit@Aeon> <20090312075552.9856.48021.stgit@Aeon> <1236852455.5090.105.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236852455.5090.105.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2009-03-12 at 00:55 -0700, Darren Hart wrote:
> > The futex code uses double_lock_hb() which locks the hb->lock's in pointer
> > value order.  There is no parallel unlock routine, and the code unlocks them
> > in name order, ignoring pointer value.  This opens up a window for an ABBA
> > deadlock.  This patch adds double_unlock_hb() to remove the window as well
> > as refactor the duplicated code segments.
> 
> While I don't mind the patch per-se, I'm hard pressed to see 
> any deadlock potential in the unordered unlock.
> 
> All sites (at least those in the patch) always release both 
> locks without taking another in between, therefore one would 
> think there's no deadlock possible.

yeah.

The patch is still nice (as you mention), it factors out the 
unlock sequence. I'll change the commit message accordingy.

	Ingo
