Return-Path: <linux-kernel-owner+w=401wt.eu-S1752526AbZHVEQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbZHVEQv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 00:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbZHVEQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 00:16:50 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:45919 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750917AbZHVEQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 00:16:50 -0400
Message-ID: <4A8F712D.6090205@snapgear.com>
Date: Sat, 22 Aug 2009 14:16:45 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux/m68k <linux-m68k@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>,
       uClinux list <uclinux-dev@uclinux.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k,m68knommu: Wire up rt_tgsigqueueinfo and perf_counter_open
References: <alpine.DEB.2.00.0908212205300.15620@ayla.of.borg>
In-Reply-To: <alpine.DEB.2.00.0908212205300.15620@ayla.of.borg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/22/2009 06:07 AM, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>
> Cc: Greg Ungerer<gerg@uclinux.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>


>   arch/m68k/include/asm/unistd.h       |    4 +++-
>   arch/m68k/kernel/entry.S             |    2 ++
>   arch/m68knommu/kernel/syscalltable.S |    2 ++
>   3 files changed, 7 insertions(+), 1 deletions(-)
>
> diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
> index aa29a86..946d869 100644
> --- a/arch/m68k/include/asm/unistd.h
> +++ b/arch/m68k/include/asm/unistd.h
> @@ -334,10 +334,12 @@
>   #define __NR_inotify_init1	328
>   #define __NR_preadv		329
>   #define __NR_pwritev		330
> +#define __NR_rt_tgsigqueueinfo	331
> +#define __NR_perf_counter_open	332
>
>   #ifdef __KERNEL__
>
> -#define NR_syscalls		331
> +#define NR_syscalls		333
>
>   #define __ARCH_WANT_IPC_PARSE_VERSION
>   #define __ARCH_WANT_OLD_READDIR
> diff --git a/arch/m68k/kernel/entry.S b/arch/m68k/kernel/entry.S
> index 8744f60..c3735cd 100644
> --- a/arch/m68k/kernel/entry.S
> +++ b/arch/m68k/kernel/entry.S
> @@ -755,4 +755,6 @@ sys_call_table:
>   	.long sys_inotify_init1
>   	.long sys_preadv
>   	.long sys_pwritev		/* 330 */
> +	.long sys_rt_tgsigqueueinfo
> +	.long sys_perf_counter_open
>
> diff --git a/arch/m68knommu/kernel/syscalltable.S b/arch/m68knommu/kernel/syscalltable.S
> index c0b8782..0ae123e 100644
> --- a/arch/m68knommu/kernel/syscalltable.S
> +++ b/arch/m68knommu/kernel/syscalltable.S
> @@ -349,6 +349,8 @@ ENTRY(sys_call_table)
>   	.long sys_inotify_init1
>   	.long sys_preadv
>   	.long sys_pwritev		/* 330 */
> +	.long sys_rt_tgsigqueueinfo
> +	.long sys_perf_counter_open
>
>   	.rept NR_syscalls-(.-sys_call_table)/4
>   		.long sys_ni_syscall

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
