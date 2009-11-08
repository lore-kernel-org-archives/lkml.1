Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbZKHNQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbZKHNQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 08:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbZKHNQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 08:16:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32954 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbZKHNQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 08:16:58 -0500
Date: Sun, 8 Nov 2009 14:16:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86, therm: Only read the initial value of thermal LVT
 entry on BSP
Message-ID: <20091108131655.GA12837@elte.hu>
References: <20091107001736.GA30790@ywang-moblin2.bj.intel.com>
 <1257562565.4083.485.camel@sbs-t61.sc.intel.com>
 <20091108102520.GC7233@elte.hu>
 <20091108123812.GA877@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108123812.GA877@ywang-moblin2.bj.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Yong Wang <yong.y.wang@linux.intel.com> wrote:

> On Sun, Nov 08, 2009 at 11:25:21AM +0100, Ingo Molnar wrote:
> > 
> > i dont disagree with the fix, but could we please do it a bit cleaner, 
> > and initialize a proper file-scope lvtthrm_init value from a different 
> > boot-CPU-only function? (not intel_init_thermal)
> > 
> 
> Thanks for your comments. Just want to make sure I understand correctly.
> By 'file-scope', do you want me to define lvtthrm_init as a static
> variable but not to define it in any function?

Correct - i'd suggest to put it next to other file-scope variables at 
the top of the .c file. Maybe make it __read_mostly as well.

> > that makes it cleaner, and also it will work if we dont boot on 
> > cpu==0. (should that ever occur)
> > 
> 
> May I know when will this happen?

It's not really expected - we factorize the CPU IDs (which are logical) 
so that the boot CPU is 0. But relying on cpu==0 is the boot cpu is not 
clean and the resulting code is harder to read.

	Ingo
