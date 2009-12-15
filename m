Return-Path: <linux-kernel-owner+w=401wt.eu-S1757005AbZLOHYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbZLOHYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 02:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbZLOHYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 02:24:42 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51472 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbZLOHYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 02:24:42 -0500
Message-ID: <4B273991.6040802@monstr.eu>
Date: Tue, 15 Dec 2009 08:24:01 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: steve@digidescorp.com
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] microblaze: nommu: Don't clobber R11 on syscalls
References: <1260829458-7503-1-git-send-email-steve@digidescorp.com>
In-Reply-To: <1260829458-7503-1-git-send-email-steve@digidescorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

steve@digidescorp.com wrote:
> The noMMU syscall trap has a bug that causes R11 to be zero on return to 
> userland. Remove the extra "save" of R11 responsible for the bug, as well
> as an unnecessary extra "load".

It seems to me that this patch means that you tested it.
But anyway I was pretty sure that I am right that's why I did this 
change myself. This patch is already in Linus tree.

Thanks for test,
Michal

> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN a/arch/microblaze/kernel/entry-nommu.S b/arch/microblaze/kernel/entry-nommu.S
> --- a/arch/microblaze/kernel/entry-nommu.S	2009-12-09 17:05:11.000000000 -0600
> +++ b/arch/microblaze/kernel/entry-nommu.S	2009-12-14 11:29:37.000000000 -0600
> @@ -208,8 +208,6 @@ ENTRY(_user_exception)
>  	lwi	r1, r1, TS_THREAD_INFO		/* get the thread info */
>  	/* calculate kernel stack pointer */
>  	addik	r1, r1, THREAD_SIZE - PT_SIZE
> -	swi	r11, r0, PER_CPU(R11_SAVE)	/* temporarily save r11 */
> -	lwi	r11, r0, PER_CPU(KM)		/* load mode indicator */
>  2:
>  	swi	r11, r1, PT_MODE		/* store the mode */
>  	lwi	r11, r0, PER_CPU(R11_SAVE)	/* reload r11 */
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
