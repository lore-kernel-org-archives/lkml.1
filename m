Return-Path: <linux-kernel-owner+w=401wt.eu-S932124AbYA2REV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbYA2REV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757661AbYA2REH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:04:07 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:49779 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbYA2REG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:04:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=jetbUw478QAnh2iC8e2afjo8amkjx74sV6HFlCoV7oPLiiz+yh2MsvqpBZYMKXqUj1IxBSP6Tfdn1/5cD9qbWLZXClG//do/H0bX18JSO/pNsHnl/OtuwBfwpgiFyd7xJTidex/TrBDCuBM0rzvZNy51JMNRmZ+gJc8ek9enF7M=
Date: Tue, 29 Jan 2008 18:03:30 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Section mismatch errors on current Linus tree
Message-ID: <20080129170325.GA23544@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
I'm getting these warnings on current Linus tree (0ba6c33bcddc64a54b5f1c25a696c4767dc76292):

  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x1a3c75): Section mismatch in reference from the function pci_scan_child_bus() to the function .devinit.text:pcibios_fixup_bus()
WARNING: vmlinux.o(.text+0x1e333c): Section mismatch in reference from the function acpi_pci_root_add() to the function .devinit.text:pci_acpi_scan_root()
WARNING: vmlinux.o(.meminit.text+0xc5e): Section mismatch in reference from the function free_area_init_node() to the function .init.text:__alloc_bootmem_node()
WARNING: vmlinux.o(__ksymtab+0x5400): Section mismatch in reference from the variable __ksymtab_pci_do_scan_bus to the function .devinit.text:pci_do_scan_bus()
WARNING: vmlinux.o (.init.data.2): unexpected section name.
The (.[number]+) following section name are ld generated and not expected.
Did you forget to use "ax"/"aw" in a .S file?
Note that for example <linux/init.h> contains
section definitions for use in .S files.

WARNING: vmlinux.o (.init.data.7): unexpected section name.
The (.[number]+) following section name are ld generated and not expected.
Did you forget to use "ax"/"aw" in a .S file?
Note that for example <linux/init.h> contains
section definitions for use in .S files.

WARNING: vmlinux.o (.init.data.8): unexpected section name.
The (.[number]+) following section name are ld generated and not expected.
Did you forget to use "ax"/"aw" in a .S file?
Note that for example <linux/init.h> contains
section definitions for use in .S files.

WARNING: vmlinux.o (.init.data.13): unexpected section name.
The (.[number]+) following section name are ld generated and not expected.
Did you forget to use "ax"/"aw" in a .S file?
Note that for example <linux/init.h> contains
section definitions for use in .S files.

WARNING: vmlinux.o (.init.data.14): unexpected section name.
The (.[number]+) following section name are ld generated and not expected.
Did you forget to use "ax"/"aw" in a .S file?
Note that for example <linux/init.h> contains
section definitions for use in .S files.

WARNING: vmlinux.o (.init.data.15): unexpected section name.
The (.[number]+) following section name are ld generated and not expected.
Did you forget to use "ax"/"aw" in a .S file?
Note that for example <linux/init.h> contains
section definitions for use in .S files.

WARNING: vmlinux.o (.sched.text.11): unexpected section name.
The (.[number]+) following section name are ld generated and not expected.
Did you forget to use "ax"/"aw" in a .S file?
Note that for example <linux/init.h> contains
section definitions for use in .S files.

modpost: Found 4 section mismatch(es).
To see additional details select "Enable full Section mismatch analysis"
in the Kernel Hacking menu (CONFIG_SECTION_MISMATCH).


and then:
  Building modules, stage 2.
  MODPOST 188 modules
WARNING: drivers/serial/8250_pci.o(.data+0x198): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_ite887x_exit()
WARNING: drivers/serial/8250_pci.o(.data+0x1c0): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_plx9050_exit()
WARNING: drivers/serial/8250_pci.o(.data+0x1e8): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_plx9050_exit()
WARNING: drivers/serial/8250_pci.o(.data+0x238): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_plx9050_exit()
WARNING: drivers/serial/8250_pci.o(.data+0x260): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_plx9050_exit()
WARNING: drivers/serial/8250_pci.o(.data+0x288): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_plx9050_exit()
WARNING: drivers/serial/8250_pci.o(.data+0x2b0): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:sbs_exit()
WARNING: drivers/serial/8250_pci.o(.data+0x2d8): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:sbs_exit()
WARNING: drivers/serial/8250_pci.o(.data+0x300): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:sbs_exit()
WARNING: drivers/serial/8250_pci.o(.data+0x328): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:sbs_exit()
modpost: Found 10 section mismatch(es).
To see additional details select "Enable full Section mismatch analysis"
in the Kernel Hacking menu (CONFIG_SECTION_MISMATCH).

Should I enable CONFIG_SECTION_MISMATCH or is it easly fixable?

Marcin
