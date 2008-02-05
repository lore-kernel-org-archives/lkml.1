Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbYBEM7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbYBEM7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 07:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbYBEM7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 07:59:17 -0500
Received: from homer.mvista.com ([63.81.120.155]:11730 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751060AbYBEM7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 07:59:17 -0500
Message-ID: <47A85DD8.4080300@ru.mvista.com>
Date: Tue, 05 Feb 2008 16:00:08 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, linuxppc-dev@ozlabs.org,
       bwalle@suse.de, paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-mm1: ppc32: too few arguments to function 'reserve_bootmem'
References: <20080203171634.58ab668b.akpm@linux-foundation.org>	<200802042129.03065.m.kozlowski@tuxland.pl> <20080204144036.cf22a402.akpm@linux-foundation.org>
In-Reply-To: <20080204144036.cf22a402.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Andrew Morton wrote:

>>	This is from ppc32:

>>  CC      arch/powerpc/mm/mem.o
>>arch/powerpc/mm/mem.c: In function 'do_init_bootmem':
>>arch/powerpc/mm/mem.c:256: error: too few arguments to function 'reserve_bootmem'
>>arch/powerpc/mm/mem.c:261: error: too few arguments to function 'reserve_bootmem'

>>Leftover from introduce-flags-for-reserve_bootmem.patch?

> Yes, I've had to fix that patch many times.

> --- a/arch/powerpc/mm/mem.c~introduce-flags-for-reserve_bootmem-powerpc-fix
> +++ a/arch/powerpc/mm/mem.c
> @@ -253,12 +253,13 @@ void __init do_init_bootmem(void)
>  				     lmb_size_bytes(&lmb.reserved, i) - 1;
>  		if (addr < total_lowmem)
>  			reserve_bootmem(lmb.reserved.region[i].base,
> -					lmb_size_bytes(&lmb.reserved, i));
> +					lmb_size_bytes(&lmb.reserved, i),
> +					BOOTMEM_DEFAULT);
>  		else if (lmb.reserved.region[i].base < total_lowmem) {
>  			unsigned long adjusted_size = total_lowmem -
>  				      lmb.reserved.region[i].base;
>  			reserve_bootmem(lmb.reserved.region[i].base,
> -					adjusted_size);
> +					adjusted_size, BOOTMEM_DWEFAULT);

    BOOTMEM_DWEFAULT, are you sure? :-)

WBR, Sergei
