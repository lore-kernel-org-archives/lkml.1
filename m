Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506AbZH1VHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbZH1VHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 17:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbZH1VHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 17:07:30 -0400
Received: from host0.dyn.jankratochvil.net ([89.250.240.59]:36969 "EHLO
	host0.dyn.jankratochvil.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134AbZH1VHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 17:07:30 -0400
Date: Fri, 28 Aug 2009 23:07:11 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] Fix vdso32 relocation for paddr
Message-ID: <20090828210711.GA9980@host0.dyn.jankratochvil.net>
References: <20090826223126.GA20373@host0.dyn.jankratochvil.net> <2375c9f90908280213i520e75a2wed97781ab2cd37ca@mail.gmail.com> <20090828181534.0823745B02@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090828181534.0823745B02@magilla.sf.frob.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009 20:15:34 +0200, Roland McGrath wrote:
> Thanks for heads-up.  It's definitely right to CC me on patches that change
> the build/setup vDSO details.

OK, I thought more about {p,u}trace.


> That change seems fine.  Or just explicit p_addr = p_vaddr would be fine
> too (and not assume that what the linker produced is consistent, in case
> some old linkers produce stranger results from the vdso linker scripts).

Updated.  Verified on x86_64 host it works right for an i386 binary.


Thanks,
Jan


Signed-off-by: Jan Kratochvil <jan.kratochvil@redhat.com>

--- linux-2.6.30.x86_64/arch/x86/vdso/vdso32-setup.c-orig	2009-08-26 22:23:08.000000000 +0200
+++ linux-2.6.30.x86_64/arch/x86/vdso/vdso32-setup.c	2009-08-26 22:38:10.000000000 +0200
@@ -172,6 +172,7 @@ static __init void relocate_vdso(Elf32_E
 	phdr = (void *)ehdr + ehdr->e_phoff;
 	for (i = 0; i < ehdr->e_phnum; i++) {
 		phdr[i].p_vaddr += VDSO_ADDR_ADJUST;
+		phdr[i].p_paddr = phdr[i].p_vaddr;
 
 		/* relocate dynamic stuff */
 		if (phdr[i].p_type == PT_DYNAMIC)
