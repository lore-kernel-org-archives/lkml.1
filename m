Return-Path: <linux-kernel-owner+w=401wt.eu-S1752717AbZLMCsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbZLMCsl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 21:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZLMCsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 21:48:40 -0500
Received: from fallback.mail.elte.hu ([157.181.151.13]:54054 "HELO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751425AbZLMCsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 21:48:40 -0500
Date: Sat, 12 Dec 2009 14:24:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] Fix 2.6.33 x86 regression to kgdb hw breakpoints - due to
 perf API changes
Message-ID: <20091212132428.GB22389@elte.hu>
References: <4B227F2C.7050403@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B227F2C.7050403@windriver.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Wessel <jason.wessel@windriver.com> wrote:

> I'll lead with a question.  Are the people making the Perf API changes 
> booting allyesconfig kernels?
>
> The regression tests built into the kernel for kgdb fail as a result 
> of the perf API changes and can result in a hard kernel hang.
>
> My hope would have been that someone would have reported the problem, 
> created a patch to disable the test that hangs the kernel, or to fix 
> kgdb such that it works with the API changes.  Likewise, if there are 
> tests I should run to regression test the changes to the perf API, I 
> would like to know since we all want to make use of the same hw 
> resource.
> 
> A patch has been included in this mail which allows kgdb to pass the 
> internal regression tests for hw breakpoints.  I would like to get 
> some comments or start a discussion as to how to solve this problem in 
> the 2.6.33 cycle, as it is a regression in functionality.

Hm, the kgdb hw-breakpoint changes freshly put into v2.6.33 look pretty 
broken: they access the raw hw registers and ignore the higher level 
abstraction. Your patch still uses way too low level primitives. Please 
use the highlevel abstraction: register/unregister_wide_hw_breakpoint() 
should do the trick. (if there's any changes/extensions needed to it 
then please let us know about it.)

If that's too much for v2.6.33 then i guess we need to revert or disable 
the kgdb hw-breakpoint changes for now.

Thanks,

	Ingo
