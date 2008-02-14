Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbYBNRB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbYBNRB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 12:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbYBNRBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 12:01:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53915 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbYBNRBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 12:01:21 -0500
Date: Thu, 14 Feb 2008 18:00:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Sam Ravnborg <sam@ravnborg.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86.git#mm] stack protector fixes, vmsplice exploit
Message-ID: <20080214170058.GA2043@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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


update: latest x86.git#mm has a pretty much working stack-protector 
feature - you can pick it up for testing via:

   http://people.redhat.com/mingo/x86.git/README

as pageexec@freemail.hu has indicated it already in his analysis and 
patch, there were multiple bugs hitting us here. The amount and scope of 
these problems show structural problems in how security in this area was 
approached. So with these changes we try to go deeper than just 
minimally fixing the feature. We've got 15 changes so far in and around 
this area:

  x86: fix execve with -fstack-protect
  x86: exclude vsyscall files from stackprotect
  x86: fix stackprotect Makefile rule
  x86: fix stackprotector canary updates during context switches
  panic: print more informative messages on stackprotect failure
  panic: print out stacktrace if DEBUG_BUGVERBOSE
  x86: enable stack-protector by default
  x86: setup stack canary for the idle threads
  x86: fix canary of the boot CPU's idle task
  stackprotector: include files
  stackprotector: add boot_init_stack_canary()
  x86: fix the stackprotector canary of the boot CPU
  x86: stackprotector: mix TSC to the boot canary
  x86: test the presence of the stackprotector
  x86: streamline stackprotector

but we've not completed this work yet. We'll push the independent bits 
to Linus ASAP.

	Ingo
