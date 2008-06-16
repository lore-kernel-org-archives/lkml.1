Return-Path: <linux-kernel-owner+w=401wt.eu-S1760773AbYFPIYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773AbYFPIYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 04:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbYFPIY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 04:24:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:3205 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbYFPIY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 04:24:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,651,1204531200"; 
   d="scan'208";a="261009062"
Subject: Re: [PATCH 5/8] x86 boot: remap efi systab runtime from phys to
	virt
From: "Huang, Ying" <ying.huang@intel.com>
To: Paul Jackson <pj@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, yhlu.kernel@gmail.com, steiner@sgi.com,
       travis@sgi.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
In-Reply-To: <20080616030629.df7afc7a.pj@sgi.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
	 <20080616063006.14597.73386.sendpatchset@polaris-admin.engr.sgi.com>
	 <1213599759.11185.7.camel@caritas-dev.intel.com>
	 <20080616030629.df7afc7a.pj@sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 16 Jun 2008 16:27:08 +0800
Message-Id: <1213604828.12968.7.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 16 Jun 2008 08:24:11.0540 (UTC) FILETIME=[5AC5AD40:01C8CF8A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-16 at 03:06 -0500, Paul Jackson wrote:
> Huang wrote:
> > >  			efi.systab = (efi_system_table_t *) (unsigned long) systab;
> > > +			efi.systab->runtime = __va(efi.systab->runtime);
> > >  		}
> > >  	}
> > 
> > Why do you need this?
> 
> I need this so that my kernel can callback into EFI runtime services
> post-boot.
> 
> 
> > This should be done by firmware in
> > efi_set_virtual_address_map().
> 
> I don't understand this comment.  I don't see any routine named
> 'efi_set_virtual_address_map()' in the kernel.  I do see virt_*
> and phys_* variants of that name; did you mean one of those?

I mean the EFI runtime service SetVirtualAddressMap() in spec.

> In any case, I don't understand how this could "be done by firmware."
> It is the kernel that is mapping in the firmware somehow to support EFI
> runtime services.

This should be done in firmware. That is, the EFI system table:
efi.systab and runtime services table: efi.systab->runtime) will be
updated in SetVirtualAddressMap() by firmware. This is specified in
UEFI2.1 spec: Unified Extensible Firmware Interface Specification,
section 7.4 Virtual Memory Services. If the firmware does not do that
for you, please report bug to firmware vendor.

Your patch makes Linux kernel doesn't work on machine with proper
firmware, because the effect is like __va(__va(phys_ptr)).

Best Regards,
Huang Ying

