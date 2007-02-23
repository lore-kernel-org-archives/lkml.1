Return-Path: <linux-kernel-owner+w=401wt.eu-S1946018AbXBWRVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946018AbXBWRVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 12:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946019AbXBWRVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 12:21:36 -0500
Received: from rwcrmhc12.comcast.net ([204.127.192.82]:41803 "EHLO
	rwcrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946018AbXBWRVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 12:21:35 -0500
Message-ID: <45DF1ADD.9000600@wolfmountaingroup.com>
Date: Fri, 23 Feb 2007 09:48:29 -0700
From: "Jeff V. Merkey" <jmerkey@wolfmountaingroup.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20050921 Red Hat/1.7.12-1.4.1
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org, Zwane Mwaikambo <zwane@infradead.org>,
       Ashok Raj <ashok.raj@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Conclusions from my investigation about ioapic programming
References: <200701221116.13154.luigi.genoni@pirelli.com>	<200702021848.55921.luigi.genoni@pirelli.com>	<m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>	<200702021905.39922.luigi.genoni@pirelli.com>	<m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>	<m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>	<20070206073616.GA15016@elte.hu>	<m1odo7q6cq.fsf@ebiederm.dsl.xmission.com>	<20070206222523.GA11602@elte.hu>	<m1irecamzh.fsf@ebiederm.dsl.xmission.com>	<m1wt2s8ksa.fsf@ebiederm.dsl.xmission.com>	<m1veib6dgi.fsf@ebiederm.dsl.xmission.com>	<m1hctt1sfp.fsf_-_@ebiederm.dsl.xmission.com>	<Pine.LNX.4.64.0702102146380.8245@montezuma.fsmlabs.com>	<m13b5d0zdp.fsf@ebiederm.dsl.xmission.com>	<Pine.LNX.4.64.0702110753390.8245@montezuma.fsmlabs.com>	<m17iuoz74f.fsf@ebiederm.dsl.xmission.com>	<Pine.LNX.4.64.0702111416220.24829@montezuma.fsmlabs.com>	<m1r6swx9l2.fsf@ebiederm.dsl.xmission.com> <m1irdtw3jb.fsf_-_@ebiederm.dsl.xmission.com>
In-Reply-To: <m1irdtw3jb.fsf_-_@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:

>
>
>** Conclusions.
>
>*IRQs must be reprogramed in interrupt context.
>
>The result of this is investigation is that I am convinced we need
>to perform the irq migration activities in interrupt context although
>I am not convinced it is completely safe.  I suspect multiple irqs
>firing closely enough to each other may hit the same issues as
>migrating irqs from process context.  However the odds are on our
>side, when we are in irq context.
>
>  
>
In my older days of programmin 82489DX chipsets (which the AMD APIC 
versions resemble
the 82489DX more closely than intel's newer incarnations), you had to 
EOI the apic early if you
wanted to migrate interrupt assignments. I had to do the following steps 
to move an IRQ:

1. Mask the LOCAL APIC
2, EOI the interrupt
3. Leave the interrupt entry masked until the ISR completed.
4. Reprogram the interrupt.
5. Unmask as the ISR exits

In other words, EOI early in all cases to clear the local and IOAPIC state.

Jeff


