Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbYLZJtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbYLZJtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 04:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbYLZJtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 04:49:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54376 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbYLZJtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 04:49:23 -0500
Date: Fri, 26 Dec 2008 10:48:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tony Battersby <tonyb@cybernetics.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>, arjan@linux.intel.com,
       venkatesh.pallipadi@intel.com, jeremy@goop.org
Subject: Re: DEBUG_PAGEALLOC + order-10 alloc/free_pages = lockup
Message-ID: <20081226094857.GP27747@elte.hu>
References: <49513E33.5050001@cybernetics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49513E33.5050001@cybernetics.com>
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


* Tony Battersby <tonyb@cybernetics.com> wrote:

> An order-10 alloc_pages followed by free_pages with DEBUG_PAGEALLOC
> causes a lockup during subsequent memory allocations.  Order-9 and lower
> do not trigger the problem.  This problem was introduced in 2.6.25-rc1
> and fixed in 2.6.28-rc1.  Even though the bug is now fixed, I am
> reporting it because:
> 
> 1) I am not sure that anyone ever realized that the bug existed.

Correct.

> 2) I want to make sure that the bug is really fixed and not just hidden
>    from view.

i think it got hidden. Apparently splitting up a large kernel linear page 
in IRQ context has a bug. I dont see it immediately what it could be - 
Thomas, Suresh, do you have any ideas?

> 3) To see if anyone thinks that the fix should be included in
>    2.6.27 -stable.

if 0b8fdcbcd287a1fbe66817491e6149841ae25705 applies cleanly to .27 -stable 
then i'd agree it should be added. If there's lots of dependencies then 
maybe not.

	Ingo
