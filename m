Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbZDSJrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbZDSJrp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 05:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZDSJrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 05:47:36 -0400
Received: from mail-bw0-f211.google.com ([209.85.218.211]:54892 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZDSJrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 05:47:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RvpX5lKmn6j3lH48lhQjNISCKIJcd1RmMJYR3agovz/R7AsrK7arIFhuSkWO78OuAh
         rsUv0rDpIQXziL6maense2qCK8ltlbWpMO6gJ+GTALWcycMDZ629OdxTi3zdVyfbLUv0
         md2RichzGeLyUn/qaarMfmRWJJI0bBWzJq8UI=
Message-ID: <49EAF31C.8020108@gmail.com>
Date: Sun, 19 Apr 2009 11:47:08 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rakib.mullick@gmail.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Fix false positive section mismatch warnings
 in the apic code
References: <b9df5fa10904181941u4a73fc97i80dfa90a50b8daf5@mail.gmail.com> <tip-aa57a15ad17d284e62fbd24cf7e0eb628b2cb3f7@git.kernel.org>
In-Reply-To: <tip-aa57a15ad17d284e62fbd24cf7e0eb628b2cb3f7@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for Rakib Mullick pisze:
> Commit-ID:  aa57a15ad17d284e62fbd24cf7e0eb628b2cb3f7
> Gitweb:     http://git.kernel.org/tip/aa57a15ad17d284e62fbd24cf7e0eb628b2cb3f7
> Author:     Rakib Mullick <rakib.mullick@gmail.com>
> AuthorDate: Sun, 19 Apr 2009 08:41:17 +0600
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sun, 19 Apr 2009 11:28:18 +0200
> 
> x86: Fix false positive section mismatch warnings in the apic code
> 
> find_unisys_acpi_oem_table() and unmap_unisys_acpi_oem_table() are non
> init functions, but these functions calls some init functions. But we
> need these functions as non-init functions.

Why? This warning seems to be valid.

> 
> So annotate them via __ref.
> 
> The following false positive warnings are fixed via this:
> 
>   WARNING: vmlinux.o(.text+0x16250): Section mismatch in reference from
>   the function find_unisys_acpi_oem_table() to the function
>   .init.text:early_acpi_os_unmap_memory()
>   The function find_unisys_acpi_oem_table() references
>   the function __init early_acpi_os_unmap_memory().
>   This is often because find_unisys_acpi_oem_table lacks a __init
>   annotation or the annotation of early_acpi_os_unmap_memory is wrong.
> 
>   WARNING: vmlinux.o(.text+0x16269): Section mismatch in reference from
>   the function find_unisys_acpi_oem_table() to the function
>   .init.text:early_acpi_os_unmap_memory()
>   The function find_unisys_acpi_oem_table() references
>   the function __init early_acpi_os_unmap_memory().
>   This is often because find_unisys_acpi_oem_table lacks a __init
>   annotation or the annotation of early_acpi_os_unmap_memory is wrong.
> 
>   WARNING: vmlinux.o(.text+0x16279): Section mismatch in reference from
>   the function find_unisys_acpi_oem_table() to the function
>   .init.text:__acpi_map_table()
>   The function find_unisys_acpi_oem_table() references
>   the function __init __acpi_map_table().
>   This is often because find_unisys_acpi_oem_table lacks a __init
>   annotation or the annotation of __acpi_map_table is wrong.
> 
>   WARNING: vmlinux.o(.text+0x16297): Section mismatch in reference from
>   the function unmap_unisys_acpi_oem_table() to the function
>   .init.text:__acpi_unmap_table()
>   The function unmap_unisys_acpi_oem_table() references
>   the function __init __acpi_unmap_table().
>   This is often because unmap_unisys_acpi_oem_table lacks a __init
>   annotation or the annotation of __acpi_unmap_table is wrong.
> 
> [ Impact: annotate away section mismatch warnings ]
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> LKML-Reference: <b9df5fa10904181941u4a73fc97i80dfa90a50b8daf5@mail.gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  arch/x86/kernel/apic/es7000_32.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
> index 1c11b81..96c150c 100644
> --- a/arch/x86/kernel/apic/es7000_32.c
> +++ b/arch/x86/kernel/apic/es7000_32.c
> @@ -254,7 +254,7 @@ static int parse_unisys_oem(char *oemptr)
>  }
>  
>  #ifdef CONFIG_ACPI
> -static int find_unisys_acpi_oem_table(unsigned long *oem_addr)
> +static int __ref find_unisys_acpi_oem_table(unsigned long *oem_addr)
>  {
>  	struct acpi_table_header *header = NULL;
>  	struct es7000_oem_table *table;
> @@ -285,7 +285,7 @@ static int find_unisys_acpi_oem_table(unsigned long *oem_addr)
>  	return 0;
>  }
>  
> -static void unmap_unisys_acpi_oem_table(unsigned long oem_addr)
> +static void __ref unmap_unisys_acpi_oem_table(unsigned long oem_addr)
>  {
>  	if (!oem_addr)
>  		return;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

