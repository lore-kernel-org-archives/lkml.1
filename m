Return-Path: <linux-kernel-owner+w=401wt.eu-S1755802AbYKEOmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbYKEOmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 09:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbYKEOmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 09:42:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50604 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbYKEOml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 09:42:41 -0500
Date: Wed, 5 Nov 2008 09:41:44 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Eduardo Habkost <ehabkost@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Haren Myneni <hbabu@us.ibm.com>, Andrey Borzenkov <arvidjaar@mail.ru>,
       mingo@redhat.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/16] kdump: Hook emergency_virt_disable() on crash
	shutdown code
Message-ID: <20081105144144.GC8993@redhat.com>
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com> <1225810364-8990-10-git-send-email-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225810364-8990-10-git-send-email-ehabkost@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 12:52:37PM -0200, Eduardo Habkost wrote:
> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> ---
>  arch/x86/kernel/crash.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> index d84a852..87780ba 100644
> --- a/arch/x86/kernel/crash.c
> +++ b/arch/x86/kernel/crash.c
> @@ -26,6 +26,7 @@
>  #include <linux/kdebug.h>
>  #include <asm/smp.h>
>  #include <asm/reboot.h>
> +#include <asm/virtext.h>
>  
>  #include <mach_ipi.h>
>  
> @@ -49,6 +50,7 @@ static void kdump_nmi_callback(int cpu, struct die_args *args)
>  #endif
>  	crash_save_cpu(regs, cpu);
>  
> +	emergency_virt_disable();
>  	disable_local_APIC();
>  }
>  
> @@ -80,6 +82,7 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
>  	local_irq_disable();
>  
>  	kdump_nmi_shootdown_cpus();
> +	emergency_virt_disable();

Hi Eduardo,

It might be a good idea to put a 2-3 line comment saying why it is
imporatant to disable virtualization here before we continue.

Thanks
Vivek
