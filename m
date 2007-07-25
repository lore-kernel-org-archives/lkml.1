Return-Path: <linux-kernel-owner+w=401wt.eu-S933568AbXGYQhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568AbXGYQhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 12:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764608AbXGYQg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 12:36:59 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1649 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764461AbXGYQg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 12:36:58 -0400
Message-ID: <46A77C28.1050807@shadowen.org>
Date: Wed, 25 Jul 2007 17:36:56 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Steve Fox <drfickle@us.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.23-rc1-mm1 -- mostly fails to build
References: <20070725040304.111550f4.akpm@linux-foundation.org>
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Of the machines we test releases on automatically this only compiles on
NUMA-Q and does not boot there (some PCI issue).


ppc64 (beavis):

drivers/built-in.o(.text+0xd2784): In function `.srp_rport_add':
: undefined reference to `.scsi_tgt_it_nexus_create'
drivers/built-in.o(.text+0xd2884): In function `.srp_rport_del':
: undefined reference to `.scsi_tgt_it_nexus_destroy'
make: *** [.tmp_vmlinux1] Error 1


x86_64 (bl6-13):

ERROR: "scsi_tgt_it_nexus_destroy" [drivers/scsi/scsi_transport_srp.ko]
undefined!
ERROR: "scsi_tgt_it_nexus_create" [drivers/scsi/scsi_transport_srp.ko]
undefined!
make[1]: *** [__modpost] Error 1


ia64 (elm3a170):

drivers/built-in.o: In function `acpi_pci_choose_state':
pci-acpi.c:(.text+0x18d02): undefined reference to
`acpi_pm_device_sleep_state'
drivers/built-in.o: In function `pnpacpi_suspend':
core.c:(.text+0x86ec2): undefined reference to `acpi_pm_device_sleep_state'
make: *** [.tmp_vmlinux1] Error 1



ia64 (elm3b10):

  LD      vmlinux.o
ld: dynreloc miscount for kernel/built-in.o, section .opd
ld: can not edit opd Bad value
make: *** [vmlinux.o] Error 1


ppc64 (gekko-lp1):

drivers/built-in.o(.text+0x8d68): In function `acpi_pci_choose_state':
: undefined reference to `acpi_pm_device_sleep_state'
drivers/built-in.o(.text+0x3b773): In function `pnpacpi_suspend':
: undefined reference to `acpi_pm_device_sleep_state'
make: *** [.tmp_vmlinux1] Error 1


Will investigate the NUMA-Q explosion and report on that separatly.

-apw
