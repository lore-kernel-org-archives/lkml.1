Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbYHKNHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbYHKNHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 09:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbYHKNHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 09:07:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44774 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbYHKNHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 09:07:07 -0400
Date: Mon, 11 Aug 2008 15:06:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: apic interrupts - move assignments to
	irqinit_32.c
Message-ID: <20080811130647.GA23289@elte.hu>
References: <20080808195006.GA7014@lenovo> <20080811125729.GB2842@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080811125729.GB2842@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > 64bit mode APIC interrupt handlers are set within irqinit_64.c.
> > Lets do tha same for 32bit mode which would help in furter code merging.
> > 
> > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> > ---
> > 
> > I found it useful for APIC code merging process (in which
> > i'm now). So please review and test if possible.
> > Any comments are quite welcome!
> > 
> > Ugh... almost forget - the patch is over -tip tree
> > commit 62c67a7cc7dbd9c8d92d49cfd7d5ca1d8f354616
> 
> applied to tip/x86/core for more testing, thanks Cyrill.

doesnt build:

 arch/x86/mach-default/setup.c:44: warning: ‘irq2’ defined but not used
 arch/x86/kernel/irqinit_32.c: In function ‘native_init_IRQ’:
 arch/x86/kernel/irqinit_32.c:139: error: ‘irq2’ undeclared (first use in this function)
 arch/x86/kernel/irqinit_32.c:139: error: (Each undeclared identifier is reported only once
 arch/x86/kernel/irqinit_32.c:139: error: for each function it appears in.)

with:

 http://redhat.com/~mingo/misc/config-Mon_Aug_11_14_48_29_CEST_2008.bad

	Ingo
