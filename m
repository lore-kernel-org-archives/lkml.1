Return-Path: <linux-kernel-owner+w=401wt.eu-S1762219AbYDWCSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762219AbYDWCSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 22:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932804AbYDWCSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 22:18:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59925 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759891AbYDWCR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 22:17:59 -0400
Subject: Re: x86: cleanup - rename VM_MASK to X86_VM_MASK
From: David Woodhouse <dwmw2@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200804181856.m3IIuKd4007403@hera.kernel.org>
References: <200804181856.m3IIuKd4007403@hera.kernel.org>
Content-Type: text/plain
Date: Wed, 23 Apr 2008 03:17:56 +0100
Message-Id: <1208917076.9212.721.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-18 at 18:56 +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6b6891f9c545ccd45d6d8ddfd33ce27c22c271a7
> Commit:     6b6891f9c545ccd45d6d8ddfd33ce27c22c271a7
> Parent:     6093015db2bd9e70cf20cdd23be1a50733baafdd
> Author:     gorcunov@gmail.com <gorcunov@gmail.com>
> AuthorDate: Fri Mar 28 17:56:57 2008 +0300
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu Apr 17 17:41:33 2008 +0200
> 
>     x86: cleanup - rename VM_MASK to X86_VM_MASK
>     
>     This patch renames VM_MASK to X86_VM_MASK (which
>     in turn defined as alias to X86_EFLAGS_VM) to better
>     distinguish from virtual memory flags. We can't just
>     use X86_EFLAGS_VM instead because it is also used
>     for conditional compilation
>     
>     Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>


> --- a/include/asm-x86/vm86.h
> +++ b/include/asm-x86/vm86.h
> @@ -17,9 +17,9 @@
>  #define IOPL_MASK	0x00003000
>  #define NT_MASK		0x00004000
>  #ifdef CONFIG_VM86
> -#define VM_MASK		0x00020000
> +#define X86_VM_MASK	X86_EFLAGS_VM
>  #else
> -#define VM_MASK		0 /* ignored */
> +#define X86_VM_MASK	0 /* No VM86 support */
>  #endif
>  #define AC_MASK		0x00040000
>  #define VIF_MASK	0x00080000	/* virtual interrupt flag */

This is user-visible. Yet we're changing the name and also making it
depend on #ifdef CONFIG_VM86, which is not going to be set in userspace.
Perhaps it should be within #ifdef __KERNEL__?

-- 
dwmw2

