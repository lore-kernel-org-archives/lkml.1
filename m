Return-Path: <linux-kernel-owner+w=401wt.eu-S1752053AbZL1J5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbZL1J5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 04:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbZL1J5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 04:57:50 -0500
Received: from web113308.mail.gq1.yahoo.com ([98.136.167.8]:48371 "HELO
	web113308.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751537AbZL1J5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 04:57:49 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Dec 2009 04:57:49 EST
Message-ID: <55527.63156.qm@web113308.mail.gq1.yahoo.com>
X-YMail-OSG: nkc4MfwVM1mgDfHbzIgTnADy4VagXXkxRAD6vKhyKcnfvnoDtdZkGW2SvLZEYb7nBYcwJv0wwAp3y90E_u7ASVTQHVlrKERBHg_1Q8taMVMQXSmrHDqP9OgOT73x456iy2IIh2flIY_EJ29oELGyqFAevU.iBuxfeZVSvGDmnd6POTJGkCKNJ.bxPnLoInDE5E3bUtqV4qJdyDvBXWmqKkNWnmRIpGw2OP40TIiSuWVhInNg4trfoOiE1rDehaXlFmgqByijrXH5vZ2dKudC1.3R.OiDCdr9sl_cTjxI51TDPDwrcr2KFf2EtER_0pZH2tD4BEbcd9dvWakDAE6ZhBQFuqMuOg3K602oEf_My34rYxGMnfgw1whp.Vtp3VzO1OGaogx1SD.pp0T7AMFdsPSxmkITan.t.wmJz6SnLYDhyyuA5MqK
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/240.3 YahooMailWebService/0.8.100.260964
Date: Mon, 28 Dec 2009 01:51:07 -0800 (PST)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: 2.6.33-next build errors (x86_64 defconfig) on RHEL-4.3
To: linux-kernel@vger.kernel.org
Cc: spam trap <spamtrap@knobisoft.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

 when trying to build 2.6.32.2 or 2.6.33-next on RHEL-4.3(64-bit userland), I get the following errors (this is from 2.6.33-next-20091228):

================================
# make defconfig
# make CONFIG_DEBUG_SECTION_MISMATCH=y
  .
  .
  AS      arch/x86/lib/rwlock_64.o
  AS      arch/x86/lib/thunk_64.o
  CC      arch/x86/lib/usercopy_64.o
  AR      arch/x86/lib/lib.a
  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0xd2f04): Section mismatch in reference from the function hugetlb_register_node() to the function .init.text:hugetlb_sysfs_add_hstate()
The function hugetlb_register_node() references
the function __init hugetlb_sysfs_add_hstate().
This is often because hugetlb_register_node lacks a __init
annotation or the annotation of hugetlb_sysfs_add_hstate is wrong.

WARNING: vmlinux.o(.text+0x20805a): Section mismatch in reference from the function dmar_ir_support() to the variable .init.data:dmar_tbl
The function dmar_ir_support() references
the variable __initdata dmar_tbl.
This is often because dmar_ir_support lacks a __initdata
annotation or the annotation of dmar_tbl is wrong.

WARNING: vmlinux.o(.text+0x222941): Section mismatch in reference from the function acpi_early_processor_set_pdc() to the variable .cpuinit.data:processor_idle_dmi_table
The function acpi_early_processor_set_pdc() references
the variable __cpuinitdata processor_idle_dmi_table.
This is often because acpi_early_processor_set_pdc lacks a __cpuinitdata
annotation or the annotation of processor_idle_dmi_table is wrong.

WARNING: vmlinux.o(.text+0x410dce): Section mismatch in reference from the function pcibios_scan_specific_bus() to the function .devinit.text:pci_scan_bus_on_node()
The function pcibios_scan_specific_bus() references
the function __devinit pci_scan_bus_on_node().
This is often because pcibios_scan_specific_bus lacks a __devinit
annotation or the annotation of pci_scan_bus_on_node is wrong.

  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o(.init.text+0x63ee): In function `con_init':
: undefined reference to `.L949'
make: *** [.tmp_vmlinux1] Error 1
================================


 For 2.6.32.2 I only get the "undefined reference to `.L949' error.

 And yes, I know that RHEL-4.3 is old. But it is still widely used.

# gcc -v
Reading specs from /usr/lib/gcc/x86_64-redhat-linux/3.4.5/specs
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --enable-shared --enable-threads=posix --disable-checking --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-java-awt=gtk --host=x86_64-redhat-linux
Thread model: posix
gcc version 3.4.5 20051201 (Red Hat 3.4.5-2)
# as -v
GNU assembler version 2.15.92.0.2 (x86_64-redhat-linux) using BFD version 2.15.92.0.2 20040927
# ldd -v
ldd: missing file arguments
Try `ldd --help' for more information.
#

Cheers
Martin
------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de

