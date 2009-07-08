Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbZGHViU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbZGHViU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 17:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756271AbZGHViJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 17:38:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52432 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbZGHViH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:38:07 -0400
Message-ID: <4A551184.1020707@zytor.com>
Date: Wed, 08 Jul 2009 14:37:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 08/12] SFI, x86: hook e820() for memory map initialization
References: <1247026438-20891-1-git-send-email-lenb@kernel.org> <5bf6b3c7c08a76ea8dc52e9e07728c2958938952.1247025117.git.len.brown@intel.com>
In-Reply-To: <5bf6b3c7c08a76ea8dc52e9e07728c2958938952.1247025117.git.len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bothers me... we keep saying that memory map initialization belongs
to the boot loader, and yet we keep doing the opposite.  This isn't just
an arbitrary difference, either: it is pretty essential to being able to
use the early range allocator safely.

	-hpa


Len Brown wrote:
> From: Feng Tang <feng.tang@intel.com>
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  arch/x86/kernel/e820.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index c4ca89d..e399d0e 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -20,6 +20,7 @@
>  #include <linux/pfn.h>
>  #include <linux/suspend.h>
>  #include <linux/firmware-map.h>
> +#include <linux/sfi.h>
>  
>  #include <asm/pgtable.h>
>  #include <asm/page.h>
> @@ -1437,6 +1438,10 @@ char *__init default_machine_specific_memory_setup(void)
>  	  < 0) {
>  		u64 mem_size;
>  
> +		/* if SFI mmap table exists, use SFI to setup e820 mmap */
> +		if (!sfi_init_memory_map())
> +			return "SFI";
> +
>  		/* compare results from other methods and take the greater */
>  		if (boot_params.alt_mem_k
>  		    < boot_params.screen_info.ext_mem_k) {

