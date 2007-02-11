Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbXBKF7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbXBKF7I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 00:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbXBKF7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 00:59:08 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:62400 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbXBKF7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 00:59:06 -0500
Date: Sat, 10 Feb 2007 21:57:56 -0800 (PST)
From: Zwane Mwaikambo <zwane@infradead.org>
Subject: Re: What are the real ioapic rte programming constraints?
In-reply-to: <m1hctt1sfp.fsf_-_@ebiederm.dsl.xmission.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ashok Raj <ashok.raj@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       Coywolf Qi Hunt <coywolf@lovecn.org>
Message-id: <Pine.LNX.4.64.0702102146380.8245@montezuma.fsmlabs.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200701221116.13154.luigi.genoni@pirelli.com>
 <200702021848.55921.luigi.genoni@pirelli.com>
 <m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
 <200702021905.39922.luigi.genoni@pirelli.com>
 <m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
 <m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com> <20070206073616.GA15016@elte.hu>
 <m1odo7q6cq.fsf@ebiederm.dsl.xmission.com> <20070206222523.GA11602@elte.hu>
 <m1irecamzh.fsf@ebiederm.dsl.xmission.com>
 <m1wt2s8ksa.fsf@ebiederm.dsl.xmission.com>
 <m1veib6dgi.fsf@ebiederm.dsl.xmission.com>
 <m1hctt1sfp.fsf_-_@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Feb 2007, Eric W. Biederman wrote:

> There are not enough details in the justification to really understand
> the issue so I'm asking to see if someone has some more details.
> 
> The description makes the assertion that reprograming the ioapic
> when an  interrupt is pending is the only safe way to handle this.
> Since edge triggered interrupts cannot be pending at the ioapic I know
> it is not talking level triggered interrupts.
> 
> However it is not possible to fully reprogram a level triggered
> interrupt when the interrupt is pending as the ioapic will not
> receive the interrupt acknowledgement.  So it turns out I have
> broken this change for several kernel releases without people
> screaming at me about io_apic problems.
> 
> Currently I am disabling the irq on the ioapic before reprogramming
> it so I do not run into issues.  Does that solve the concerns that
> were patched around by only reprogramming interrupt redirection
> table entry in interrupt handlers?

Hi Eric,
	Could you outline in pseudocode where you're issuing the mask? If 
it's done whilst an irq is pending some (intel 7500 based) chipsets will 
not actually mask it but treat it as a 'legacy' IRQ and deliver it 
anyway. Using the masked whilst pending logic avoids all of that.

Cheers,
	Zwane
