Return-Path: <linux-kernel-owner+w=401wt.eu-S1760901AbYAYJuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760901AbYAYJuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 04:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757539AbYAYJuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 04:50:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47013 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459AbYAYJuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 04:50:39 -0500
Date: Fri, 25 Jan 2008 10:50:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] x86: fixes some bugs about EFI memory map handling
Message-ID: <20080125095016.GI23708@elte.hu>
References: <1201240507.15972.48.camel@caritas-dev.intel.com> <20080125093131.GG23708@elte.hu> <1201254015.15972.66.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201254015.15972.66.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Huang, Ying <ying.huang@intel.com> wrote:

> On Fri, 2008-01-25 at 10:31 +0100, Ingo Molnar wrote:
> > * Huang, Ying <ying.huang@intel.com> wrote:
> > 
> > > This patch fixes some bugs of EFI memory handing code.
> > > 
> > > - On x86_64, it is possible that EFI memory map can not be mapped via
> > >   identity map, so efi_map_memmap is removed, just use early_ioremap.
> > > 
> > > - On i386, the EFI memory map mapping take effect cross paging_init,
> > >   so it is not necessary to use efi_map_memmap.
> > > 
> > > - EFI memory map is unmapped in efi_enter_virtual_mode to avoid
> > >   early_ioremap leak.
> > 
> > thanks, applied.
> > 
> > btw., it would be nice to consolidate this some more. Why is there a 
> > separate efi_ioremap(), which is mapped to ioremap() on 32-bit, and 
> > which is mapped to a fixmap based special mapper on 64-bit?
> > 
> > To me it appears this wants to be ioremap() on both 64-bit and 
> > 32-bit, and we could remove efi_ioremap() altogether. Hm?
> 
> To support kexec, I want to map the EFI memory area on same virtual 
> address on different boot of different version of kernel. Then, the 
> EFI runtime service will always get the same execution environment. 
> This is because a weakness of EFI runtime service, it can not reset 
> its execution environment, except reboot.

so this basically means that on 32-bit kexec wont work right - i.e. only 
64-bit has been enhanced this way? What am i missing?

	Ingo
