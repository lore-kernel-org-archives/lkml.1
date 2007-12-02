Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbXLBTAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbXLBTAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 14:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbXLBTAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 14:00:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49150 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096AbXLBTAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 14:00:15 -0500
Date: Sun, 2 Dec 2007 19:59:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071202185945.GA25990@elte.hu>
References: <20071201092037.GA32544@elte.hu> <p737ijwylet.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p737ijwylet.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andi Kleen <andi@firstfloor.org> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > this patch extends the soft-lockup detector to automatically
> > detect hung TASK_UNINTERRUPTIBLE tasks. Such hung tasks are
> > printed the following way:
> 
> That will likely trigger anytime a hard nfs/cifs mount loses its 
> server for 120s. To make this work you would need a new 
> TASK_UNINTERRUPTIBLE_EXTERNAL_EVENT or similar and mark all the places 
> which depend on those.

TASK_KILLABLE should be the right solution i think.

> I've also seen kernel modules that use semaphores like wait queues 
> While that gives a little funny results (high load average) it worked 
> so far, until this patch.

it still works with this patch of course. With a funny results like high 
load average _AND_ a clear debug message that tells us (and the user) 
where that high load average comes from.

	Ingo
