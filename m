Return-Path: <linux-kernel-owner+w=401wt.eu-S1764736AbXKUANx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764736AbXKUANx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 19:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759081AbXKUANp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 19:13:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45284 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758574AbXKUANo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 19:13:44 -0500
Date: Wed, 21 Nov 2007 01:13:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zachary Amsden <zach@vmware.com>
Cc: Roland McGrath <roland@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/18] x86 vDSO: consolidate vdso32
Message-ID: <20071121001307.GA1804@elte.hu>
References: <20071119215944.01B7C26F8BE@magilla.localdomain> <20071119220644.F41CA26F8C1@magilla.localdomain> <1195604010.6352.237.camel@bodhitayantram.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195604010.6352.237.camel@bodhitayantram.eng.vmware.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Zachary Amsden <zach@vmware.com> wrote:

> > The 32-bit vDSO mapping now behaves the same on x86_64 as on native 
> > 32-bit. The abi.syscall32 sysctl on x86_64 now takes the same values 
> > that vm.vdso_enabled takes on the 32-bit kernel.  That is, 1 means a 
> > randomized vDSO location, 2 means the fixed old address.  The 
> > CONFIG_COMPAT_VDSO option is now available to make this the default 
> > setting, the same meaning it has for the 32-bit kernel.  (This does 
> > not affect the 64-bit vDSO.)
> 
> I think you should drop CONFIG_COMPAT_VDSO support for 32-bit VDSO on 
> 64-bit kernel.  This was only to hack around a broken version of glibc 
> that shipped with SUSE PRO 9.0, which had broken assertions based on 
> misinterpretation of ELF fields.  64-bit machines will never see this 
> glibc and the hack can die.
> 
> Perhaps it is finally time to remove the hack from 32-bit as well, and 
> eliminate COMPAT_VDSO entirely?  Or does it really have to live 
> forever.

we can phase it out, via the Documentation/feature-removal-schedule.txt 
mechanism.

	Ingo
