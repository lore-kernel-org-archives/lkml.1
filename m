Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbYKTINs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbYKTINs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 03:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbYKTINk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 03:13:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58026 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbYKTINj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 03:13:39 -0500
Date: Thu, 20 Nov 2008 09:13:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Milton Miller <miltonm@bga.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/9] powerpc: port of dynamic ftrace
Message-ID: <20081120081307.GD21785@elte.hu>
References: <20081119212204.318400312@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081119212204.318400312@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> ----
>  arch/powerpc/Kconfig              |    2 +
>  arch/powerpc/include/asm/ftrace.h |   14 +-
>  arch/powerpc/include/asm/module.h |   16 ++-
>  arch/powerpc/kernel/ftrace.c      |  473 +++++++++++++++++++++++++++++++++---
>  arch/powerpc/kernel/idle.c        |    5 +
>  arch/powerpc/kernel/module_32.c   |   10 +
>  arch/powerpc/kernel/module_64.c   |   13 +
>  arch/x86/include/asm/ftrace.h     |    9 +-
>  arch/x86/kernel/ftrace.c          |  168 +++++++++++++-
>  include/linux/ftrace.h            |   51 ++++-
>  kernel/module.c                   |    2 +-
>  kernel/trace/ftrace.c             |  137 ++++++------
>  scripts/recordmcount.pl           |   20 ++-
>  13 files changed, 790 insertions(+), 130 deletions(-)

Hm, something like this shouldnt be pulled into the powerpc tree: it 
touches the core kernel, x86 code and ftrace code as well.

Please do the suggestion i outlined and which Paul agreed with: 
prepare a branch that touches _only_ powerpc files and gets these 
changes there, without actually breaking the build on powerpc. And 
please do not name the branch as "hack" - we dont want Paul to pull 
such a branch name - it will show up in the upstream git logs.

Those changes should only touch powerpc files. Do not try to shoe-horn 
already applied ftrace commits into a separate branch with different 
sha1's. Yes, ftrace wont be enable-able on powerpc when that is 
pulled, but it will only be for a brief period shortly before the 
merge window. (and it will all just work fine when integrated 
together)

Once this branch is done, and once Paul agrees that it looks OK-ish to 
him, we can put it into ftrace-next straight away [but still keep it 
in a separate topic tree in tip/tracing/powerpc - so it can all be 
reconsidered reversibly if it causes too much merge trouble]. Paul 
will then be able to pull it in a few weeks, in the runup to the 
v2.6.29 merge window.

The other option is to go the slow route of 2-3 kernel releases to 
pull this all off.

ok?

	Ingo
