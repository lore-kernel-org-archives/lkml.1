Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbYAYJj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbYAYJj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 04:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758639AbYAYJjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 04:39:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:50224 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162AbYAYJjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 04:39:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,249,1199692800"; 
   d="scan'208";a="508004348"
Subject: Re: [PATCH 6/6] x86: fixes some bugs about EFI memory map handling
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080125093131.GG23708@elte.hu>
References: <1201240507.15972.48.camel@caritas-dev.intel.com>
	 <20080125093131.GG23708@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Jan 2008 17:40:15 +0800
Message-Id: <1201254015.15972.66.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 25 Jan 2008 09:39:32.0425 (UTC) FILETIME=[305BBB90:01C85F36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-25 at 10:31 +0100, Ingo Molnar wrote:
> * Huang, Ying <ying.huang@intel.com> wrote:
> 
> > This patch fixes some bugs of EFI memory handing code.
> > 
> > - On x86_64, it is possible that EFI memory map can not be mapped via
> >   identity map, so efi_map_memmap is removed, just use early_ioremap.
> > 
> > - On i386, the EFI memory map mapping take effect cross paging_init,
> >   so it is not necessary to use efi_map_memmap.
> > 
> > - EFI memory map is unmapped in efi_enter_virtual_mode to avoid
> >   early_ioremap leak.
> 
> thanks, applied.
> 
> btw., it would be nice to consolidate this some more. Why is there a 
> separate efi_ioremap(), which is mapped to ioremap() on 32-bit, and 
> which is mapped to a fixmap based special mapper on 64-bit?
> 
> To me it appears this wants to be ioremap() on both 64-bit and 32-bit, 
> and we could remove efi_ioremap() altogether. Hm?

To support kexec, I want to map the EFI memory area on same virtual
address on different boot of different version of kernel. Then, the EFI
runtime service will always get the same execution environment. This is
because a weakness of EFI runtime service, it can not reset its
execution environment, except reboot.

Best Regards,
Huang Ying
