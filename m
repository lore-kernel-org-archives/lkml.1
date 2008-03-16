Return-Path: <linux-kernel-owner+w=401wt.eu-S1753069AbYCPLNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbYCPLNU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 07:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYCPLNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 07:13:12 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:35534
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYCPLNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 07:13:11 -0400
Message-ID: <47DD00C4.2070100@qumranet.com>
Date: Sun, 16 Mar 2008 13:13:08 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: lkml <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       kvm-devel@lists.sourceforge.net, tglx <tglx@linutronix.de>,
       mingo <mingo@redhat.com>, hpa <hpa@zytor.com>
Subject: Re: [PATCH] x86: don't allow KVM_CLOCK without HAVE_KVM
References: <20080314104444.ca80e434.randy.dunlap@oracle.com>
In-Reply-To: <20080314104444.ca80e434.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Make KVM_CLOCK depend on HAVE_KVM.  Otherwise a Voyager build can
> fail with:
>
>   CC      arch/x86/kernel/asm-offsets.s
> In file included from include2/asm/irqflags.h:59,
>                  from /local/linsrc/next-20080314/include/linux/irqflags.h:46,
>                  from include2/asm/system.h:11,
>                  from include2/asm/processor.h:21,
>                  from include2/asm/atomic_32.h:5,
>                  from include2/asm/atomic.h:2,
>                  from /local/linsrc/next-20080314/include/linux/crypto.h:20,
>                  from /local/linsrc/next-20080314/arch/x86/kernel/asm-offsets_32.c:7,
>                  from /local/linsrc/next-20080314/arch/x86/kernel/asm-offsets.c:2:
> include2/asm/paravirt.h: In function 'startup_ipi_hook':
> include2/asm/paravirt.h:856: error: 'struct pv_apic_ops' has no member named 'startup_ipi_hook'
> include2/asm/paravirt.h:856: error: 'struct pv_apic_ops' has no member named 'startup_ipi_hook'
> include2/asm/paravirt.h:856: error: memory input 4 is not directly addressable
> make[2]: *** [arch/x86/kernel/asm-offsets.s] Error 1
> make[1]: *** [prepare0] Error 2
> make: *** [sub-make] Error 2
>
>   

Looks like it's a general paravirt vs voyager issue, nothing kvmclock 
specific about it.  Wouldn't it be better to have voyager and paravirt 
mutually exclude each other, rather than every paravirt user?

HAVE_KVM is intended for the host, not the guest, btw.

-- 
error compiling committee.c: too many arguments to function

