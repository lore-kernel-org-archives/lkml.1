Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbZAILIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbZAILIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 06:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbZAILIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 06:08:46 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:55711 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbZAILIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 06:08:44 -0500
From: Chandru <chandru@in.ibm.com>
Organization: ibm
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: 2.6.28-rc9 panics with crashkernel=256M while booting
Date: Fri, 9 Jan 2009 16:37:24 +0530
User-Agent: KMail/1.9.10
Cc: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <200812241325.49404.chandru@in.ibm.com> <200901081559.22204.chandru@in.ibm.com> <1231444992.23462.138.camel@nimitz>
In-Reply-To: <1231444992.23462.138.camel@nimitz>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_s/yZJ+kK7Tmw//I"
Message-Id: <200901091637.24658.chandru@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_s/yZJ+kK7Tmw//I
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 09 January 2009 01:33:12 Dave Hansen wrote:
> Now I'm even more confused.  Could you please send a fully changelogged
> patch that describes the problem, and how this fixes it?  This just
> seems like an off-by-one error, which isn't what I thought we had before
> at all.
> 
> I'm also horribly confused why PFN_UP is needed here.  Is 'physbase' not
> page aligned?  reserve_size looks like it *has* to be.  'end_pfn' is
> always (as far as I have ever seen in the kernel) the pfn of the page
> after the area we are interested in and we treat it as such in that
> function.  In the case of an unaligned physbase, that wouldn't be true.
> 
> Think of the case where we have a 1-byte reservation.  start_pfn will
> equal end_pfn and we won't go into that while loop at *all* and won't
> reserve anything.
> 
> Does 'end_pfn' need fixing?
> 

Attached is the console log with debug command line parameters enabled and 
with couple of more debug statements added to the code.  Please take a look at it. 

thanks,
Chandru


--Boundary-00=_s/yZJ+kK7Tmw//I
Content-Type: text/plain;
  charset="iso 8859-15";
  name="console_log.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="console_log.txt"

Using 0078209e bytes for initrd buffer
Please wait, loading kernel...
Allocated 00d00000 bytes for kernel @ 02d00000
   Elf64 kernel loaded...
Loading ramdisk...
ramdisk loaded 0078209e @ 00d00000
OF stdout device is: /vdevice/vty@30000000
Hypertas detected, assuming LPAR !
command line: root=/dev/disk/by-id/scsi-35000cca0030c7be2-part3  xmon=on crashkernel=256M@32M debug bootmem_debug numa=debug
memory layout at init:
  alloc_bottom : 0000000003880000
  alloc_top    : 0000000010000000
  alloc_top_hi : 0000000100000000
  rmo_top      : 0000000010000000
  ram_top      : 0000000100000000
Looking for displays
instantiating rtas at 0x000000000f4e0000 ... done
boot cpu hw idx 0000000000000000
copying OF device tree ...
Building dt strings...
Building dt structure...
Device tree strings 0x0000000003a90000 -> 0x0000000003a917bc
Device tree struct  0x0000000003aa0000 -> 0x0000000003ac0000
Calling quiesce ...
returning from prom_init
Reserving 256MB of memory at 32MB for crashkernel (System RAM: 4096MB)
Phyp-dump disabled at boot time
Using pSeries machine description
Page orders: linear mapping = 24, virtual = 16, io = 12
Using 1TB segments
Found initrd at 0xc000000000d00000:0xc00000000148209e
console [udbg0] enabled
Partition configured for 4 cpus.
CPU maps initialized for 2 threads per core
 (thread shift is 1)
Starting Linux PPC64 #7 SMP Fri Jan 9 04:50:05 CST 2009
-----------------------------------------------------
ppc64_pft_size                = 0x1a
physicalMemorySize            = 0x100000000
htab_hash_mask                = 0x7ffff
-----------------------------------------------------
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.28-1-ppc64 (root@rulerlp10) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #7 SMP Fri Jan 9 04:50:05 CST 2009
[boot]0012 Setup Arch
NUMA associativity depth for CPU/Memory: 3
Node 0 Memory:
Node 5 Memory: 0x0-0x10000000
Node 7 Memory: 0x10000000-0x100000000
adding cpu 0 to node 0
node 0
NODE_DATA() = c0000000fffeda80
node 5
NODE_DATA() = c000000001f78800
start_paddr = 0
end_paddr = 10000000
bootmap_paddr = 1f60000
bootmem::init_bootmem_core nid=5 start=0 map=1f6 end=1000 mapsize=200
bootmem::mark_bootmem_node nid=5 start=0 end=1000 reserve=0 flags=0 bdata->node_min_pfn=0x0 bdata->node_low_pfn=0x1000
bootmem::__free nid=5 start=0 end=1000
reserve_bootmem :
        physbase :0x0  size:0xb70000 reserve_size=0xb70000 nid=5
        start_pfn:0x0  end_pfn:0xb7
        node_ar.start_pfn:0x0 node_ar.end_pfn:0x1000
        node->node_start_pfn:0x0 node->node_spanned_pages:4096
bootmem::mark_bootmem_node nid=5 start=0 end=b7 reserve=1 flags=0 bdata->node_min_pfn=0x0 bdata->node_low_pfn=0x1000
bootmem::__reserve nid=5 start=0 end=b7 flags=0
reserve_bootmem :
        physbase :0xd00000  size:0x78209e reserve_size=0x78209e nid=5
        start_pfn:0xd0  end_pfn:0x148
        node_ar.start_pfn:0x0 node_ar.end_pfn:0x1000
        node->node_start_pfn:0x0 node->node_spanned_pages:4096
bootmem::mark_bootmem_node nid=5 start=d0 end=149 reserve=1 flags=0 bdata->node_min_pfn=0x0 bdata->node_low_pfn=0x1000
bootmem::__reserve nid=5 start=d0 end=149 flags=0
reserve_bootmem :
        physbase :0xd00000  size:0x790000 reserve_size=0x790000 nid=5
        start_pfn:0xd0  end_pfn:0x149
        node_ar.start_pfn:0x0 node_ar.end_pfn:0x1000
        node->node_start_pfn:0x0 node->node_spanned_pages:4096
bootmem::mark_bootmem_node nid=5 start=d0 end=149 reserve=1 flags=0 bdata->node_min_pfn=0x0 bdata->node_low_pfn=0x1000
bootmem::__reserve nid=5 start=d0 end=149 flags=0
bootmem::__reserve silent double reserve of PFN d0
bootmem::__reserve silent double reserve of PFN d1
...
...
...
bootmem::__reserve silent double reserve of PFN 147
bootmem::__reserve silent double reserve of PFN 148
reserve_bootmem :
        physbase :0x1f60000  size:0x10000 reserve_size=0x10000 nid=5
        start_pfn:0x1f6  end_pfn:0x1f7
        node_ar.start_pfn:0x0 node_ar.end_pfn:0x1000
        node->node_start_pfn:0x0 node->node_spanned_pages:4096
bootmem::mark_bootmem_node nid=5 start=1f6 end=1f7 reserve=1 flags=0 bdata->node_min_pfn=0x0 bdata->node_low_pfn=0x1000
bootmem::__reserve nid=5 start=1f6 end=1f7 flags=0
reserve_bootmem :
        physbase :0x1f78800  size:0x10087800 reserve_size=0xe090000 nid=5
        start_pfn:0x1f7  end_pfn:0x1200
        node_ar.start_pfn:0x0 node_ar.end_pfn:0x1000
        node->node_start_pfn:0x0 node->node_spanned_pages:4096
bootmem::mark_bootmem_node nid=5 start=1f7 end=1001 reserve=1 flags=0 bdata->node_min_pfn=0x0 bdata->node_low_pfn=0x1000
------------[ cut here ]------------
kernel BUG at mm/bootmem.c:279!
cpu 0x0: Vector: 700 (Program Check) at [c0000000008a39d0]
    pc: c000000000676ec0: .mark_bootmem_node+0xb4/0x12c
    lr: c000000000676e98: .mark_bootmem_node+0x8c/0x12c
    sp: c0000000008a3c50
   msr: 8000000000021032
  current = 0xc0000000007fa820
  paca    = 0xc000000000962c00
    pid   = 0, comm = swapper
kernel BUG at mm/bootmem.c:279!
enter ? for help
[c0000000008a3d00] c000000000661d3c .do_init_bootmem+0xc3c/0xd78
[c0000000008a3e40] c0000000006567f0 .setup_arch+0x1a4/0x21c
[c0000000008a3ee0] c000000000650868 .start_kernel+0xdc/0x56c
[c0000000008a3f90] c0000000000083b8 .start_here_common+0x1c/0x64
0:mon>

--Boundary-00=_s/yZJ+kK7Tmw//I--
