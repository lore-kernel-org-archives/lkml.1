Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbZKHP7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbZKHP7c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbZKHP7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:59:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54576 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953AbZKHP7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:59:30 -0500
Date: Sun, 8 Nov 2009 16:59:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86, therm: Only read the initial value of thermal LVT
 entry on BSP
Message-ID: <20091108155925.GB15663@elte.hu>
References: <20091107001736.GA30790@ywang-moblin2.bj.intel.com>
 <1257562565.4083.485.camel@sbs-t61.sc.intel.com>
 <20091108102520.GC7233@elte.hu>
 <20091108123812.GA877@ywang-moblin2.bj.intel.com>
 <20091108131655.GA12837@elte.hu>
 <20091108131939.GA1005@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108131939.GA1005@ywang-moblin2.bj.intel.com>
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

> On Sun, Nov 08, 2009 at 02:16:55PM +0100, Ingo Molnar wrote:
> > 
> > * Yong Wang <yong.y.wang@linux.intel.com> wrote:
> > 
> > > On Sun, Nov 08, 2009 at 11:25:21AM +0100, Ingo Molnar wrote:
> > > > 
> > > > i dont disagree with the fix, but could we please do it a bit cleaner, 
> > > > and initialize a proper file-scope lvtthrm_init value from a different 
> > > > boot-CPU-only function? (not intel_init_thermal)
> > > > 
> > > 
> > > Thanks for your comments. Just want to make sure I understand correctly.
> > > By 'file-scope', do you want me to define lvtthrm_init as a static
> > > variable but not to define it in any function?
> > 
> > Correct - i'd suggest to put it next to other file-scope variables at 
> > the top of the .c file. Maybe make it __read_mostly as well.
> > 
> 
> OK, will do.
> 
> > > > that makes it cleaner, and also it will work if we dont boot on 
> > > > cpu==0. (should that ever occur)
> > > > 
> > > 
> > > May I know when will this happen?
> > 
> > It's not really expected - we factorize the CPU IDs (which are logical) 
> > so that the boot CPU is 0. But relying on cpu==0 is the boot cpu is not 
> > clean and the resulting code is harder to read.
> > 
> 
> There does not seem to be 'boot-CPU-only function' in that .c file. What
> about changing cpu==0 to cpu==boot_cpu_id? Does that help?

Then create one and call it - it's still cleaner that way.

	Ingo
