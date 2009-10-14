Return-Path: <linux-kernel-owner+w=401wt.eu-S1751912AbZJNEmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbZJNEmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 00:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZJNEml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 00:42:41 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:47490 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751669AbZJNEml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 00:42:41 -0400
Message-ID: <4AD55682.7060502@snapgear.com>
Date: Wed, 14 Oct 2009 14:41:38 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tim Abbott <tabbott@ksplice.com>
CC: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v3 6/7] m68knommu: Move __init_end out of the .init section.
References: <4AD3BFD8.90408@snapgear.com> <1255397413-4862-1-git-send-email-tabbott@ksplice.com> <1255397413-4862-2-git-send-email-tabbott@ksplice.com> <1255397413-4862-3-git-send-email-tabbott@ksplice.com> <1255397413-4862-4-git-send-email-tabbott@ksplice.com> <1255397413-4862-5-git-send-email-tabbott@ksplice.com> <1255397413-4862-6-git-send-email-tabbott@ksplice.com> <1255397413-4862-7-git-send-email-tabbott@ksplice.com>
In-Reply-To: <1255397413-4862-7-git-send-email-tabbott@ksplice.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

Tim Abbott wrote:
> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> ---
>  arch/m68knommu/kernel/vmlinux.lds.S |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
> index 73fe172..49d5c4d 100644
> --- a/arch/m68knommu/kernel/vmlinux.lds.S
> +++ b/arch/m68knommu/kernel/vmlinux.lds.S
> @@ -169,6 +169,8 @@ SECTIONS {
>  		CON_INITCALL
>  		SECURITY_INITCALL
>  		INIT_RAM_FS
> +	} > INIT
> +	.init_end : {
>  		. = ALIGN(PAGE_SIZE);
>  		__init_end = .;
>  	} > INIT


After applying this I can no longer boot.

Resulting headers for vmlinux are:

vmlinux:     file format elf32-m68k

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
   0 .text         00125ff0  40020000  40020000  00002000  2**4
                   CONTENTS, ALLOC, LOAD, READONLY, CODE
   1 .data         00012010  40145ff0  40145ff0  00127ff0  2**4
                   CONTENTS, ALLOC, LOAD, DATA
   2 .init         0000b608  40158000  40158000  0013a000  2**2
                   CONTENTS, ALLOC, LOAD, CODE
   3 .init_end     000009f8  40163608  40163608  00145608  2**0
                   ALLOC
   4 .bss          0000a9ec  40164000  40164000  00145608  2**4
                   ALLOC
   5 .comment      00001c56  00000000  00000000  00145608  2**0
                   CONTENTS, READONLY


Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
