Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbZHQIg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbZHQIg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757330AbZHQIg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:36:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53682 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757316AbZHQIg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:36:27 -0400
Date: Mon, 17 Aug 2009 10:35:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       ak@linux.intel.com, tglx@linutronix.de, Yinghai Lu <yinghai@kernel.org>,
       Huang Ying <ying.huang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [boot crash] Re: [tip:x86/mce3] x86, mce: use 64bit machine
	check code on 32bit
Message-ID: <20090817083544.GC15390@elte.hu>
References: <tip-4efc0670baf4b14bc95502e54a83ccf639146125@git.kernel.org> <20090812113652.GA19632@elte.hu> <4A88E3E4.40506@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A88E3E4.40506@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> Hi Ingo,
> 
> Ingo Molnar wrote:
> > * tip-bot for Andi Kleen <ak@linux.intel.com> wrote:
> > 
> >> Commit-ID:  4efc0670baf4b14bc95502e54a83ccf639146125
> >> Gitweb:     http://git.kernel.org/tip/4efc0670baf4b14bc95502e54a83ccf639146125
> >> Author:     Andi Kleen <ak@linux.intel.com>
> >> AuthorDate: Tue, 28 Apr 2009 19:07:31 +0200
> >> Committer:  H. Peter Anvin <hpa@zytor.com>
> >> CommitDate: Thu, 28 May 2009 09:24:13 -0700
> >>
> >> x86, mce: use 64bit machine check code on 32bit
> 
> (snip)
> 
> > 
> > This commit causes a new regression, it broke the bootup on one of 
> > my -tip testsystems, an older, Pentium-M based HP laptop (HP 
> > OmniBook 6000 EA).
> > 
> > The symptom is that the bootup hard-hangs after MCE init:
> > 
> >  [    0.022996] Mount-cache hash table entries: 512
> >  [    0.024996] Initializing cgroup subsys debug
> >  [    0.025996] Initializing cgroup subsys cpuacct
> >  [    0.026995] Initializing cgroup subsys devices
> >  [    0.027995] Initializing cgroup subsys freezer
> >  [    0.028995] mce: CPU supports 5 MCE banks
> > 
> > Kernel config attached. cpuinfo:
> > 
> > processor	: 0
> > vendor_id	: GenuineIntel
> > cpu family	: 6
> > model		: 8
> > model name	: 06/08
> > stepping	: 10
> > cpu MHz		: 846.372
> 
> According to the cpuid, I suppose this cpu is Pentium III.

yep.

> > fdiv_bug	: no
> > hlt_bug		: no
> > f00f_bug	: no
> > coma_bug	: no
> > fpu		: yes
> > fpu_exception	: yes
> > cpuid level	: 2
> > wp		: yes
> > flags		: fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat pse36 mmx fxsr sse up
> 
> None of acpi, apic, and tm is available.
> So at least thermal codes should be innocent.

yes.

> > bogomips	: 1692.74
> > clflush size	: 32
> > power management:
> > 
> > 	Ingo
> 
> Could you try boot your laptop with mce=nobootlog?

Hm, why should that make any difference? mce=nobootlog only 
influences whether we pass records into the mcelog buffer but does 
not affect whether we touch the hardware.

	Ingo
