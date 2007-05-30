Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbXE3XxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbXE3XxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbXE3XxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:53:09 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58065 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750825AbXE3XxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:53:08 -0400
Date: Wed, 30 May 2007 16:53:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: "Luck, Tony" <tony.luck@intel.com>, David Chinner <dgc@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/fork.c:385
In-Reply-To: <20070530163413.87ecfe18.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0705301652100.3731@schroedinger.engr.sgi.com>
References: <617E1C2C70743745A92448908E030B2A01929C15@scsmsx411.amr.corp.intel.com>
 <Pine.LNX.4.64.0705301630360.3568@schroedinger.engr.sgi.com>
 <20070530163413.87ecfe18.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Randy Dunlap wrote:

> > Right. I have no idea where to look. The function has no name? Or is the 
> > segment .exit.text referenced by namne in .init.text?
> 
> Maybe 'objdump drivers/built-in.o and then grep that output (file)
> for /exit.text/ ...

clameter@schroedinger:~/software/slub$ objdump -t drivers/built-in.o |grep "exit.text"
0000000000000000 l    d  .exit.text     0000000000000000 .exit.text
0000000000000000 l    d  *ABS*  0000000000000000 .rela.exit.text
0000000000000000 l    d  .IA_64.unwind_info.exit.text   0000000000000000 .IA_64.unwind_info.exit.text
0000000000000000 l    d  .IA_64.unwind.exit.text        0000000000000000 .IA_64.unwind.exit.text
0000000000000000 l    d  *ABS*  0000000000000000 .rela.IA_64.unwind.exit.text
0000000000000000 l     F .exit.text     0000000000000050 pcie_portdrv_exit
0000000000000060 l     F .exit.text     0000000000000040 aer_service_exit
00000000000000a0 l     F .exit.text     0000000000000040 pci_hotplug_exit
00000000000000e0 l     F .exit.text     00000000000000b0 pcied_cleanup
00000000000001a0 l     F .exit.text     0000000000000160 mspec_exit
0000000000000300 l     F .exit.text     0000000000000010 efi_rtc_exit
0000000000000320 l     F .exit.text     0000000000000010 agp_exit
0000000000000340 l     F .exit.text     00000000000000a0 sn_sal_module_exit
00000000000003e0 l     F .exit.text     0000000000000040 firmware_class_exit
0000000000000420 l     F .exit.text     0000000000000110 rd_cleanup
0000000000000540 l     F .exit.text     00000000000001d0 loop_exit
0000000000000720 l     F .exit.text     0000000000000040 tg3_cleanup
0000000000000760 l     F .exit.text     0000000000000040 idedisk_exit
00000000000007a0 l     F .exit.text     0000000000000040 ide_cdrom_exit
00000000000007e0 l     F .exit.text     00000000000000a0 exit_scsi
0000000000000880 l     F .exit.text     0000000000000080 spi_transport_exit
0000000000000900 l     F .exit.text     00000000000000a0 fc_transport_exit
00000000000009a0 l     F .exit.text     00000000000000e0 sas_transport_exit
0000000000000a80 l     F .exit.text     0000000000000040 sas_class_exit
0000000000000ac0 l     F .exit.text     0000000000000040 qla1280_exit
0000000000000b00 l     F .exit.text     0000000000000140 qla2x00_module_exit
0000000000000c40 l     F .exit.text     00000000000000a0 exit_sd
0000000000000ce0 l     F .exit.text     0000000000000060 ata_exit
0000000000000d40 l     F .exit.text     0000000000000040 vsc_sata_exit
0000000000000d80 l     F .exit.text     00000000000000d0 fusion_exit
0000000000000e60 l     F .exit.text     00000000000000e0 mptspi_exit
0000000000000f40 l     F .exit.text     00000000000000d0 mptfc_exit
0000000000001020 l     F .exit.text     00000000000000f0 mptsas_exit
0000000000001120 l     F .exit.text     0000000000000060 cdrom_exit
0000000000001180 l     F .exit.text     0000000000000080 input_exit
0000000000001200 l     F .exit.text     0000000000000070 mousedev_exit
0000000000001280 l     F .exit.text     0000000000000040 multipath_exit
00000000000012c0 l     F .exit.text     0000000000000240 md_exit
0000000000001500 l     F .exit.text     0000000000000090 dm_exit
00000000000015a0 l     F .exit.text     0000000000000170 efivars_exit
0000000000001720 l     F .exit.text     0000000000000010 hid_exit

