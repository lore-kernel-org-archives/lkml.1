Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbYCRDFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbYCRDFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 23:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbYCRDFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 23:05:23 -0400
Received: from smtp105.sbc.mail.re2.yahoo.com ([68.142.229.100]:49120 "HELO
	smtp105.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751391AbYCRDFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 23:05:22 -0400
X-YMail-OSG: G0pfnbEVM1mmYDdK3_HONBybW0Ls8NXU9HbqXE67CtqLk7_9x6_QTrTDLrAJF_7c5B9aqwVy90irWgtZahlyFpj1IUseW_Yp3oKP5g9EBsBG56LkPUv9SOI8FsiLVmWJOwPeYLT7NgzYrPI-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 17 Mar 2008 22:02:16 -0500
From: serge@hallyn.com
To: Justin Mattock <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morgan <morgan@kernel.org>
Subject: Re: capability.h
Message-ID: <20080318030216.GA20103@vino.hallyn.com>
References: <dd18b0c30803171106m55670b2fg557b23e4e2285ba1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd18b0c30803171106m55670b2fg557b23e4e2285ba1@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Justin Mattock (justinmattock@gmail.com):
> Hello; I seem to be very confused on how to install fglrx on 2.6.25-*
> below is the warnings and errors,
> 
> 
> cleaning...
> patching 'highmem.h'...
> assuming new VMA API since we do have kernel 2.6.x...
> def_vma_api_version=-DFGL_LINUX253P1_VMA_API
>  Assuming default VMAP API
>  Assuming default munmap API
> doing Makefile based build for kernel 2.6.x and higher
> make -C /lib/modules/2.6.25-rc6/build
> SUBDIRS=/lib/modules/fglrx/build_mod/2.6.x modules
> make[1]: Entering directory `/home/kernel/linux-2.6.25-rc6'
>   CC [M]  /lib/modules/fglrx/build_mod/2.6.x/firegl_public.o
> /lib/modules/fglrx/build_mod/2.6.x/firegl_public.c: In function
> 'KCL_SetPageNoCache':
> /lib/modules/fglrx/build_mod/2.6.x/firegl_public.c:1161: warning:
> 'change_page_attr' is deprecated (declared at
> include/asm/cacheflush.h:28)
> /lib/modules/fglrx/build_mod/2.6.x/firegl_public.c: In function
> 'KCL_PosixSecurityCapGetEffectiveVector':
> /lib/modules/fglrx/build_mod/2.6.x/firegl_public.c:1888: error:
> implicit declaration of function 'cap_t'
> /lib/modules/fglrx/build_mod/2.6.x/firegl_public.c: In function
> 'KCL_PosixSecurityCapSetEffectiveVector':
> /lib/modules/fglrx/build_mod/2.6.x/firegl_public.c:1896: error:
> invalid lvalue in assignment
> /lib/modules/fglrx/build_mod/2.6.x/firegl_public.c: In function
> '__ke_check_pci':
> /lib/modules/fglrx/build_mod/2.6.x/firegl_public.c:1951: warning:
> 'pci_find_slot' is deprecated (declared at include/linux/pci.h:508)
> /lib/modules/fglrx/build_mod/2.6.x/firegl_public.c: In function
> '__ke_pci_find_slot':
> /lib/modules/fglrx/build_mod/2.6.x/firegl_public.c:2840: warning:
> 'pci_find_slot' is deprecated (declared at include/linux/pci.h:508)
> make[2]: *** [/lib/modules/fglrx/build_mod/2.6.x/firegl_public.o] Error 1
> make[1]: *** [_module_/lib/modules/fglrx/build_mod/2.6.x] Error 2
> make[1]: Leaving directory `/home/kernel/linux-2.6.25-rc6'
> make: *** [kmod_build] Error 2
> build failed with return value 2
> 
> 
> Under firegl_public.c it seems the module is requesting a cap_t  get
> and receive an effective vector.
> With the new capability.h file, what is the capability that replaces cap_t?

cap_t() appears to be defined under ifdef __KERNEL__.  Which makes
sense since it takes a struct kernel_cap_t :)  I don't have the
source code you're compiling, and don't know what would be the "right"
way to fix it, but to get your code to compile I'd just put a
#define cap(x) (x).cap
at the top of the .c files needing it.

-serge
