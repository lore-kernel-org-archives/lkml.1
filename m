Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZJMF5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZJMF5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 01:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755147AbZJMF5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 01:57:00 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:60670 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752461AbZJMF47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 01:56:59 -0400
Message-ID: <4AD4166C.5090306@snapgear.com>
Date: Tue, 13 Oct 2009 15:55:56 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tim Abbott <tabbott@ksplice.com>
CC: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v3 4/7] m68knommu: Use more macros inside the .init section.
References: <4AD3BFD8.90408@snapgear.com> <1255397413-4862-1-git-send-email-tabbott@ksplice.com> <1255397413-4862-2-git-send-email-tabbott@ksplice.com> <1255397413-4862-3-git-send-email-tabbott@ksplice.com> <1255397413-4862-4-git-send-email-tabbott@ksplice.com> <1255397413-4862-5-git-send-email-tabbott@ksplice.com>
In-Reply-To: <1255397413-4862-5-git-send-email-tabbott@ksplice.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

Tim Abbott wrote:
> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> ---
>  arch/m68knommu/kernel/vmlinux.lds.S |   23 +++++------------------
>  1 files changed, 5 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
> index 153569b..f7df82a 100644
> --- a/arch/m68knommu/kernel/vmlinux.lds.S
> +++ b/arch/m68knommu/kernel/vmlinux.lds.S
> @@ -161,25 +161,12 @@ SECTIONS {
>  		INIT_TEXT
>  		_einittext = .;
>  		INIT_DATA
> -		. = ALIGN(16);
> -		__setup_start = .;
> -		*(.init.setup)
> -		__setup_end = .;
> -		__initcall_start = .;
> +		INIT_SETUP(16)
> +		INIT_CALL
                 ^^^^^^^^^^
I take it this should be INIT_CALLS?


>  		INITCALLS
> -		__initcall_end = .;
> -		__con_initcall_start = .;
> -		*(.con_initcall.init)
> -		__con_initcall_end = .;
> -		__security_initcall_start = .;
> -		*(.security_initcall.init)
> -		__security_initcall_end = .;
> -#ifdef CONFIG_BLK_DEV_INITRD
> -		. = ALIGN(4);
> -		__initramfs_start = .;
> -		*(.init.ramfs)
> -		__initramfs_end = .;
> -#endif
> +		CON_INITCALL
> +		SECURITY_INITCALL
> +		INIT_RAM_FS
>  		. = ALIGN(PAGE_SIZE);
>  		__init_end = .;
>  	} > INIT


With this patch applied the kernel no longer boots. All previous
patches (so 1, 2 and 3) applied run fine.

Headers list:

vmlinux:     file format elf32-m68k

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
   0 .text         00125ff0  40020000  40020000  00002000  2**4
                   CONTENTS, ALLOC, LOAD, READONLY, CODE
   1 .data         00012010  40145ff0  40145ff0  00127ff0  2**4
                   CONTENTS, ALLOC, LOAD, DATA
   2 .init         0000c000  40158000  40158000  0013a000  2**2
                   CONTENTS, ALLOC, LOAD, CODE
   3 .bss          0000a9ec  40164000  40164000  00146000  2**4
                   ALLOC
   4 .comment      00001c56  00000000  00000000  00146000  2**0
                   CONTENTS, READONLY

I haven't debugged any further...

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
