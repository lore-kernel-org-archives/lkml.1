Return-Path: <linux-kernel-owner+w=401wt.eu-S1758521AbYDOISx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbYDOISx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 04:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759385AbYDOIST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 04:18:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45020 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756525AbYDOISR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 04:18:17 -0400
Date: Tue, 15 Apr 2008 10:17:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jeff Garzik <jeff@garzik.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: regression caused by: genirq: do not leave interupts enabled
	on free_irq
Message-ID: <20080415081744.GB19452@elte.hu>
References: <86802c440804102313k4546cd73s7bffb30a14239472@mail.gmail.com> <alpine.LFD.1.10.0804110841370.3261@apollo.tec.linutronix.de> <86802c440804110014j44b32d16ubfaa0f327c3a384f@mail.gmail.com> <86802c440804110017y62938d90x7e3e32df25a60d1@mail.gmail.com> <1207899030.15605.1.camel@x61.ebiederm.org> <86802c440804111122x5c106779g60f1c04ae21fed94@mail.gmail.com> <86802c440804111248je6dfa99va8eec42531f4b689@mail.gmail.com> <20080415004400.bb941191.akpm@linux-foundation.org> <86802c440804150103s59f6fe16ncf08a3154c03d2bb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440804150103s59f6fe16ncf08a3154c03d2bb@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> >  Do we think it's a bug in the RHEL 5.1 kernel?  Even so, that's a 
> >  problem for the 2.6.25 kernel.
> 
> it is RHEL 5.1 kernel problem, it has code for maskbit with msi there, 
> but that does work...

addendum - basically the argument is: we should kexec conservatively - 
i.e. we should leave as few assumptions and hw changes around as 
possible. So restoring the MSI state is fair enough as a robustness fix, 
even though only kexec to older kernels is affected.

clearly 2.6.26 material, not 2.6.25.

	Ingo
