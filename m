Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbXG1OEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbXG1OEB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 10:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbXG1ODv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 10:03:51 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:35710 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbXG1ODu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 10:03:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lZIHEX4f3pHYFSyNDpw0EMDku/+OO9eMp8jUep6h6HdTAldry0qWOVGzGAIEYqlpZOhiLUuMpRs/Yptvmefu+V93fmHxj9PIxUOYiHQl8R58Jh+hd9Z9ZqVrDDAmhvuCW6lRkNBUAOmbZZ++3HphKuJ5MHd030qkK1ucrosaySw=
Message-ID: <64bb37e0707280703u42833adbje0ca9b4a2423d6c5@mail.gmail.com>
Date: Sat, 28 Jul 2007 16:03:49 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc1-mm1
Cc: "Len Brown" <lenb@kernel.org>, "Cedric Le Goater" <clg@fr.ibm.com>,
       linux-kernel@vger.kernel.org, "Shaohua Li" <shaohua.li@intel.com>,
       linux-mm@kvack.org
In-Reply-To: <64bb37e0707261054j25691afnb1bbf3484af855f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070725040304.111550f4.akpm@linux-foundation.org>
	 <46A7411C.80202@fr.ibm.com> <200707251323.04594.lenb@kernel.org>
	 <20070725115804.5b8efe83.akpm@linux-foundation.org>
	 <64bb37e0707251213t6edcb0a5sabcf4a923c19bde7@mail.gmail.com>
	 <64bb37e0707251322w38d19814pacea61d8cf69be63@mail.gmail.com>
	 <20070725133655.849574b5.akpm@linux-foundation.org>
	 <64bb37e0707251452u6bca43b6i2618bf6e54972dbc@mail.gmail.com>
	 <20070726002543.de303fd7.akpm@linux-foundation.org>
	 <64bb37e0707261054j25691afnb1bbf3484af855f3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/26/07, Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> DISCONTIGMEM+SLUB:
> [   39.833272] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> [   40.016659] Kernel panic - not syncing: IO-APIC + timer doesn't
> work! Try using the 'noapic' kernel parameter
> DISCONTIGMEM+SLAB:
> Boots until it can't find / because I didn't append the correct initrd
> It also hit the MP-BIOS bug, but was not bothered by it:
> [   36.696965] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> [   36.880537] Using local APIC timer interrupts.
> [   36.932215] result 12500283
> [   36.940581] Detected 12.500 MHz APIC timer.
>
> So I think, I will postpone SPARSEMEM until -mm2, as there are seem to
> be some problems in that area (Re: 2.6.23-rc1-mm1 sparsemem_vmemamp
> fix)
>
> But maybee I will get SLUB to work. ;)

SLUB works, if I reboot (Alt+SysRq+B) from a 2.6.22-rc6-mm1 kernel.

Otherwise it will panic with IO-APIC + timer not working.

Differences in dmesg
2.6.22-rc6-mm1 has:
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
and
[    0.000000] ACPI: BIOS IRQ0 pin2 override ignored.
and
[    0.000000] TSC calibrated against PM_TIMER

 23-rc1-mm1 has:
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
and
[   37.340319] ..MP-BIOS bug: 8254 timer not connected to IO-APIC

I did not need to use acpi_use_timer_override with the older kernel.

Do you need more info about my board/ BIOS/ ACPI tables?

After the warm-boot trick 2.6.23-rc1-mm1 seems stable right now...

Torsten
