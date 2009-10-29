Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbZJ2XQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbZJ2XQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 19:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756710AbZJ2XQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 19:16:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:35492 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683AbZJ2XQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 19:16:19 -0400
Subject: Re: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0910290911550.31845@localhost.localdomain>
References: <1256627452.11607.90.camel@pasglop>
	 <alpine.LFD.2.01.0910290911550.31845@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Oct 2009 10:16:12 +1100
Message-ID: <1256858172.6372.26.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-29 at 09:14 -0700, Linus Torvalds wrote:
> 
> On Tue, 27 Oct 2009, Benjamin Herrenschmidt wrote:
> > 
> > Kumar Gala (7):
> >       powerpc: Add a Book-3E 64-bit defconfig
> >       powerpc: Fix compile errors found by new ppc64e_defconfig
> >       powerpc: Limit hugetlbfs support to PPC64 Book-3S machines
> 
> This is incredibly ugly. Why should the generic fs/Kconfig know about some 
> random odd architecture detail like PPC_BOOK3S_64?
> 
> I merged it, and noticed this because Super-H caused clashes by cleaning 
> up. I would suggest PowerPC do the same.

Right. I noticed the same thing yesterday and planned to do so today

> This patch is not signed-off, nor do I want any credit. But if it works on 
> ppc, please send me something like this back.

I'll stick something like that in my tree and send you a pull request.

Cheers,
Ben.

> 		Linus
> ---
>  arch/powerpc/Kconfig |    3 +++
>  fs/Kconfig           |    2 +-
>  2 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 10a0a54..877db84 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -131,6 +131,9 @@ config PPC
>  	select GENERIC_ATOMIC64 if PPC32
>  	select HAVE_PERF_EVENTS
>  
> +config SYS_SUPPORTS_HUGETLBFS
> +	defbool PPC_BOOK3S_64
> +
>  config EARLY_PRINTK
>  	bool
>  	default y
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 2126078..64d44ef 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -135,7 +135,7 @@ config TMPFS_POSIX_ACL
>  
>  config HUGETLBFS
>  	bool "HugeTLB file system support"
> -	depends on X86 || IA64 || PPC_BOOK3S_64 || SPARC64 || (S390 && 64BIT) || \
> +	depends on X86 || IA64 || SPARC64 || (S390 && 64BIT) || \
>  		   SYS_SUPPORTS_HUGETLBFS || BROKEN
>  	help
>  	  hugetlbfs is a filesystem backing for HugeTLB pages, based on


