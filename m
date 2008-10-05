Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbYJEKFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbYJEKFS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 06:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbYJEKFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 06:05:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56810 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbYJEKFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 06:05:04 -0400
Date: Sun, 5 Oct 2008 12:04:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86: make 64bit efi to use ioremap_cache for
	efi_ioremap
Message-ID: <20081005100444.GG29909@elte.hu>
References: <1223101400-8819-1-git-send-email-yhlu.kernel@gmail.com> <851fc09e0810040235g2ab97bdai612c0a2829f83f5c@mail.gmail.com> <86802c440810041044m5b950721s8700bb6cd2fe75d@mail.gmail.com> <851fc09e0810050156y114007e4hbdf3e6c5562004d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <851fc09e0810050156y114007e4hbdf3e6c5562004d3@mail.gmail.com>
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


* huang ying <huang.ying.caritas@gmail.com> wrote:

> On Sun, Oct 5, 2008 at 1:44 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Sat, Oct 4, 2008 at 2:35 AM, huang ying <huang.ying.caritas@gmail.com> wrote:
> [...]
> >> Using __va and efi_ioremap() here is to make EFI support compatible
> >> with kexec. Because EFI provide only efi_enter_virtual_mode(), no
> >> efi_leave_virtual_mode(), we should make EFI runtime memory area
> >> mapped to same virtual memory area in original kernel and kexeced
> >> kernel, so that the EFI runtime services can be used in kexeced
> >> kernel.
> >
> > so need to make efi range all under direct-mapping like E820-RAM?
> 
> Some EFI runtime range is just some RAM area used by EFI runtime 
> services, they can be direct-mapped. Some EFI runtime range may be IO 
> MEM range used by EFI runtime services, it is possible that these IO 
> MEM range can not be direct-mapped. So I implement efi_ioremap() to 
> deal with them.

hm, but in the "some RAM area" case, that area should not be listed in 
the e820 map (or any EFI memory map), and hence it should never be 
mapped directly. I.e. you should be able to just standardize on 
ioremap() and have no parallel facility for this.

	Ingo
