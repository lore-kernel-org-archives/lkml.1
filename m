Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbXLBW0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbXLBW0H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 17:26:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbXLBWZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 17:25:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35631 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbXLBWZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 17:25:54 -0500
Date: Sun, 2 Dec 2007 23:25:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071202222532.GA31023@elte.hu>
References: <p737ijwylet.fsf@bingen.suse.de> <20071202185945.GA25990@elte.hu> <20071202114152.3bf4332d@laptopd505.fenrus.org> <20071202200953.GA23994@one.firstfloor.org> <20071202202602.GA16480@elte.hu> <20071202204725.GA25891@one.firstfloor.org> <20071202211027.GA32282@elte.hu> <20071202211925.GA26414@one.firstfloor.org> <20071202212407.GA11358@elte.hu> <p73y7ccwzlb.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73y7ccwzlb.fsf@bingen.suse.de>
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

> > do you realize that more than 120 seconds TASK_UNINTERRUPTIBLE _is_ 
> > something that most humans consider as "buggy" in the overwhelming 
> > majority of cases, regardless of the reason? Yes, there are and will 
> > be some exceptions, but not nearly as countless as you try to paint 
> > it. A quick test in the next -mm will give us a good idea about the 
> > ratio of false positives.
> 
> That would assume error paths get regularly exercised in -mm. 
> Doubtful.  Most likely we'll only hear about it after it's out in the 
> wild on some bigger release.

by that argument we could never include _anything_ in -mm because ... 
only some bigger release would excercise error paths?

Your argument makes no objective sense to me - my patch is a 
non-intrusive debugging facility that people clearly find useful and 
that would increase the quality of kernel bugreporting.

If, contrary to expectation, it decreases kernel bugreporting quality 
then we'll disable it quickly - just like we did it with other debugging 
facilities that were causing more trouble than good. (suck as the stack 
unwinder code)

In fact it can already by disabled easily, from user-space, without any 
kernel change, by doing:

   echo 0 > /proc/sys/kernel/hung_task_timeout_secs

and there you go, no warnings at all. Or you can add this to 
/etc/sysctl.conf to disable it permanently:

   kernel.hung_task_timeout_secs = 0

or you can disable it in the .config. So i dont see your problem. It's 
just like most other debug facilities. (in fact it's more flexible than 
most other debug facilities)

	Ingo
