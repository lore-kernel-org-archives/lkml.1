Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbZEKPkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbZEKPkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbZEKPj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:39:56 -0400
Received: from smtp.citrix.com ([66.165.176.89]:32624 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbZEKPj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:39:56 -0400
X-IronPort-AV: E=Sophos;i="4.40,328,1238990400"; 
   d="scan'208";a="4193098"
Subject: Re: [tip:x86/xen] x86: use flush_tlb_others to implement
	flush_tlb_all, fix
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
In-Reply-To: <20090511151151.GA3267@elte.hu>
References: <1241797927.15972.51.camel@zakaz.uk.xensource.com>
	 <tip-636afdbe85d50d9b88f5283b5e6d0f8518431aac@git.kernel.org>
	 <20090511131230.GA32693@elte.hu>
	 <1242054041.29990.88.camel@zakaz.uk.xensource.com>
	 <20090511151151.GA3267@elte.hu>
Content-Type: text/plain; charset="utf-8"
Organization: Citrix Systems, Inc.
Date: Mon, 11 May 2009 16:39:54 +0100
Message-ID: <1242056394.29990.94.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 11:11 -0400, Ingo Molnar wrote:
> * Ian Campbell <Ian.Campbell@eu.citrix.com> wrote:
> 
> > --- a/arch/x86/kernel/setup.c
> > +++ b/arch/x86/kernel/setup.c
> > @@ -985,6 +985,8 @@ void __init setup_arch(char **cmdline_p)
> >  
> >  	e820_setup_gap();
> >  
> > +	init_smp_flush();
> > +
> 
> please test patches better:
> 
> arch/x86/kernel/setup.c:1006: error: implicit declaration of function ‘init_smp_flush’

Doesn't happen in my environment:
+ make O=../linux-2.6-build-dom0-x86_32p-xen0 ARCH=x86 arch/x86/kernel/setup.o
  Using /local/scratch/ianc/devel/kernels/linux-2.6 as source for kernel
  GEN     /local/scratch/ianc/devel/kernels/linux-2.6-build-dom0-x86_32p-xen0/Makefile
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    /local/scratch/ianc/devel/kernels/linux-2.6/scripts/checksyscalls.sh
  CC      arch/x86/kernel/setup.o

This was on f6271becbae641903a9f703b7b75cccb202df82a which is latest
tip/master. I guess either you have unpushed changes or it is config
specific.

in any case I would guess that the fix is:

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -87,6 +87,7 @@
 #include <asm/cacheflush.h>
 #include <asm/processor.h>
 #include <asm/bugs.h>
+#include <asm/tlbflush.h>
 
 #include <asm/system.h>
 #include <asm/vsyscall.h>



