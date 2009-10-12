Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbZJLMdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbZJLMdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 08:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755774AbZJLMdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 08:33:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37318 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481AbZJLMdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 08:33:12 -0400
Date: Mon, 12 Oct 2009 14:32:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       David Woodhouse <dwmw2@infradead.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] panic.c: export panic_on_oops
Message-ID: <20091012123210.GB22766@elte.hu>
References: <1255241458-11665-1-git-send-email-dedekind1@gmail.com> <20091012111545.GB8857@elte.hu> <1255346731.9659.31.camel@localhost> <20091012113758.GB11035@elte.hu> <20091012140149.6789efab@marrow.netinsight.se> <20091012120951.GA16799@elte.hu> <20091012142714.56362465@marrow.netinsight.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012142714.56362465@marrow.netinsight.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Simon Kagstrom <simon.kagstrom@netinsight.net> wrote:

> > Yes, that looks like the better direction - but 'panic' is still the 
> > wrong trigger condition i think. We generally just crash and dont 
> > panic. Often we'll display a kernel warning and then hang. Etc.
> 
> But how can we detect that? The code above will write to the MTD 
> device either if an oops happens, or if we panic for some reason. If 
> the kernel just hangs (and is reset by the watchdog, if we have one), 
> how should we know when to write the log out?

You shouldnt need to care about that in a console driver - it's up to 
higher layers.

See my reply to David Woodhouse, i think we should add support for 
buffering in kernel/printk.c and that would both fix your problems, 
would simplify the driver (significantly!) and would expose the generic 
buffering capability to other console drivers as well.

	Ingo
