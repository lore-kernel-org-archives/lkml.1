Return-Path: <linux-kernel-owner+w=401wt.eu-S1751771AbXCWGPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbXCWGPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 02:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbXCWGPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 02:15:38 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:58041 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbXCWGPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 02:15:37 -0400
Date: Fri, 23 Mar 2007 15:12:32 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Wu, Bryan" <bryan.wu@analog.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       bert hubert <bert.hubert@netherlabs.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm try#2] Blackfin: architecture update patch
Message-ID: <20070323061232.GA27616@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Wu, Bryan" <bryan.wu@analog.com>, Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	bert hubert <bert.hubert@netherlabs.nl>,
	linux-kernel@vger.kernel.org
References: <1174471618.5648.50.camel@roc-desktop> <20070321125631.GA13192@linux-sh.org> <1174629871.18866.22.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174629871.18866.22.camel@roc-desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 02:04:30PM +0800, Wu, Bryan wrote:
> This is the latest blackfin update patch. Because there are lots of
> issue fixing in this one, I put all modification in one update patch
> which is located in:
> https://blackfin.uclinux.org/gf/download/frsrelease/39/2707/blackfin-arch-2.6.21-rc4-mm1-update.patch
> 
I hope these will split up logically in the future so it's possible to
reply to them without having to do manual mangling..

The patch generally looks fine, this is the only thing that really jumped
out:

> Index: linux-2.6/include/asm-blackfin/pgtable.h
> ===================================================================
> --- linux-2.6.orig/include/asm-blackfin/pgtable.h
> +++ linux-2.6/include/asm-blackfin/pgtable.h
> @@ -59,4 +59,12 @@
>  #define	VMALLOC_START	0
>  #define	VMALLOC_END	0xffffffff
>  
> +#define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
> +#define arch_enter_lazy_cpu_mode()	do {} while (0)
> +#define arch_leave_lazy_cpu_mode()	do {} while (0)
> +
> +#define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
> +#define arch_enter_lazy_mmu_mode()	do {} while (0)
> +#define arch_leave_lazy_mmu_mode()	do {} while (0)
> +
>  #endif				/* _BLACKFIN_PGTABLE_H */

asm-generic/pgtable.h already does this if you don't explicitly define
__HAVE_ARCH_ENTER_LAZY_{CPU,MMU}_MODE. So please kill this entirely. If
you forgot to include asm-generic/pgtable.h, that's another matter..
