Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378AbZJ3A5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbZJ3A5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 20:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbZJ3A5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 20:57:34 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:44629 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754160AbZJ3A5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 20:57:33 -0400
Message-ID: <4AEA39EB.50601@snapgear.com>
Date: Fri, 30 Oct 2009 10:57:15 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tim Abbott <tabbott@ksplice.com>
CC: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v4 1/7] m68knommu: Don't hardcode the value of PAGE_SIZE
 in the linker script.
References: <alpine.DEB.1.10.0910142041520.6638@dr-wily.mit.edu> <1255886635-17371-1-git-send-email-tabbott@ksplice.com>
In-Reply-To: <1255886635-17371-1-git-send-email-tabbott@ksplice.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

This one gives me:

arch/m68knommu/kernel/vmlinux.lds.S:19:1: warning: "BSS" redefined
In file included from arch/m68knommu/kernel/vmlinux.lds.S:10:
include/asm-generic/vmlinux.lds.h:495:1: warning: this is the location 
of the previous definition

A define named "BSS" is already used inside of vmlinux.lds.S.
No big deal, I just changed that internal one.

But otherwise no problems with this patch.

Regards
Greg



Tim Abbott wrote:
> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> ---
>  arch/m68knommu/kernel/vmlinux.lds.S |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
> index 2736a5e..edc20bd 100644
> --- a/arch/m68knommu/kernel/vmlinux.lds.S
> +++ b/arch/m68knommu/kernel/vmlinux.lds.S
> @@ -8,6 +8,7 @@
>   */
>  
>  #include <asm-generic/vmlinux.lds.h>
> +#include <asm/page.h>
>  
>  #if defined(CONFIG_RAMKERNEL)
>  #define	RAM_START	CONFIG_KERNELBASE
> @@ -155,7 +156,7 @@ SECTIONS {
>  	} > DATA
>  
>  	.init : {
> -		. = ALIGN(4096);
> +		. = ALIGN(PAGE_SIZE);
>  		__init_begin = .;
>  		_sinittext = .;
>  		INIT_TEXT
> @@ -180,7 +181,7 @@ SECTIONS {
>  		*(.init.ramfs)
>  		__initramfs_end = .;
>  #endif
> -		. = ALIGN(4096);
> +		. = ALIGN(PAGE_SIZE);
>  		__init_end = .;
>  	} > INIT
>  

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
