Return-Path: <linux-kernel-owner+w=401wt.eu-S1760083AbYFPIGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbYFPIGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 04:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYFPIGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 04:06:34 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54356 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752849AbYFPIGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 04:06:32 -0400
Date: Mon, 16 Jun 2008 03:06:29 -0500
From: Paul Jackson <pj@sgi.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: mingo@elte.hu, tglx@linutronix.de, yhlu.kernel@gmail.com, steiner@sgi.com,
       travis@sgi.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Subject: Re: [PATCH 5/8] x86 boot: remap efi systab runtime from phys to
 virt
Message-Id: <20080616030629.df7afc7a.pj@sgi.com>
In-Reply-To: <1213599759.11185.7.camel@caritas-dev.intel.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
	<20080616063006.14597.73386.sendpatchset@polaris-admin.engr.sgi.com>
	<1213599759.11185.7.camel@caritas-dev.intel.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang wrote:
> >  			efi.systab = (efi_system_table_t *) (unsigned long) systab;
> > +			efi.systab->runtime = __va(efi.systab->runtime);
> >  		}
> >  	}
> 
> Why do you need this?

I need this so that my kernel can callback into EFI runtime services
post-boot.


> This should be done by firmware in
> efi_set_virtual_address_map().

I don't understand this comment.  I don't see any routine named
'efi_set_virtual_address_map()' in the kernel.  I do see virt_*
and phys_* variants of that name; did you mean one of those?

In any case, I don't understand how this could "be done by firmware."
It is the kernel that is mapping in the firmware somehow to support EFI
runtime services.


> And this doesn't work on i386, because
> runtime code/data area may be not in identity map area (that is > 768M).

Ok ... what code should we add for i386?  Would it be code like I see
above in this efi_enter_virtual_mode() routine:

                if (PFN_UP(end) <= max_pfn_mapped)
                        va = __va(md->phys_addr);
                else
                        va = efi_ioremap(md->phys_addr, size);

I could write similar code for remapping efi.systab->runtime, but
I could not test such code -- could you assist me in that?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
