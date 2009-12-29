Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750AbZL2JuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbZL2JuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 04:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZL2JuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 04:50:15 -0500
Received: from web113305.mail.gq1.yahoo.com ([98.136.167.5]:35666 "HELO
	web113305.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751642AbZL2JuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 04:50:13 -0500
Message-ID: <696574.90670.qm@web113305.mail.gq1.yahoo.com>
X-YMail-OSG: i7s_BVoVM1kSFZA3BNpki9EhfNiCwHD9mI8ttBb1Syv_xGci.m7M6uisQ4uIkje4P5FzUeEqgqZGbZXgueR5ATxTU8ARXSL5des7aytScJGAsH6Ox1ruI_j2I1HmZ2R4gTwmNZaALXu6r6QmgaNOMcfH_BdabPGSolbO3EJUkQVW1UtdIlnJWBBvIDtSxiFXJP3R1TjYlEhRmYPTrqJblrCu8WG0QclwGkajYbQdXK5dnEBd6u7_ZWdozuhOOjYQBpkE66g8owa4.5NpMkPZk7x2hy6hjYUdcieEdOoY8jBIYsLVBJK9Ma891QdWEFxcZioNZxmPxiVh1.q6n.P9R5enhdUYMUVO6OJXAkfTRyk8WlXsO33x63AQpU1CiQanMxRF6igD5m8c7Lom0Y5EuvD3FycgiupH56ascR9p0g--
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/240.3 YahooMailWebService/0.8.100.260964
References: <55527.63156.qm@web113308.mail.gq1.yahoo.com>
Date: Tue, 29 Dec 2009 01:50:12 -0800 (PST)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: 2.6.33-next build errors (x86_64 defconfig) on RHEL-4.3
To: Martin Knoblauch <spamtrap@knobisoft.de>, linux-kernel@vger.kernel.org
Cc: Andreas Mohr <andi@lisas.de>
In-Reply-To: <55527.63156.qm@web113308.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Martin Knoblauch <spamtrap@knobisoft.de>
> To: linux-kernel@vger.kernel.org
> Cc: spam trap <spamtrap@knobisoft.de>
> Sent: Mon, December 28, 2009 10:51:07 AM
> Subject: 2.6.33-next build errors (x86_64 defconfig) on RHEL-4.3
> 
> Hi,
> 
> when trying to build 2.6.32.2 or 2.6.33-next on RHEL-4.3(64-bit userland), I get 
> the following errors (this is from 2.6.33-next-20091228):
> 
> ================================
> # make defconfig
> # make CONFIG_DEBUG_SECTION_MISMATCH=y
>   .
>   .
>   AS      arch/x86/lib/rwlock_64.o
>   AS      arch/x86/lib/thunk_64.o
>   CC      arch/x86/lib/usercopy_64.o
>   AR      arch/x86/lib/lib.a
>   LD      vmlinux.o
>   MODPOST vmlinux.o
> WARNING: vmlinux.o(.text+0xd2f04): Section mismatch in reference from the 
> function hugetlb_register_node() to the function 
> .init.text:hugetlb_sysfs_add_hstate()
> The function hugetlb_register_node() references
> the function __init hugetlb_sysfs_add_hstate().
> This is often because hugetlb_register_node lacks a __init
> annotation or the annotation of hugetlb_sysfs_add_hstate is wrong.
> 
> WARNING: vmlinux.o(.text+0x20805a): Section mismatch in reference from the 
> function dmar_ir_support() to the variable .init.data:dmar_tbl
> The function dmar_ir_support() references
> the variable __initdata dmar_tbl.
> This is often because dmar_ir_support lacks a __initdata
> annotation or the annotation of dmar_tbl is wrong.
> 
> WARNING: vmlinux.o(.text+0x222941): Section mismatch in reference from the 
> function acpi_early_processor_set_pdc() to the variable 
> .cpuinit.data:processor_idle_dmi_table
> The function acpi_early_processor_set_pdc() references
> the variable __cpuinitdata processor_idle_dmi_table.
> This is often because acpi_early_processor_set_pdc lacks a __cpuinitdata
> annotation or the annotation of processor_idle_dmi_table is wrong.
> 
> WARNING: vmlinux.o(.text+0x410dce): Section mismatch in reference from the 
> function pcibios_scan_specific_bus() to the function 
> .devinit.text:pci_scan_bus_on_node()
> The function pcibios_scan_specific_bus() references
> the function __devinit pci_scan_bus_on_node().
> This is often because pcibios_scan_specific_bus lacks a __devinit
> annotation or the annotation of pci_scan_bus_on_node is wrong.
> 
>   GEN     .version
>   CHK     include/generated/compile.h
>   UPD     include/generated/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o(.init.text+0x63ee): In function `con_init':
> : undefined reference to `.L949'
> make: *** [.tmp_vmlinux1] Error 1
> ================================
> 
> 
> For 2.6.32.2 I only get the "undefined reference to `.L949' error.
> 
> And yes, I know that RHEL-4.3 is old. But it is still widely used.
> 
> # gcc -v
> Reading specs from /usr/lib/gcc/x86_64-redhat-linux/3.4.5/specs
> Configured with: ../configure --prefix=/usr --mandir=/usr/share/man 
> --infodir=/usr/share/info --enable-shared --enable-threads=posix 
> --disable-checking --with-system-zlib --enable-__cxa_atexit 
> --disable-libunwind-exceptions --enable-java-awt=gtk --host=x86_64-redhat-linux
> Thread model: posix
> gcc version 3.4.5 20051201 (Red Hat 3.4.5-2)
> # as -v
> GNU assembler version 2.15.92.0.2 (x86_64-redhat-linux) using BFD version 
> 2.15.92.0.2 20040927
> # ldd -v
> ldd: missing file arguments
> Try `ldd --help' for more information.
> #
> 

 Not surprisingly, the problem still exists in next-20091229 :-) But actually, I think it might be even as old as 2.6.31-rc3. See

http://lkml.org/lkml/2009/7/14/120

for reference. Different (still older toolchain), but very similar failure.

@Andreas: did you ever had this resolved? I never saw a followup

Cheers
Martin

