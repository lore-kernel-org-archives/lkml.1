Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbYH0GqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbYH0GqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 02:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYH0GqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 02:46:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45365 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbYH0GqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 02:46:04 -0400
Date: Wed, 27 Aug 2008 08:45:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Locking API testsuite: Failures
Message-ID: <20080827064551.GE6255@elte.hu>
References: <804dabb00808261727o3ba1f3c0xc25d27ad0694aab4@mail.gmail.com> <1219802311.6462.26.camel@twins> <804dabb00808262332l4fb0a4d6i8adee9c809c65901@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804dabb00808262332l4fb0a4d6i8adee9c809c65901@mail.gmail.com>
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


* Peter Teoh <htmldeveloper@gmail.com> wrote:

> Several questions:

[...]
> 3.  My current .config (which gave rise to the failure errors) [...]

You should have read this bit of the self-test printout:

[    0.004000] 133 out of 218 testcases failed, as expected. |

there was no unexpected failure. A real test-case failure is displayed 
as: 'FAILED', and you'll get a verbose printout about the unexpected 
testcase failures.

> 1.   I noticed there is a Kconfig.debug with this entry:
> 
> config DEBUG_LOCKING_API_SELFTESTS
>         bool "Locking API boot-time self-tests"
>         depends on DEBUG_KERNEL
>         help
>           Say Y here if you want the kernel to run a short self-test during
>           bootup. The self-test checks whether common types of locking bugs
>           are detected by debugging mechanisms or not. (if you disable
>           lock debugging then those bugs wont be detected of course.)
>           The following locking APIs are covered: spinlocks, rwlocks,
>           mutexes and rwsems.
> 
> How do I use this Kconfig.debug, just overwriting the standard
> lib/Kconfig? [...]

no, that messes up the kernel. Kconfig.debug is a separate, unique 
kconfig file with debugging related options.

> 2.   So does it make sense to  compile with
> CONFIG_DEBUG_LOCKING_API_SELFTESTS without CONFIG_LOCKDEP?

yes. It shows the kinds of bugs we dont find when PROVE_LOCKING is 
disabled. It also shows that the test-cases are working as expected.

	Ingo
