Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbXEIRWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbXEIRWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 13:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbXEIRWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 13:22:10 -0400
Received: from gra-lx1.iram.es ([150.214.224.41]:38530 "EHLO gra-lx1.iram.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362AbXEIRWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 13:22:09 -0400
X-Greylist: delayed 1842 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 May 2007 13:22:09 EDT
From: Gabriel Paubert <paubert@iram.es>
Date: Wed, 9 May 2007 18:51:15 +0200
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, ppc-dev <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>, paulus@samba.org
Subject: Section mismatch warnings (was Re: [PATCH] early_pfn_to_nid needs to be __meminit)
Message-ID: <20070509165115.GA23576@iram.es>
References: <20070510022552.4bb1a407.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510022552.4bb1a407.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 02:25:52AM +1000, Stephen Rothwell wrote:
> since it is referenced by memmap_init_zone (which is __meminit) via the
> early_pfn_in_nid macro when CONFIG_NODES_SPAN_OTHER_NODES is set (which
> basically means PowerPC 64).
> 
> This removes a section mismatch warning in those circumstances.

Speaking of this, I just tried to compile an official (Linus' git tree) 
kernel for my old PMac G4 and I get a lot of section mismatch warnings at 
the end of the compilation:

  LD      vmlinux
  SYSMAP  System.map
  SYSMAP  .tmp_System.map
  MODPOST vmlinux
WARNING: "fee_restarts" [arch/powerpc/kernel/built-in] is COMMON symbol
WARNING: "ee_restarts" [arch/powerpc/kernel/built-in] is COMMON symbol
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .init.data:.got2 from dt_string_start (offset 0x8)
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .init.data:.got2 from dt_string_end (offset 0xc)
...
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .init.data:.got2 from dt_struct_end (offset 0x20c)
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .init.data:.got2 from disp_BAT (offset 0x234)
WARNING: "primary_pteg_full" [arch/powerpc/mm/built-in] is COMMON symbol
WARNING: "next_slot" [arch/powerpc/mm/built-in] is COMMON symbol
WARNING: "htab_hash_searches" [arch/powerpc/mm/built-in] is COMMON symbol
WARNING: arch/powerpc/mm/built-in.o - Section mismatch: reference to .init.text:early_get_page from .text between 'pte_alloc_one_kernel' (at offset 0xf50) and 'v_mapped_by_bats'
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to .init.data:.got2 from  (offset 0x0)
...
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to .init.text:pmac_pcibios_after_init from .machine.desc after 'mach_powermac' (at offset 0xc4)
WARNING: mm/built-in.o - Section mismatch: reference to .init.text:set_up_list3s from .text between 'kmem_cache_create' (at
offset 0x1de88) and 'kmem_cache_shrink'
WARNING: mm/built-in.o - Section mismatch: reference to .init.text:set_up_list3s from .text between 'kmem_cache_create' (at
offset 0x1dec0) and 'kmem_cache_shrink'

I find these 50 or so warnings so scary that I've not yet tried 
to boot the kernel. Note that this is a non-modular kernel.

	Gabriel
