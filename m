Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab0BBXRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 18:17:13 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:40684 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122Ab0BBXRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 18:17:11 -0500
Date: Tue, 2 Feb 2010 16:17:10 -0700
From: Alex Chiang <achiang@hp.com>
To: lenb@kernel.org, venkatesh.pallipadi@intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] ACPI: processor driver vs. core
Message-ID: <20100202231710.GA24718@ldl.fc.hp.com>
References: <20100125213221.28510.74078.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100125213221.28510.74078.stgit@bob.kio>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Venki,

Do you have any opinions on this patchset? If so, I'd like to
address them.

Thanks,
/ac

* Alex Chiang <achiang@hp.com>:
> This series cleans up some of the mess I made when introducing
> early _PDC.
> 
> The major change is renaming processor_core.c to processor_driver.c,
> and then renaming processor_pdc.c to processor_core.c.
> 
> The idea is that the code in processor_core.c will always be built
> statically into the kernel (as long as ACPI is configured), while
> allowing the ACPI processor driver to remain modular (if so desired).
> 
> We do this because part of the cleanups involves teaching the
> early _PDC evaluation code how to determine if a processor is
> physically present or not -- aka enumeration -- and that sort
> of code doesn't really belong in a file named processor_pdc.
> 
> There are quite a few checkpatch errors in the first rename patch,
> and I'll look at cleaning those up in a later series.
> 
> /ac
> 
> ---
> 
> Alex Chiang (12):
>       ACPI: processor: mv processor_core.c processor_driver.c
>       ACPI: processor: mv processor_pdc.c processor_core.c
>       ACPI: processor: export acpi_get_cpuid()
>       ACPI: processor: move acpi_get_cpuid into processor_core.c
>       ACPI: processor: add internal processor_physically_present()
>       ACPI: processor: remove early _PDC optin quirks
>       ACPI: processor: driver doesn't need to evaluate _PDC
>       ACPI: processor: refactor internal map_lapic_id()
>       ACPI: processor: refactor internal map_x2apic_id()
>       ACPI: processor: refactor internal map_lsapic_id()
>       ACPI: processor: push file static MADT pointer into internal map_madt_entry()
>       ACPI: processor core: style and sparse cleanups
> 
> 
>  Documentation/kernel-parameters.txt |    4 
>  arch/ia64/kernel/acpi.c             |    3 
>  arch/x86/kernel/acpi/boot.c         |    3 
>  drivers/acpi/Makefile               |    4 
>  drivers/acpi/processor_core.c       | 1149 +++++------------------------------
>  drivers/acpi/processor_driver.c     |  976 ++++++++++++++++++++++++++++++
>  drivers/acpi/processor_pdc.c        |  209 ------
>  include/acpi/processor.h            |   10 
>  8 files changed, 1172 insertions(+), 1186 deletions(-)
>  create mode 100644 drivers/acpi/processor_driver.c
>  delete mode 100644 drivers/acpi/processor_pdc.c
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
