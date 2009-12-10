Return-Path: <linux-kernel-owner+w=401wt.eu-S1760655AbZLJHcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760655AbZLJHcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760519AbZLJHcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:32:20 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:58727 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760646AbZLJHcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:32:19 -0500
Message-ID: <4B20A3E7.70806@monstr.eu>
Date: Thu, 10 Dec 2009 08:31:51 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: steve@digidescorp.com
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] microblaze: nommu: Don't clobber R11 on syscalls
References: <1260400422-2805-1-git-send-email-steve@digidescorp.com>
In-Reply-To: <1260400422-2805-1-git-send-email-steve@digidescorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

steve@digidescorp.com wrote:
> The noMMU syscall trap has a bug that causes R11 to be zero on return to 
> userland. Remove the extra "save" of R11 responsible for the bug.

Can you please look if is even possible to remove that one line below?
( I mean line 212 - lwi	r11, r0, PER_CPU(KM) */
Interrupt rutine don't have it too. I am pretty sure that we can remove 
that line too.

Thanks for testing,
Michal


> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN a/arch/microblaze/kernel/entry-nommu.S b/arch/microblaze/kernel/entry-nommu.S
> --- a/arch/microblaze/kernel/entry-nommu.S	2009-12-09 17:05:11.000000000 -0600
> +++ b/arch/microblaze/kernel/entry-nommu.S	2009-12-09 17:07:31.000000000 -0600
> @@ -208,7 +208,6 @@ ENTRY(_user_exception)
>  	lwi	r1, r1, TS_THREAD_INFO		/* get the thread info */
>  	/* calculate kernel stack pointer */
>  	addik	r1, r1, THREAD_SIZE - PT_SIZE
> -	swi	r11, r0, PER_CPU(R11_SAVE)	/* temporarily save r11 */
>  	lwi	r11, r0, PER_CPU(KM)		/* load mode indicator */
>  2:
>  	swi	r11, r1, PT_MODE		/* store the mode */
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
