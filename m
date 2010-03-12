Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab0CLIxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 03:53:38 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:53467 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678Ab0CLIxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 03:53:37 -0500
Message-ID: <4B9A010C.2010501@monstr.eu>
Date: Fri, 12 Mar 2010 09:53:32 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Arun Bhanu <arun@bhanu.net>
CC: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH] microblaze: Fix Makefile to delete build generated files
References: <1268383016-18270-1-git-send-email-arun@bhanu.net>
In-Reply-To: <1268383016-18270-1-git-send-email-arun@bhanu.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arun Bhanu wrote:
> 'make mrproper' does not to delete the following build generated files:
>        arch/microblaze/boot/linux.bin.ub
>        arch/microblaze/boot/simpleImage.system
>        arch/microblaze/boot/simpleImage.system.ub
> 
> Fix the Makefile to delete these build generated files.

The problem is that if you run make clean it will delete all simpleImage 
files too. The best will be just delete them if you run make mrproper as 
you wrote above. Make clean should keep them or just remove .unstrip 
because of size.

Michal


> 
> Signed-off-by: Arun Bhanu <arun@bhanu.net>
> ---
>  arch/microblaze/boot/Makefile |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
> index 902cf98..73a3263 100644
> --- a/arch/microblaze/boot/Makefile
> +++ b/arch/microblaze/boot/Makefile
> @@ -62,6 +62,6 @@ quiet_cmd_dtc = DTC     $@
>  $(obj)/%.dtb: $(dtstree)/%.dts FORCE
>  	$(call if_changed,dtc)
>  
> -clean-kernel += linux.bin linux.bin.gz simpleImage.*
> +clean-kernel += linux.bin linux.bin.gz
>  
> -clean-files += *.dtb simpleImage.*.unstrip
> +clean-files += *.dtb *.ub simpleImage.*


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
