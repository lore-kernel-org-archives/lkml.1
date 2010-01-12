Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087Ab0ALWrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0ALWrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 17:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683Ab0ALWrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 17:47:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:4878 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab0ALWrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 17:47:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,264,1262592000"; 
   d="scan'208";a="586593644"
Subject: Re: [PATCH] Make Intel 8-way Xeons boot again
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "ananth@in.ibm.com" <ananth@in.ibm.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       Gary Hade <garyhade@us.ibm.com>,
       Chris McDermott <lcm@linux.vnet.ibm.com>
In-Reply-To: <20100110023015.GA2253@in.ibm.com>
References: <20100109101038.GA17555@in.ibm.com>
	 <86802c441001091313y1f64f011t616f08cd282a7123@mail.gmail.com>
	 <20100110023015.GA2253@in.ibm.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 12 Jan 2010 14:46:00 -0800
Message-Id: <1263336361.2854.851.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-09 at 18:30 -0800, Ananth N Mavinakayanahalli wrote:
> Linux version 2.6.33-rc3-bsect (ananth@llm69.in.ibm.com) (gcc version 4.1.2 20080704 (Red Hat 4.1.2-46)) #1 SMP Sun Jan 10 07:36:02 IST 2010
> Command line: ro root=LABEL=/ rhgb console=tty0 console=ttyS0,9600n1 apic=debug
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009bc00 (usable)
>  BIOS-e820: 000000000009bc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 00000000bff4b480 (usable)
>  BIOS-e820: 00000000bff4b480 - 00000000bff57b40 (ACPI data)
>  BIOS-e820: 00000000bff57b40 - 00000000c0000000 (reserved)
>  BIOS-e820: 00000000d0000000 - 00000000e0000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
>  BIOS-e820: 0000000100000000 - 0000000840000000 (usable)
> NX (Execute Disable) protection: active
> DMI 2.4 present.
> No AGP bridge found
> last_pfn = 0x840000 max_arch_pfn = 0x400000000
> x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> last_pfn = 0xbff4b max_arch_pfn = 0x400000000
> Scan SMP from ffff880000000000 for 1024 bytes.
> Scan SMP from ffff88000009fc00 for 1024 bytes.
> Scan SMP from ffff8800000f0000 for 65536 bytes.
> Scan SMP from ffff88000009bc00 for 1024 bytes.
> found SMP MP-table at [ffff88000009bd40] 9bd40
>   mpc: 9d920-9dc84
> init_memory_mapping: 0000000000000000-00000000bff4b000
> init_memory_mapping: 0000000100000000-0000000840000000
> RAMDISK: 37d4d000 - 37fef9e3
> ACPI: RSDP 000000000009bde0 00014 (v00 M   IB)
> ACPI: RSDT 00000000bff57ac0 00044 (v01 IBM    EXA01ZEU 00001000 IBM  45444F43)
> ACPI: FACP 00000000bff57900 000F4 (v03 IBM    EXA01ZEU 00001000 IBM  45444F43)
> ACPI: DSDT 00000000bff4b480 021B5 (v01 IBM    EXA01ZEU 00001000 INTL 20060707)
> ACPI: FACS 00000000bff53780 00040
> ACPI: APIC 00000000bff57800 000F4 (v01 IBM    EXA01ZEU 00001000 IBM  45444F43)

Ananth, This is an IBM EXA system using hurricane chipset.

And from http://www.redbooks.ibm.com/redbooks/pdfs/sg247630.pdf page
106, what is referred to as "special mode" in that page is the xapic's
logical flat mode and what is referred as "logical mode" on that page is
the xapic's logical cluster mode. And that page says that the logical
mode is not used on x3850 M2 / x3950 M2 (it is not very clear to me that
if the logical flat mode is fundamentally broken or not. but from your
data and from this page, it looks like it).

In the past (long time back which predates x86_64 architecture)
hurricane systems had issues with flat mode and hence 32bit architecture
uses summit-specific code to handle this platform.

/* Hook from generic ACPI tables.c */
static int summit_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
{
        if (!strncmp(oem_id, "IBM", 3) &&
            (!strncmp(oem_table_id, "SERVIGIL", 8)
             || !strncmp(oem_table_id, "EXA", 3))){
                mark_tsc_unstable("Summit based system");
                use_cyclone = 1; /*enable cyclone-timer*/
                setup_summit();
                return 1;
        }
        return 0;
}

So I think if you boot today's 32bit kernel on this platform, it will
use this summit specific code which doesn't use logical flat mode.

I think we were just lucky why we haven't run into this problem before
in 64-bit kernels.

Even with the existing code (after yesterday's revert by Linus), if all
the apic id's happen to be less than or equal to 8, then 64-bit kernel
will use flat mode again and that will cause an issue on your system
again.

Can you please check internally if the logical flat mode is broken on
this platform and if so, either kernel need to have a summit specific
check on 64bit too (just like 32bit) and not use flat mode or have the
bios on your platform set the ACPI_FADT_APIC_PHYSICAL fadt flag set.
Then the kernel will use physical mode irrespective of number of cpu's
or their apic id's.

I am also copying few more IBM folks Chris and Gary.

thanks,
suresh

