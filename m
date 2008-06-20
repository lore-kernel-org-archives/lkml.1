Return-Path: <linux-kernel-owner+w=401wt.eu-S1752919AbYFTGs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbYFTGs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 02:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYFTGsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 02:48:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37365 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbYFTGsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 02:48:19 -0400
Date: Fri, 20 Jun 2008 08:47:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: update mptable v7
Message-ID: <20080620064750.GB31182@elte.hu>
References: <200806011317.38622.yhlu.kernel@gmail.com> <alpine.LFD.1.10.0806181812580.3074@localhost.localdomain> <86802c440806181532g348864e1u3d067f8366046a7f@mail.gmail.com> <alpine.LFD.1.10.0806182031060.3074@localhost.localdomain> <86802c440806181749g2faf1892iea693717ea919631@mail.gmail.com> <m1mylim4e6.fsf@frodo.ebiederm.org> <alpine.LFD.1.10.0806190121210.3613@localhost.localdomain> <m1abhilyl0.fsf@frodo.ebiederm.org> <86802c440806190031q17049054md2a790224d30d29@mail.gmail.com> <alpine.LFD.1.10.0806191412100.3040@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806191412100.3040@localhost.localdomain>
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


* Len Brown <lenb@kernel.org> wrote:

> > the patch did print out the old and updated mptable.
> > 
> > and that feature is enabled via "update_mptable" command line.
> > 
> > 
> > also it is useful for kexec from acpi kernel to no acpi kernel on MB
> > with nvidia chipset with AMI BIOS.
> > becuase irq routing is different from mptable and acpi.
> > 
> > amd8111/amd8131 chipset with AMI bios has same irq routing from
> > mptable and acpi.
> > 
> > Phonix BIOS, has one setup option APIC/PIC, and if select APIC, then
> > irq routing from mptable and acpi is the same with
> > nvidia chipset.
> 
> So you know this can't NEVER be reliable, yet you continue to push for 
> upstream changes that carry risk for all systems that DO work.

Yinghai: Len has a point, could you please double-check that no 
potentially risky code runs by default anywhere, without a specific boot 
option? update_mptable is supposed to achieve that, but lets make sure 
it does its job.

I.e. the option should be like acpi=off - risky to do as it could break 
some systems, and it should not run by default. I have 3 systems myself 
where acpi=off results in a non-working system (hard hangs, non-detected 
devices, etc.).

Len: while i probably wont use the update_mptable option myself (i wont 
ever want to kexec into an OS with broken ACPI support), Yinghai's 
changes nevertheless have some use as they solve an external problem, 
and they also clean up a crufty area of code. Due to them we already 
found pre-existing bugs.

	Ingo
