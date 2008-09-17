Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbYIQOK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbYIQOK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 10:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbYIQOKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 10:10:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54066 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbYIQOKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 10:10:49 -0400
Date: Wed, 17 Sep 2008 16:10:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yan Li <elliot.li.tech@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
Message-ID: <20080917141030.GC20510@elte.hu>
References: <20080221115452.GB13948@elte.hu> <20080907234510.GA24133@yantp.cn.ibm.com> <20080908140423.GG11993@elte.hu> <20080909002055.GA8573@yantp.cn.ibm.com> <48C5C47F.5040004@zytor.com> <20080916133239.GA17456@yantp.cn.ibm.com> <20080917105238.GF18764@elte.hu> <20080917140357.GA23523@yantp.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917140357.GA23523@yantp.cn.ibm.com>
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


* Yan Li <elliot.li.tech@gmail.com> wrote:

> On Wed, Sep 17, 2008 at 12:52:38PM +0200, Ingo Molnar wrote:
> > > This code is from mtrr_trim_uncached_memory(), and used by
> > > setup_arch(), which is used far before PCI is ready.
> > > 
> > > Therefore I think we can only use DMI here. Any idea?
> > 
> > PCI quirks can be used almost arbitrarily early stage, see:
> > arch/x86/kernel/early-quirks.c.
> > 
> > Adding a VM identification callback to early-quirks.c would be fine. But 
> > if there's a reliable and specific enough DMI string that's fine as 
> > well. (but PCI is better, since it's a generally more stable enumeration 
> > interface)
> 
> The problem here is that mtrr_trim_uncached_memory() is called 108 
> lines before the invocation of early_quirks(), and 48 lines before 
> that of dmi_scan_machine(). That's quite early.  The only thing ran 
> before that is the initialization of CPU, so we have nearly nothing to 
> use to check the fingerprint of the underlying machine.

that still leaves the CPUID/MSR method for the virtualizer to announce 
itself.

> I feel It's also unfit to touch the whole PCI or DMI thing before CPU 
> registers and memory are settled.  A simple solution here is to only 
> issue a KERN_INFO when we detected mtrr is empty and later, when we 
> can be sure that the OS is not running as a VM, issue a warning. The 
> later part can be done in early_quirks().

ok, we can move the MTRR message further back, to after the early quirks 
phase.

	Ingo
