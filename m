Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYE3LA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYE3LA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 07:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYE3LAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 07:00:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46365 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbYE3LAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 07:00:15 -0400
Date: Fri, 30 May 2008 12:59:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, pavel@suse.cz
Subject: Re: [patch 2.6.26-rc4-git] PM: boot time suspend selftest
Message-ID: <20080530105948.GA12236@elte.hu>
References: <200805291333.42057.david-b@pacbell.net> <20080529162257.03426e48.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529162257.03426e48.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > +	WARN_ON_ONCE(msec > (TEST_SUSPEND_SECONDS * 1000));
> 
> We should have a comment here explaining what we're warning about.  
> Why would it take more that five seconds?

i asked for that because we had regressions in the past in the form of 
"it takes one minute to resume".

> Better might be to just add a nice printk - I don't think we need the 
> stack trace here.

please keep the warn-on so that it can be detected automatically. Adding 
yet another printk just complicates the automated answer to the "is this 
kernel that just booted up fine or not" question.

In fact i'd love to have the analogue to /proc/lockdep_debug's 
"debug_locks: 0" output. I.e. the kernel should know it via one central 
flag whether any bugs that need human review have been detected so far. 

Say /proc/sys/kernel/kernel_is_buggy. This value could even be 
multi-level: a WARN_ON() increases it by +1, a kernel crash increases it 
by +1000. ( That way i could run overnight tests that will only stop on 
a kernel_is_buggy >= 1000 condition, while it could ignore simpler 
WARN_ON()s. )

	Ingo
