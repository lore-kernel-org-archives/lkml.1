Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbXEaO02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbXEaO02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 10:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbXEaO0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 10:26:19 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:59843 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbXEaO0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 10:26:18 -0400
Date: Thu, 31 May 2007 07:26:07 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/22] 2.6.22-rc3 perfmon2 : modified x86_64 files
Message-ID: <20070531142607.GI22798@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <200705291348.l4TDmYaf019853@frankl.hpl.hp.com> <p73ejkxc9un.fsf@bingen.suse.de> <20070531141600.GH22798@frankl.hpl.hp.com> <20070531142038.GB2538@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531142038.GB2538@one.firstfloor.org>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Thu, May 31, 2007 at 04:20:38PM +0200, Andi Kleen wrote:
> 
> > > Just use a cpu notifier instead. No need to add everybody's per cpu init code here.
> > 
> > The code must run on the CPU that is being initialized.
> 
> smp_call_function_single() 
> 
Isn't that more complicated than just adding a hook in cpu_disable()?

> > > 
> > > No compat syscalls? 
> > > 
> > compat syscalls for what? I need to ensure backward compatiblity on IA-64 only.
> 
> For 32bit / i386 code.

I's there in ia32entry.S. Was it missing from the E-mail?

In anycase, here it is:

diff --exclude=.git -urp linux-2.6.22.base/arch/x86_64/ia32/ia32entry.S linux-2.6.22/arch/x86_64/ia32/ia32entry.S
--- linux-2.6.22.base/arch/x86_64/ia32/ia32entry.S      2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/x86_64/ia32/ia32entry.S   2007-05-29 03:24:14.000000000 -0700
@@ -719,4 +719,16 @@ ia32_sys_call_table:
        .quad compat_sys_signalfd
        .quad compat_sys_timerfd
        .quad sys_eventfd
+       .quad sys_pfm_create_context
+       .quad sys_pfm_write_pmcs
+       .quad sys_pfm_write_pmds
+       .quad sys_pfm_read_pmds
+       .quad sys_pfm_load_context
+       .quad sys_pfm_start
+       .quad sys_pfm_stop
+       .quad sys_pfm_restart
+       .quad sys_pfm_create_evtsets
+       .quad sys_pfm_getinfo_evtsets
+       .quad sys_pfm_delete_evtsets
+       .quad sys_pfm_unload_context
 ia32_syscall_end:



-- 

-Stephane
