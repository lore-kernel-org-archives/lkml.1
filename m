Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbXLBU0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbXLBU0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 15:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbXLBU0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 15:26:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58249 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbXLBU0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 15:26:24 -0500
Date: Sun, 2 Dec 2007 21:26:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071202202602.GA16480@elte.hu>
References: <20071201092037.GA32544@elte.hu> <p737ijwylet.fsf@bingen.suse.de> <20071202185945.GA25990@elte.hu> <20071202114152.3bf4332d@laptopd505.fenrus.org> <20071202200953.GA23994@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071202200953.GA23994@one.firstfloor.org>
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

> > .. and it's even a tool to show where we missed making something 
> > TASK_KILLABLE... anything that triggers from NFS and the like really 
> > ought to be TASK_KILLABLE after all. This patch will point any 
> > omissions out quite nicely without having to do any kind of 
> > destructive testing.
> 
> It would be better to just audit the source for those. [...]

that was wishful thinking 10 years ago already, when Linux was 10 times 
smaller.

> [...] Outlawing something which was previously legal without auditing 
> the source is bad.

to the contrary, being 120+ seconds uninterruptible without a very good 
reason is certainly something that was unreasonable (and harmful) for a 
long time already - we just never had the mechanism to warn about this 
intelligently without crashing the system.

Out of direct experience, 95% of the "too long delay" cases are plain 
old bugs. The rest we can (and must!) convert to TASK_KILLABLE or could 
annotate if it _really_ needs to be TASK_UNINTERRUPTIBLE.

> Anyways, i suspect it would just lead to more people disabling 
> softlockup. I remember during some older stress testing it also tended 
> to explode regularly, so e.g. SUSE kernel rpms have it disabled. That 
> patch would probably make it worse.

There are no softlockup false positive bugs open at the moment. If you 
know about any, then please do not hesitate and report them, i'll be 
eager to fix them. The softlockup detector is turned on by default in 
Fedora (alongside lockdep in rawhide), and it helped us find countless 
number of bugs. You are the first person to suggest that it's somehow 
harmful.

	Ingo
