Return-Path: <linux-kernel-owner+w=401wt.eu-S1756463AbZAAWwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbZAAWwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 17:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbZAAWwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 17:52:09 -0500
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:10540 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbZAAWwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 17:52:09 -0500
Date: Thu, 1 Jan 2009 23:52:03 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Ingo Brueckl <ib@wupperonline.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: compile time warnings
In-Reply-To: <495d3100@wupperonline.de>
Message-ID: <alpine.LNX.2.00.0901012312450.11772@swampdragon.chaosbits.net>
References: <495d3100@wupperonline.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jan 2009, Ingo Brueckl wrote:

> Maybe somebody noticed already, with kernel 2.6.28 and gcc 4.3.2 there are a
> few compile time warnings:
> 
I've looked at these with the kernel from git as of today. I've only read 
the code, not build it.

>   arch/x86/kernel/setup.c:742: warning: 'dmi_low_memory_corruption' defined but not used
> 
I see dmi_low_memory_corruption() as well as usage of it both inside 
#ifdef CONFIG_X86_RESERVE_LOW_64K - looks fine to me:

#ifdef CONFIG_X86_RESERVE_LOW_64K
static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
{
...
static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
#ifdef CONFIG_X86_RESERVE_LOW_64K
        {
                .callback = dmi_low_memory_corruption,
...


>   arch/x86/mm/init_32.c: In function 'pagetable_init':
>   arch/x86/mm/init_32.c:515: warning: unused variable 'pgd_base'
> 

I see this : 

static void __init pagetable_init(void)
{
        pgd_t *pgd_base = swapper_pg_dir;

        permanent_kmaps_init(pgd_base);
}

pgd_base is very much used...

>   drivers/acpi/tables/tbfadt.c: In function 'acpi_tb_create_local_fadt':
>   /usr/src/linux/arch/x86/include/asm/string_32.h:75: warning: array subscript is above array bounds
> 
>   drivers/usb/core/hcd.c: In function 'usb_hcd_poll_rh_status':
>   /usr/src/linux/arch/x86/include/asm/string_32.h:75: warning: array subscript is above array bounds
> 
Not sure about these.

-- 
Jesper Juhl <jj@chaosbits.net>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html

