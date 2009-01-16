Return-Path: <linux-kernel-owner+w=401wt.eu-S933331AbZAPNJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331AbZAPNJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 08:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760486AbZAPNJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:09:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33783 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758058AbZAPNJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:09:44 -0500
Date: Fri, 16 Jan 2009 14:09:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: avoid early crash in disable_local_APIC()
Message-ID: <20090116130936.GL5421@elte.hu>
References: <496DE893.76E4.0078.0@novell.com> <20090115110528.GE16253@elte.hu> <20090115224710.GA1327@elte.hu> <20090115224751.GA1625@elte.hu> <497051E7.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497051E7.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3752]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> >>> Ingo Molnar <mingo@elte.hu> 15.01.09 23:47 >>>
> >
> >* Ingo Molnar <mingo@elte.hu> wrote:
> >
> >> hm, this gives a build failure on latest -tip:
> >> 
> >> arch/x86/kernel/apic.c: In function 'setup_local_APIC':
> >> arch/x86/kernel/apic.c:1135: error: implicit declaration of function 'disable_ioapic_setup'
> 
> Is this with a config that has X86_IO_APIC off (i.e. one the practical 
> use of which I never understood, and hence easily forget to consider)? 
> Otherwise I can't see how that could happen.

yeah. Such build failures are reminders to define such functions in a 
.config-invariant way: i.e. an extern prototype plus an inline NOP-wrapper 
for the !IO_APIC case.

	Ingo
