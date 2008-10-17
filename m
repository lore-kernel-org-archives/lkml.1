Return-Path: <linux-kernel-owner+w=401wt.eu-S1757952AbYJQSKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbYJQSKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 14:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbYJQSKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 14:10:39 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46380 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756778AbYJQSKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 14:10:39 -0400
Subject: Re: 2.6.27-git7 compile error (ppc)
From: Badari Pulavarty <pbadari@gmail.com>
To: LinuxPPC-dev <linuxppc-dev@ozlabs.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1224265634.15582.3.camel@badari-desktop>
References: <1224265634.15582.3.camel@badari-desktop>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 11:11:13 -0700
Message-Id: <1224267073.15582.8.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-17 at 10:47 -0700, Badari Pulavarty wrote:
> Hi,
> 
> I get this following compile error on my ppc box.
> 
> Let me know if its a known issue. Otherwise, I can figure out
> whats happening.
> 
> Thanks,
> Badari

This is due to recent changes to move phys_add_t definition from
arch/powerpc/include/asm/types.h to include/linux/types.h.

arch/powerpc/include/asm/page.h needs phys_addr_t for
CONFIG_RELOCATABLE. Needs fixing..

Thanks,
Badari

> 
>   CC      arch/powerpc/mm/slb.o
> In file included from /usr/src/linux-2.6.27/arch/powerpc/include/asm/mmu-hash64.h:16,
>                  from /usr/src/linux-2.6.27/arch/powerpc/include/asm/mmu.h:7,
>                  from /usr/src/linux-2.6.27/arch/powerpc/include/asm/pgtable.h:7,
>                  from arch/powerpc/mm/slb.c:19:
> /usr/src/linux-2.6.27/arch/powerpc/include/asm/page.h:76: error: parse error before "memstart_addr"
> /usr/src/linux-2.6.27/arch/powerpc/include/asm/page.h:76: warning: type defaults to `int' in declaration of `memstart_addr'
> /usr/src/linux-2.6.27/arch/powerpc/include/asm/page.h:76: warning: data definition has no type or storage class
> /usr/src/linux-2.6.27/arch/powerpc/include/asm/page.h:77: error: parse error before "kernstart_addr"
> /usr/src/linux-2.6.27/arch/powerpc/include/asm/page.h:77: warning: type defaults to `int' in declaration of `kernstart_addr'
> /usr/src/linux-2.6.27/arch/powerpc/include/asm/page.h:77: warning: data definition has no type or storage class
>   AS      arch/powerpc/lib/string.o
>   CC      arch/powerpc/lib/alloc.o
>   CALL    arch/powerpc/kernel/systbl_chk.sh
>   CC      arch/powerpc/kernel/sysfs.o
> make[1]: *** [arch/powerpc/mm/slb.o] Error 1
> make: *** [arch/powerpc/mm] Error 2
> make: *** Waiting for unfinished jobs....
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

