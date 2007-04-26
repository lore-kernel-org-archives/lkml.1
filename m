Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbXDZRkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbXDZRkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbXDZRkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:40:42 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:60349 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905AbXDZRkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:40:40 -0400
Date: Thu, 26 Apr 2007 18:40:36 +0100
To: Andi Kleen <andi@firstfloor.org>
Cc: Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com
Subject: Re: 2.6.21-rc7-mm2 -- x86_64 blade hard hangs
Message-ID: <20070426174036.GH16909@skynet.ie>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <46309B59.4090701@shadowen.org> <p73fy6n2qhg.fsf@bingen.suse.de> <20070426133344.GB16909@skynet.ie> <20070426144622.GE16909@skynet.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070426144622.GE16909@skynet.ie>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (26/04/07 15:46), Mel Gorman didst pronounce:
> On (26/04/07 14:33), Mel Gorman didst pronounce:
> > On (26/04/07 15:51), Andi Kleen didst pronounce:
> > > Andy Whitcroft <apw@shadowen.org> writes:
> > > 
> > > > Getting hard boot failures before any kernel output on an x86_64 blade:
> > > > 
> > > > root (hd0,0)
> > > >  Filesystem type is ext2fs, partition type 0x83
> > > > kernel /vmlinuz-autobench ro root=/dev/VolGroup00/LogVol00 rhgb
> > > > console=tty0 console=ttyS1,19200 selinux=no autobench_args:
> > > > root=30726124 ABAT:1177507960 profile=2
> > > >    [Linux-bzImage, setup=0x1e00, size=0x21fe48]
> > > > initrd /initrd-autobench.img
> > > >    [Linux-initrd @ 0x37e5f000, 0x190984 bytes]
> > > > [silence]
> > > > 
> > > > Kernel config is here:
> > > > 
> > > > http://test.kernel.org/abat/85082/build/dotconfig
> > > 
> > > You should boot with earlyprintk=serial,ttyS1,19200
> > > 
> > 
> > Here is the console log. Haven't taken a closer look yet in case it's
> > blindingly obvious to you.
> > 
> > kernel /vmlinuz-autobench ro root=/dev/VolGroup00/LogVol00 rhgb
> > console=tty0 co
> > nsole=ttyS1,19200 selinux=no autobench_args: root=30726124
> > ABAT:1177594149 logl
> > evel=8 earlyprintk=serial,ttyS1,19200 
> >    [Linux-bzImage, setup=0x1e00, size=0x220da8]
> > initrd /initrd-autobench.img
> >    [Linux-initrd @ 0x37e5f000, 0x190982 bytes]
> > Linux version 2.6.21-rc7-mm2-autokern1 (root@bl6-13.ltc.austin.ibm.com)
> > (gcc version 4.1.1 20060525 (Red Hat 4.1.1-1)) #1 SMP Thu Apr 26
> > 08:16:37 CDT 2007
> > Command line: ro root=/dev/VolGroup00/LogVol00 rhgb console=tty0
> > console=ttyS1,19200 selinux=no autobench_args: root=30726124
> > ABAT:1177594149 loglevel=8 earlyprintk=serial,ttyS1,19200 
> > BIOS-provided physical RAM map:
> >  BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
> >  BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
> >  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
> >  BIOS-e820: 0000000000100000 - 000000003ffcddc0 (usable)
> >  BIOS-e820: 000000003ffcddc0 - 000000003ffd0000 (ACPI data)
> >  BIOS-e820: 000000003ffd0000 - 0000000040000000 (reserved)
> >  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> > end_pfn_map = 1048576
> > kernel direct mapping tables up to 100000000 @ 8000-d000
> > DMI 2.3 present.
> > ACPI: RSDP 000FDFC0, 0014 (r0 IBM   )
> > ACPI: RSDT 3FFCFF80, 0034 (r1 IBM    SERBLADE     1000 IBM  45444F43)
> > ACPI: FACP 3FFCFEC0, 0084 (r2 IBM    SERBLADE     1000 IBM  45444F43)
> > ACPI: DSDT 3FFCDDC0, 1EA6 (r1 IBM    SERBLADE     1000 INTL  2002025)
> > ACPI: FACS 3FFCFCC0, 0040
> > ACPI: APIC 3FFCFE00, 009C (r1 IBM    SERBLADE     1000 IBM  45444F43)
> > ACPI: SRAT 3FFCFD40, 0098 (r1 IBM    SERBLADE     1000 IBM  45444F43)
> > ACPI: HPET 3FFCFD00, 0038 (r1 IBM    SERBLADE     1000 IBM  45444F43)
> > SRAT: PXM 0 -> APIC 0 -> Node 0
> > SRAT: PXM 0 -> APIC 1 -> Node 0
> > SRAT: PXM 1 -> APIC 2 -> Node 1
> > SRAT: PXM 1 -> APIC 3 -> Node 1
> > SRAT: Node 0 PXM 0 0-40000000
> > PANIC: early exception rip ffffffff808a7e83 error 0 cr2 5cf0
> > Call Trace:
> >  [<ffffffff808a7e83>] reserve_bootmem_node+0x0/0xc
> >  [<ffffffff808a3a8c>] reserve_bootmem_generic+0x6d/0x99
> >  [<ffffffff8089cc00>] setup_arch+0x2f7/0x469
> >  [<ffffffff80896510>] start_kernel+0x64/0x2aa
> >  [<ffffffff80896148>] _sinittext+0x148/0x14c
> > RIP reserve_bootmem_node+0x0/0xc
> > 
> 
> When I looked closer, nothing seemed to make sense so here is another
> log with stack unwinder, frame pointer etc etc
> 
> PANIC: early exception rip ffffffff8095a873 error 0 cr2 5cf0
> 
> Call Trace:
>  [<ffffffff8020b174>] dump_trace+0xb6/0x3d8
>  [<ffffffff8020b4d2>] show_trace+0x3c/0x52
>  [<ffffffff8020b4fd>] dump_stack+0x15/0x17
>  [<ffffffff802001e7>]
> DWARF2 unwinder stuck at 0xffffffff802001e7
> Leftover inexact backtrace:
>  [<ffffffff8095a873>] reserve_bootmem_node+0x1/0x12
>  [<ffffffff8096114f>] acpi_table_parse+0x4f/0x69
>  [<ffffffff80955f91>] reserve_bootmem_generic+0x73/0x9e
>  [<ffffffff8094edd3>] setup_arch+0x301/0x49c
>  [<ffffffff8094855f>] start_kernel+0x6c/0x30b
>  [<ffffffff80948144>] _sinittext+0x144/0x14b
> 
> RIP reserve_bootmem_node+0x1/0x12
> 
> Will keep kicking.
> 

NODE_DATA(0) was returning NULL because of
x86_64-set-node_possible_map-at-runtime.patch. This patch appears to
break acpi_scan_nodes() so that setup_node_bootmem() never gets called and
node_data[] remains full of zeros. Later on, reserve_bootmem_generic() is
called but with NODE_DATA(0) == NULL, it all goes pear shaped. Author of
patch cc'd.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
