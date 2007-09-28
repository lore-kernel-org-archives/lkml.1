Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbXI1OxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbXI1OxD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbXI1Owy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:52:54 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:38928 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbXI1Owy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:52:54 -0400
Date: Fri, 28 Sep 2007 15:52:25 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Break ELF_PLATFORM and stack pointer randomization
	dependency
Message-ID: <20070928145225.GA29567@linux-mips.org>
References: <46FCDEA3.20205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FCDEA3.20205@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 12:59:47PM +0200, Franck Bui-Huu wrote:

> Currently arch_align_stack() is used by fs/binfmt_elf.c to randomize
> stack pointer inside a page. But this happens only if ELF_PLATFORM
> symbol is defined.
> 
> ELF_PLATFORM is normally set if the architecture wants ld.so to load
> implementation specific libraries for optimization. And currently a
> lot of architectures just yield this symbol to NULL.
> 
> This is the case for MIPS architecture where ELF_PLATFORM is NULL but
> arch_align_stack() has been redefined to do stack inside page
> randomization. So in this case no randomization is actually done.
> 
> This patch breaks this dependency which seems to be useless and allows
> platforms such MIPS to do the randomization.
> 
> Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
> ---
> 
> 	Andrew,
> 
>    I tried several times to poke people on the list to understand why
>    this dependency exists at all, but unfortunately got no answers.
> 
>    So I'm submitting this patch to at least have some feedbacks. An
>    easier solution would be to define ELF_PLATFORM to a dummy string
>    for MIPS but it sounds very hackish.

Probably this was introduced a long time ago, so it's only recorded in
tglx's history git tree:

commit ccc875c1d2fe18b50020d501f1005ef46fc55fed
Author: Arjan van de Ven <arjan@infradead.org>
Date:   Fri Mar 4 17:25:13 2005 -0800

    [PATCH] Randomisation: stack randomisation
    
    The patch below replaces the existing 8Kb randomisation of the userspace sta
    pointer (which is currently only done for Hyperthreaded P-IVs) with a more
    general randomisation over a 64Kb range.  64Kb is not a lot, but it's a star
    and once the dust settles we can increase this value to a more agressive
    value.
    
    Signed-off-by: Arjan van de Ven <arjan@infradead.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commitdiff;h=ccc875c1d2fe18b50020d501f1005ef46fc55fed

  Ralf
