Return-Path: <linux-kernel-owner+w=401wt.eu-S965892AbXCLOcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965892AbXCLOcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 10:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965891AbXCLOcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 10:32:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52846 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965881AbXCLOcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 10:32:08 -0400
Date: Mon, 12 Mar 2007 15:31:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, npiggin@suse.de, drepper@redhat.com,
       oleg@tv-sign.ru, sebastien.dugue@bull.net, linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch] change futex_wait() to hrtimers
Message-ID: <20070312143118.GA27993@elte.hu>
References: <200703110814.l2B8EaI1007615@shell0.pdx.osdl.net> <20070312011259.3834A1801C4@magilla.sf.frob.com> <20070312091006.GF21024@elte.hu> <p73bqiyaehp.fsf@bingen.suse.de> <1173697220.13341.84.camel@localhost.localdomain> <20070312105826.GB11864@one.firstfloor.org> <20070312141214.GG4372@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312141214.GG4372@thunk.org>
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


* Theodore Tso <tytso@mit.edu> wrote:

> What we probably need in the long-term, and not just for high 
> precision wakeups, is we need a way for waiters (either in the kernel 
> or in userspace) to specify a desired precision in their timers.  Is 
> it, "wake me up in a second, exactly", or "wake me up in a second, 
> plus or minus 10ms"?  (or 50ms?  or 100ms?).

such a facility exists already, see round_jiffies() and 
round_jiffies_relative(). There's some short blurb about it at:

  http://kernelnewbies.org/LinuxChanges#head-513ceda14f5d8cf5b8a7c81d7e3821543141ecb0

> This becomes especially important if we want the tickless code to 
> really shine as far as power management is concerned. [...]

yes. That's why we also implemented /proc/timer_stat, and this was 
measured and a few higher-frequency fuzzy waiters were converted to use 
round_jiffies(). Some other waiters were fixed in user-space. It's all 
dependent on actual measurements and circumstances.

	Ingo
