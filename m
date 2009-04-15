Return-Path: <linux-kernel-owner+w=401wt.eu-S1758656AbZDOKCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbZDOKCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 06:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZDOKCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 06:02:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36105 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbZDOKCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:02:41 -0400
Date: Wed, 15 Apr 2009 12:01:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yinghai@kernel.org>, rusty@rustcorp.com.au, tglx@linutronix.de,
       hpa@zytor.com, ebiederm@xmission.com, garyhade@us.ibm.com,
       lcm@us.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] irq: correct CPUMASKS_OFFSTACK typo -v2
Message-ID: <20090415100105.GC6669@elte.hu>
References: <20090402013108.GB7103@us.ibm.com> <20090404003520.GA8847@us.ibm.com> <20090410215515.GC7242@us.ibm.com> <20090411065510.GA11799@elte.hu> <20090413220321.GA11098@us.ibm.com> <49E4146C.7060507@kernel.org> <49E4162A.3060701@kernel.org> <20090414131711.GA4403@elte.hu> <49E4F513.1060709@kernel.org> <20090414135958.36c79836.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414135958.36c79836.akpm@linux-foundation.org>
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

> On Tue, 14 Apr 2009 13:41:55 -0700
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > irq
> 
> Speaking of which, could someone please take a look at
> http://www.gossamer-threads.com/lists/linux/kernel/1060580?do=post_view_threaded#1060580
> ?
[...]

> But try_one_irq() is running tifm_7xx1_isr() with local interrupts 
> enabled, which upsets lockdep.

It doesnt just upset lockdep, it could also cause real lockups. 
Lockdep is just the canary, the lockup is the methane explosion.

> But I suspect that the code as it stands is non-buggy. Unless the 
> interrupt can magically come back to life. In which case any 
> change we make is purely a make-lockdep-shut-up thing.

Hm, i'd suggest we go for the methane leak instead of squashing the 
canary. Which in this case would be try_one_irq() ignoring 
IRQF_DISABLED or so? Affecting (much) more ISRs than just 
tifm_7xx1_isr()?

Thomas?

	Ingo
