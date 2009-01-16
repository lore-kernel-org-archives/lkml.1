Return-Path: <linux-kernel-owner+w=401wt.eu-S933152AbZAPN7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbZAPN7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 08:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZAPN7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:59:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37840 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797AbZAPN7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:59:07 -0500
Date: Fri, 16 Jan 2009 14:58:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: fully honor "nolapic" (take 2)
Message-ID: <20090116135851.GA7153@elte.hu>
References: <4970818A.76E4.0078.0@novell.com> <20090116124548.GC5421@elte.hu> <49709C94.76E4.0078.0@novell.com> <20090116134243.GC14874@elte.hu> <49709EF7.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49709EF7.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> >>> Ingo Molnar <mingo@elte.hu> 16.01.09 14:42 >>>
> >
> >* Jan Beulich <jbeulich@novell.com> wrote:
> >
> >> >>> Ingo Molnar <mingo@elte.hu> 16.01.09 13:45 >>>
> >> >
> >> >* Jan Beulich <jbeulich@novell.com> wrote:
> >> >
> >> >> +	if (disable_apic) {
> >> >> +#ifdef CONFIG_X86_IO_APIC
> >> >> +		disable_ioapic_setup();
> >> >> +#endif
> >> >> +		return;
> >> >> +	}
> >> >
> >> > Shouldnt that #ifdef be avoided by always providing the function - 
> >> > just it is a NOP inline in the !CONFIG_X86_IO_APIC case?
> >> 
> >> That would make for a much bigger patch, since the io_apic.h doesn't 
> >> (and imo shouldn't) be included without that config option.
> >
> >But we are using io-apic functionality in that file, so we should include 
> >io_apic.h, right?
> 
> I don't generally (i.e. when !X86_IO_APIC) think so - anything accessing
> stuff from io_apic.c is guarded by a similar #ifdef.

and wrongly so - it proliferates ugly #ifdefs and sets us up for build 
failures like that. Developers cannot be expected to keep every build 
option in mind - we should provide an as homogenic and kconfig-invariant 
environment as possible.

	Ingo
