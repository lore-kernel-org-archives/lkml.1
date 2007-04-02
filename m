Return-Path: <linux-kernel-owner+w=401wt.eu-S933998AbXDBMgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933998AbXDBMgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 08:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934017AbXDBMgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 08:36:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57304 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933998AbXDBMgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 08:36:09 -0400
Date: Mon, 2 Apr 2007 14:34:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Stable Kernel Team <stable@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH] i386: fix file_read_actor() and pipe_read()  for original i386 systems
Message-ID: <20070402123449.GB7747@elte.hu>
References: <1174810024.10840.477.camel@localhost.localdomain> <Pine.LNX.4.64.0703251039170.6730@woody.linux-foundation.org> <1175516731.28263.129.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175516731.28263.129.camel@localhost.localdomain>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> The __copy_to_user_inatomic() calls in file_read_actor() and 
> pipe_read() are broken on original i386 machines, where WP-works-ok == 
> false, as __copy_to_user_inatomic() on such systems calls functions 
> which might sleep and/or contain cond_resched() calls inside of a 
> kmap_atomic() region.
> 
> The original check for WP-works-ok was in access_ok(), but got moved 
> during the 2.5 series to fix a race vs. swap.
> 
> Return the number of bytes to copy in the case where we are in an 
> atomic region, so the non atomic code pathes in file_read_actor() and 
> pipe_read() are taken.

neat trick! (v2.6.21 must-have me thinks.)

> This could be optimized to avoid the kmap_atomicby moving the check 
                                                  ^---- add space
> for WP-works-ok into fault_in_pages_writeable(), but this is more 
> intrusive and can be done later.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
