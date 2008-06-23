Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbYFWUy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbYFWUy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 16:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbYFWUyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 16:54:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56001 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640AbYFWUyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 16:54:49 -0400
Date: Mon, 23 Jun 2008 22:54:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
       Tim Mann <mann@vmware.com>, Zach Amsden <zach@vmware.com>,
       Sahil Rihan <srihan@vmware.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [RFC PATCH] x86:Use cpu_khz for loops_per_jiffy calculation
Message-ID: <20080623205433.GA16579@elte.hu>
References: <1212540069.19290.57.camel@promb-2n-dhcp368.eng.vmware.com> <20080603182014.79a38d03@infradead.org> <35f686220806032101h103152dat841818982aaa5052@mail.gmail.com> <20080604061637.6bab3f67@infradead.org> <1213924953.27983.52.camel@promb-2n-dhcp368.eng.vmware.com> <20080620113922.GG7439@elte.hu> <1213999593.31598.52.camel@promb-2n-dhcp368.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213999593.31598.52.camel@promb-2n-dhcp368.eng.vmware.com>
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


* Alok Kataria <akataria@vmware.com> wrote:

> Ok, I have changed the printks to KERN_INFO. 
> 
> On X86 platform we can use the value of tsc_khz computed during tsc 
> calibration to calculate the loops_per_jiffy value. Its very important 
> to keep the error in lpj values to minimum as any error in that may 
> result in kernel panic in check_timer. In virtualization environment, 
> On a highly overloaded host the guest delay calibration may sometimes 
> result in errors beyond the ~50% that timer_irq_works can handle, 
> resulting in the guest panicking.
> 
> Does some formating changes to lpj_setup code to now have a single 
> printk to print the bogomips value.
> 
> We do this only for the boot processor because the AP's can have 
> different base frequencies or the BIOS might boot a AP at a different 
> frequency.

applied to tip/x86/delay - thanks Alok.

could you check whether tip/master (which now includes your changes as 
well) works as expected in your test environment? I had to do a conflict 
resolution in tsc_32.c, i hope i got it right. You can pick it up via:

  http://people.redhat.com/mingo/tip.git/README

	Ingo
