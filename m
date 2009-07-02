Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbZGBGkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbZGBGkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 02:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755874AbZGBGka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 02:40:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:23845 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755902AbZGBGk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 02:40:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,331,1243839600"; 
   d="scan'208";a="704413928"
Subject: Re: [Bugme-new] [Bug 13690] New: nodes_clear cause hugepage
 unusable on non-NUMA machine
From: Alex Shi <alex.shi@intel.com>
Reply-To: alex.shi@intel.com
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "bugzilla-daemon@bugzilla.kernel.org" 
	<bugzilla-daemon@bugzilla.kernel.org>,
       "bugme-daemon@bugzilla.kernel.org" <bugme-daemon@bugzilla.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       yanmin.zhang@intel.com, tim.c.chen@intel.com
In-Reply-To: <4A4C17FD.3080404@kernel.org>
References: <bug-13690-10286@http.bugzilla.kernel.org/>
	 <20090701183452.8660c8a9.akpm@linux-foundation.org>
	 <4A4C17FD.3080404@kernel.org>
Content-Type: text/plain
Organization: intel.com
Date: Thu, 02 Jul 2009 14:45:11 +0800
Message-Id: <1246517111.15721.5.camel@alexs-hp>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new patch works for my stoakley i386 machine. But for x86_64 machine
the specjbb2005 still can not run with hugepage. The specjbb2005 use the
same java setting as i386 system. After apply your patch, the iomem of
x86_64 is:

00000000-0000ffff : reserved
00010000-0009cbff : System RAM
0009cc00-0009ffff : reserved
000cc000-000cffff : reserved
000e0000-000fffff : reserved
00100000-cfefffff : System RAM
  01000000-014eb53e : Kernel code
  014eb53f-0177390f : Kernel data
  01830000-018f583f : Kernel bss
cff00000-cff0afff : ACPI Tables
cff0b000-cff0bfff : ACPI Non-volatile Storage
cff0c000-cfffffff : reserved
d0000000-d7ffffff : PCI Bus 0000:08
  d0000000-d7ffffff : 0000:08:01.0
d8000000-d81fffff : PCI Bus 0000:03
  d8000000-d81fffff : PCI Bus 0000:06
    d8000000-d80fffff : 0000:06:02.0
    d8100000-d810ffff : 0000:06:01.0
d8200000-d84fffff : PCI Bus 0000:03
  d8200000-d83fffff : PCI Bus 0000:06
    d8200000-d82fffff : 0000:06:02.0
      d8200000-d82fffff : e100
    d8300000-d831ffff : 0000:06:01.0
      d8300000-d831ffff : e1000
    d8320000-d832ffff : 0000:06:01.0
      d8320000-d832ffff : e1000
    d8330000-d8330fff : 0000:06:02.0
      d8330000-d8330fff : e100
d8500000-d87fffff : PCI Bus 0000:07
  d8500000-d8503fff : 0000:07:00.0
  d8504000-d8507fff : 0000:07:00.1
  d8520000-d853ffff : 0000:07:00.0
  d8540000-d855ffff : 0000:07:00.1
  d8600000-d86fffff : 0000:07:00.0
  d8700000-d87fffff : 0000:07:00.1
d8800000-d88fffff : PCI Bus 0000:08
  d8800000-d880ffff : 0000:08:01.0
  d8810000-d8813fff : 0000:08:08.0
  d8814000-d88147ff : 0000:08:08.0
  d8820000-d883ffff : 0000:08:01.0
d8904000-d8907fff : 0000:00:1b.0
d8908000-d89083ff : 0000:00:1d.7
  d8908000-d89083ff : ehci_hcd
d8908400-d89087ff : 0000:00:1f.2
  d8908400-d89087ff : ahci
d8a00000-d8bfffff : PCI Bus 0000:07
  d8a00000-d8afffff : 0000:07:00.0
  d8b00000-d8bfffff : 0000:07:00.1
e0000000-efffffff : reserved
  e0000000-efffffff : pnp 00:01
    e0000000-e07fffff : PCI MMCONFIG 0 [00-07]
fe000000-fe01ffff : pnp 00:01
  fe000000-fe01ffff : i5k_amb
fe600000-fe6fffff : pnp 00:01
fe700000-fe703fff : 0000:00:0f.0
fec00000-fec0ffff : reserved
  fec00000-fec00fff : IOAPIC 0
fec88000-fec88fff : IOAPIC 1
  fec88000-fec88fff : pnp 00:01
fec89000-fec89fff : IOAPIC 2
  fec89000-fec89fff : pnp 00:01
fed00000-fed003ff : HPET 0
fed1c000-fed1ffff : pnp 00:01
fed20000-fed44fff : pnp 00:01
fed45000-fed8ffff : pnp 00:01
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ff000000-ffffffff : reserved
100000000-12fffffff : System RAM

====================
The iomem of i386 stoakley is: 
--- stoakley.iomem.x86_64  2009-07-02 13:53:35.000000000 +0800
+++ stoakley.iomem.i386 2009-07-02 14:19:59.000000000 +0800
@@ -1,12 +1,15 @@
 00000000-0000ffff : reserved
 00010000-0009cbff : System RAM
 0009cc00-0009ffff : reserved
+000a0000-000bffff : Video RAM area
+000c0000-000cafff : Video ROM
 000cc000-000cffff : reserved
 000e0000-000fffff : reserved
+  000f0000-000fffff : System ROM
 00100000-cfefffff : System RAM
-  01000000-014eb53e : Kernel code
-  014eb53f-0177390f : Kernel data
-  01830000-018f583f : Kernel bss
+  00100000-00602876 : Kernel code
+  00602877-008e49db : Kernel data
+  00954000-009fe433 : Kernel bss
 cff00000-cff0afff : ACPI Tables
 cff0b000-cff0bfff : ACPI Non-volatile Storage
 cff0c000-cfffffff : reserved
@@ -50,7 +53,6 @@
   e0000000-efffffff : pnp 00:01
     e0000000-e07fffff : PCI MMCONFIG 0 [00-07]
 fe000000-fe01ffff : pnp 00:01
-  fe000000-fe01ffff : i5k_amb
 fe600000-fe6fffff : pnp 00:01
 fe700000-fe703fff : 0000:00:0f.0
 fec00000-fec0ffff : reserved
@@ -66,4 +68,3 @@
 fee00000-fee00fff : Local APIC
   fee00000-fee00fff : reserved
 ff000000-ffffffff : reserved
-100000000-12fffffff : System RAM


Alex 

On Thu, 2009-07-02 at 10:14 +0800, Yinghai Lu wrote:
> that looks strange...
> 
> config is 32bit. 
> 
> the second patch only do save and restore. and should be right right.
> 
> please check following patch on today's linus tree. and send out /proc/iomem
> 
> Thanks
> 
> Yinghai
> 
> [PATCH] x86: add boundary check for 32bit res before expand e820 resource to alignment
> 
> fix hang with HIGHMEM_64G and 32bit resource.
> according to hpa and Linus, use (resource_size_t)-1 to fend off big ranges.
> 
> analyized by hpa
> 
> Reported-and-tested-by: Mikael Pettersson <mikpe@it.uu.se>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/proto.h |    3 ---
>  arch/x86/kernel/e820.c       |   20 ++++++++++++--------
>  include/linux/kernel.h       |    5 +++++
>  3 files changed, 17 insertions(+), 11 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/e820.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/e820.c
> +++ linux-2.6/arch/x86/kernel/e820.c
> @@ -1367,9 +1367,9 @@ void __init e820_reserve_resources(void)
>  }
>  
>  /* How much should we pad RAM ending depending on where it is? */
> -static unsigned long ram_alignment(resource_size_t pos)
> +static u64 ram_alignment(u64 pos)
>  {
> -	unsigned long mb = pos >> 20;
> +	u64 mb = pos >> 20;
>  
>  	/* To 64kB in the first megabyte */
>  	if (!mb)
> @@ -1383,6 +1383,8 @@ static unsigned long ram_alignment(resou
>  	return 32*1024*1024;
>  }
>  
> +#define MAX_RESOURCE_SIZE ((resource_size_t)-1)
> +
>  void __init e820_reserve_resources_late(void)
>  {
>  	int i;
> @@ -1400,17 +1402,19 @@ void __init e820_reserve_resources_late(
>  	 * avoid stolen RAM:
>  	 */
>  	for (i = 0; i < e820.nr_map; i++) {
> -		struct e820entry *entry = &e820_saved.map[i];
> -		resource_size_t start, end;
> +		struct e820entry *entry = &e820.map[i];
> +		u64 start, end;
>  
>  		if (entry->type != E820_RAM)
>  			continue;
>  		start = entry->addr + entry->size;
> -		end = round_up(start, ram_alignment(start));
> -		if (start == end)
> +		end = round_up(start, ram_alignment(start)) - 1;
> +		if (end > MAX_RESOURCE_SIZE)
> +			end = MAX_RESOURCE_SIZE;
> +		if (start > end)
>  			continue;
> -		reserve_region_with_split(&iomem_resource, start,
> -						  end - 1, "RAM buffer");
> +		reserve_region_with_split(&iomem_resource, start, end,
> +					  "RAM buffer");
>  	}
>  }
>  

