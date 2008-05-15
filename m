Return-Path: <linux-kernel-owner+w=401wt.eu-S1762842AbYEORos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762842AbYEORos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbYEORoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:44:39 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:1183 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbYEORoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:44:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aKriRDk75zMBhRG44hFMDo5RIOiO1bPsNwDBJm4AUnVD33rhXX22/v5lgsRX3OVaR/gGEFzngnXCc6445tE5HkwjPFN//F48HtaCtg1rqHj75NzNBie2/yDyXljtxbE1BhwCo73kgVWRQNVEPCF1SdMv/0CEk+UnTuF/THPedvk=
Message-ID: <64bb37e0805151044i574d697es8c8c29496d99e8d3@mail.gmail.com>
Date: Thu, 15 May 2008 19:44:37 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.26-rc2-mm1
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20080514123537.4df70e80.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080514010129.4f672378.akpm@linux-foundation.org>
	 <64bb37e0805141212i7587a502vdff9af109b55c37b@mail.gmail.com>
	 <20080514123537.4df70e80.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 9:35 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 14 May 2008 21:12:13 +0200
>  "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
>  > This line from 2.6.26-rc2-mm1 really looks like the source of this:
>  > [    0.000000] SRAT: PXMs only cover 0MB of your 4608MB e820 RAM. Not used.
>  > There is no more than 4GB of RAM (but part of it is remapped...)
>
>  I suspect that this might be caused by the below.
>
>  That patch no longer seems to be necessary so I'll drop it.  Perhaps
>  you could try reverting it, please?

Yes, reverting the patch below gets the system back to its normal state.

[    0.000000] ACPI: SSDT DFFD55B0, 04F0 (r1 A_M_I_ POWERNOW        1
AMD         1)
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 2 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 3 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 0-a0000
[    0.000000] SRAT: Node 0 PXM 0 100000-80000000
[    0.000000] SRAT: Node 1 PXM 1 80000000-e0000000
[    0.000000] SRAT: Node 1 PXM 1 100000000-120000000
[    0.000000] NUMA: Allocated memnodemap from e000 - 10440
[    0.000000] NUMA: Using 20 for the hash shift.
[    0.000000] Bootmem setup node 0 0000000000000000-0000000080000000
[    0.000000]   NODE_DATA [0000000000001000 - 0000000000004fff]
[    0.000000]   bootmap [0000000000011000 -  0000000000020fff] pages 10
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [6000-7fff] TRAMPOLINE
[    0.000000]   early res: 2 [200000-9601db] TEXT DATA BSS
[    0.000000]   early res: 3 [37ec8000-37fefc27] RAMDISK
[    0.000000]   early res: 4 [9fc00-fffff] BIOS reserved
[    0.000000]   early res: 5 [8000-dfff] PGTABLE
[    0.000000]   early res: 6 [e000-1043f] MEMNODEMAP
[    0.000000] Bootmem setup node 1 0000000080000000-0000000120000000
[    0.000000]   NODE_DATA [0000000080000000 - 0000000080003fff]
[    0.000000]   bootmap [0000000080004000 -  0000000080017fff] pages 14
[    0.000000]  [ffffe20000000000-ffffe20001bfffff] PMD ->
[ffff81000c200000-ffff81000ddfffff] on node 0
[    0.000000]  [ffffe20001c00000-ffffe20003ffffff] PMD ->
[ffff810080200000-ffff810081ffffff] on node 1
[    0.000000] sizeof(struct page) = 56

Just for your information: I'm also using a 64bit Gentoo system with
gcc 4.3.0-alpha20080410 and I'm also seeing these strange time
outputs:

[    0.000000] NR_CPUS: 4, nr_cpu_ids: 4
[42949372.960000] Built 2 zonelists in Node order, mobility grouping
on.  Total pages: 1030306

On every bootup with and without the patch this first timenumber was identical.

Torsten

>  From: Ingo Molnar <mingo@elte.hu>
>
>  x86.git testing found the following build error on latest -git:
>
>   drivers/acpi/numa.c: In function 'acpi_numa_init':
>   drivers/acpi/numa.c:226: error: 'NR_NODE_MEMBLKS' undeclared (first use in this function)
>   drivers/acpi/numa.c:226: error: (Each undeclared identifier is reported only once
>   drivers/acpi/numa.c:226: error: for each function it appears in.)
>
>  with this config:
>
>   http://redhat.com/~mingo/misc/config-Wed_Apr_30_22_42_42_CEST_2008.bad
>
>  i suspect we dont want SRAT parsing when CONFIG_HAVE_ARCH_PARSE_SRAT
>  is unset - but the fix looks a bit ugly. Perhaps we should define
>  NR_NODE_MEMBLKS even in this case and just let the code fall back
>  to some sane behavior?
>
>  Signed-off-by: Ingo Molnar <mingo@elte.hu>
>  Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>  ---
>
>   drivers/acpi/numa.c |    4 ++++
>   1 file changed, 4 insertions(+)
>
>  diff -puN drivers/acpi/numa.c~acpi-acpi_numa_init-build-fix drivers/acpi/numa.c
>  --- a/drivers/acpi/numa.c~acpi-acpi_numa_init-build-fix
>  +++ a/drivers/acpi/numa.c
>  @@ -176,6 +176,7 @@ acpi_parse_processor_affinity(struct acp
>         return 0;
>   }
>
>  +#ifdef CONFIG_HAVE_ARCH_PARSE_SRAT
>   static int __init
>   acpi_parse_memory_affinity(struct acpi_subtable_header * header,
>                            const unsigned long end)
>  @@ -193,6 +194,7 @@ acpi_parse_memory_affinity(struct acpi_s
>
>         return 0;
>   }
>  +#endif
>
>   static int __init acpi_parse_srat(struct acpi_table_header *table)
>   {
>  @@ -221,9 +223,11 @@ int __init acpi_numa_init(void)
>         if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
>                 acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
>                                       acpi_parse_processor_affinity, NR_CPUS);
>  +#ifdef CONFIG_HAVE_ARCH_PARSE_SRAT
>                 acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
>                                       acpi_parse_memory_affinity,
>                                       NR_NODE_MEMBLKS);
>  +#endif
>         }
>
>         /* SLIT: System Locality Information Table */
>  _
>
>
