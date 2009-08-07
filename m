Return-Path: <linux-kernel-owner+w=401wt.eu-S933102AbZHGTQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102AbZHGTQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 15:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933049AbZHGTQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 15:16:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:58070 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932998AbZHGTQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 15:16:41 -0400
X-Authenticated: #2360897
X-Provags-ID: V01U2FsdGVkX198pFoNV5R8ELVUTl6JNoWyiOJPHdiaO4xzKL+HaB
	GMqg21nI/fJM/2
Message-ID: <4A7C7D95.4030900@gmx.de>
Date: Fri, 07 Aug 2009 21:16:37 +0200
From: Bernhard Walle <bernhard.walle@gmx.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Amerigo Wang <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 4/7] ia64: implement crashkernel=auto
References: <20090806062125.5578.72123.sendpatchset@localhost.localdomain> <20090806062211.5578.59301.sendpatchset@localhost.localdomain>
In-Reply-To: <20090806062211.5578.59301.sendpatchset@localhost.localdomain>
X-Enigmail-Version: 0.95.7
OpenPGP: id=DDAF6454
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang schrieb:
>  
> +#ifdef CONFIG_KEXEC_AUTO_RESERVE
> +#ifdef KEXEC_AUTO_RESERVED_SIZE
> +#undef KEXEC_AUTO_RESERVED_SIZE
> +#endif
> +#define KEXEC_AUTO_RESERVED_SIZE (1ULL<<28) /* 256M */
> +#include <asm-generic/kexec.h>
> +#endif
> +
>  extern struct kimage *ia64_kimage;

IMO that's way too small for practial use on IA64 systems.

For SLES11, which is based on Linux 2.6.28 IIRC, we use following memory
size values in the YaST2 kdump module which configures the crashkernel
parameter (this is YCP syntax, but I think everybody understands it):

> // bnc #446480 - Fine-tune kdump memory proposal
> if ((Arch::ia64()) && (total_memory >= 1024))
> {
>     integer total_memory_gigabyte = total_memory/1024;
>     if ((total_memory_gigabyte >= 1) && (total_memory_gigabyte <12))
>         alocated_memory = "256";
>     else if ((total_memory_gigabyte >= 12) && (total_memory_gigabyte <128))
>         alocated_memory = "512";
>     else if ((total_memory_gigabyte >= 128) && (total_memory_gigabyte <256))
>         alocated_memory = "768";
>     else if ((total_memory_gigabyte >= 256) && (total_memory_gigabyte <378))
>         alocated_memory = "1024";
>     else if ((total_memory_gigabyte >= 378) && (total_memory_gigabyte <512))
>         alocated_memory = "1536";
>     else if ((total_memory_gigabyte >= 512) && (total_memory_gigabyte <768))
>         alocated_memory = "2048";
>     else if (total_memory_gigabyte >= 768)
>         alocated_memory = "3072";
> }

I got that assumtions from SGI (and they are known to have large IA64
systems) and I think the values were tested.

But IMO it doesn't make sense to put such policy decisions in the
kernel. I see no advantage for that. The average user doesn't have to
write crashkernel parameters, they use the values that the distribution
ships. Or do you think that an average user knows what a UUID of a file
system is just to specify the correct root partition?


Regards,
Bernhard

