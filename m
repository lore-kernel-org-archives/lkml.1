Return-Path: <linux-kernel-owner+w=401wt.eu-S932500AbXBWSML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500AbXBWSML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 13:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932501AbXBWSMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 13:12:10 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54971 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500AbXBWSMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 13:12:08 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Jeff V. Merkey" <jmerkey@wolfmountaingroup.com>
Cc: linux-kernel@vger.kernel.org, Zwane Mwaikambo <zwane@infradead.org>,
       Ashok Raj <ashok.raj@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Conclusions from my investigation about ioapic programming
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<200702021848.55921.luigi.genoni@pirelli.com>
	<m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
	<200702021905.39922.luigi.genoni@pirelli.com>
	<m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
	<m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
	<20070206073616.GA15016@elte.hu>
	<m1odo7q6cq.fsf@ebiederm.dsl.xmission.com>
	<20070206222523.GA11602@elte.hu>
	<m1irecamzh.fsf@ebiederm.dsl.xmission.com>
	<m1wt2s8ksa.fsf@ebiederm.dsl.xmission.com>
	<m1veib6dgi.fsf@ebiederm.dsl.xmission.com>
	<m1hctt1sfp.fsf_-_@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702102146380.8245@montezuma.fsmlabs.com>
	<m13b5d0zdp.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702110753390.8245@montezuma.fsmlabs.com>
	<m17iuoz74f.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702111416220.24829@montezuma.fsmlabs.com>
	<m1r6swx9l2.fsf@ebiederm.dsl.xmission.com>
	<m1irdtw3jb.fsf_-_@ebiederm.dsl.xmission.com>
	<45DF1ADD.9000600@wolfmountaingroup.com>
Date: Fri, 23 Feb 2007 11:10:39 -0700
In-Reply-To: <45DF1ADD.9000600@wolfmountaingroup.com> (Jeff V. Merkey's
	message of "Fri, 23 Feb 2007 09:48:29 -0700")
Message-ID: <m13b4wu4m8.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Jeff V. Merkey" <jmerkey@wolfmountaingroup.com> writes:

> In my older days of programmin 82489DX chipsets (which the AMD APIC versions
> resemble
> the 82489DX more closely than intel's newer incarnations), you had to EOI the
> apic early if you
> wanted to migrate interrupt assignments. I had to do the following steps to move
> an IRQ:
>
> 1. Mask the LOCAL APIC
> 2, EOI the interrupt
> 3. Leave the interrupt entry masked until the ISR completed.
> 4. Reprogram the interrupt.
> 5. Unmask as the ISR exits
>
> In other words, EOI early in all cases to clear the local and IOAPIC state.

Thanks.

That is the essence of what I am doing with level triggered interrupts.
- Mask
- ACK
- Reprogram
- Unmask.
Which essentially comes from the definition of how level triggered
interrupts operate in the ioapics.

Having to run the EOI before the ISR routine runs or having to keep
the ISR masked while the ISR runs isn't something that I have encountered.
And if it was a problem there is enough volume I expect someone would have gotten
a bug report about it by now.

Eric
