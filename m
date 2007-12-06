Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbXLFTTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbXLFTTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbXLFTTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:19:36 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:39772 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbXLFTTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:19:35 -0500
Subject: Re: 2.6.24-rc4-mm1 kobject changes broken with hvcs driver on
	powerpc
From: Badari Pulavarty <pbadari@gmail.com>
To: balbir@linux.vnet.ibm.com
Cc: Greg KH <greg@kroah.com>, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, rsa@us.ibm.com, apw@shadowen.org,
       balbir@in.ibm.com
In-Reply-To: <47584672.8040201@linux.vnet.ibm.com>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	 <20071205141202.GB13189@linux.vnet.ibm.com>
	 <47583D4F.2050707@linux.vnet.ibm.com> <20071206185006.GA21641@kroah.com>
	 <47584672.8040201@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 06 Dec 2007 11:21:20 -0800
Message-Id: <1196968880.18388.5.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-12-07 at 00:28 +0530, Balbir Singh wrote:
> Greg KH wrote:
> 
> >> Why release the spinlock here? It's done after the count is incremented.
> >> This patch does not seem correct.
> > 
> > Doh, you are correct, I'll make sure that I fix this up before applying
> > it.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hi, Greg,
> 
> I ran some tests with the fixed up version of this patch and the system
> fails to come up.
> 
> I see the WARN_ON in lib/kref.c:33 and the system fails to boot beyond
> that point. I have not yet found time to debug it though.


Are you running into same issue, I am getting on my machine ? Are you
using IPR driver ?

Thanks,
Badari


e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 (April 24, 2007)
ipr 0000:d0:01.0: Found IOA with IRQ: 119
ipr 0000:d0:01.0: Starting IOA initialization sequence.
ipr 0000:d0:01.0: Adapter firmware version: 020A005E
ipr 0000:d0:01.0: IOA initialized.
scsi0 : IBM 570B Storage Adapter
scsi 0:0:3:0: Direct-Access     IBM   H0 HUS103014FL3800  RPQF PQ: 0 ANSI: 4
scsi 0:0:5:0: Direct-Access     IBM   H0 HUS103014FL3800  RPQF PQ: 0 ANSI: 4
scsi 0:0:8:0: Direct-Access     IBM   H0 HUS103014FL3800  RPQF PQ: 0 ANSI: 4
scsi 0:0:15:0: Enclosure         IBM      VSBPD4E2  U4SCSI 7134 PQ: 0 ANSI: 2
------------[ cut here ]------------
Badness at lib/kref.c:33
NIP: c0000000002e1254 LR: c0000000002dfbd8 CTR: c0000000002e60f0
REGS: c00000003f0db050 TRAP: 0700   Not tainted  (2.6.24-rc4-mm1)
MSR: 8000000000029032 <EE,ME,IR,DR>  CR: 28002042  XER: 0000000f
TASK = c00000003f0d78d0[1] 'swapper' THREAD: c00000003f0d8000 CPU: 0
GPR00: 0000000000000000 c00000003f0db2d0 c000000000724098 c00000003f131620
GPR04: fffffffffffffff1 fffffffffffffffe 000000000000000a ffffffffffffffff
GPR08: c00000003d4d9000 c00000003f0cbfe0 c000000000556591 0000000000000073
GPR12: 0000000024002084 c000000000651980 0000000000000000 0000000000000000
GPR16: 0000000000000000 d000080080080000 c00000000064d6f0 c00000003d4d9570
GPR20: c00000003d4d94b8 0000000000000002 c00000003d4d9170 c00000003d4d9170
GPR24: c00000003d4d9000 0000000000000001 c00000003d570d58 c00000003d570d18
GPR28: 0000000000000000 c00000003d4d9260 c0000000006b5400 c00000003f131618
NIP [c0000000002e1254] .kref_get+0x10/0x2c
LR [c0000000002dfbd8] .kobject_get+0x24/0x40
Call Trace:
[c00000003f0db2d0] [c00000003f0db360] 0xc00000003f0db360 (unreliable)
[c00000003f0db350] [c0000000002e00e8] .kobject_add+0x8c/0x21c
[c00000003f0db3e0] [c000000000344b00] .device_add+0xd4/0x680
[c00000003f0db4a0] [c0000000003a1c4c] .scsi_alloc_target+0x218/0x404
[c00000003f0db570] [c0000000003a1fb4] .__scsi_scan_target+0xa8/0x640
[c00000003f0db6b0] [c0000000003a25c4] .scsi_scan_channel+0x78/0xdc
[c00000003f0db750] [c0000000003a26f8] .scsi_scan_host_selected+0xd0/0x140
[c00000003f0db7f0] [c0000000003c3ff4] .ipr_probe+0x1270/0x1348
[c00000003f0db960] [c0000000002f4808] .pci_device_probe+0x124/0x194
[c00000003f0dba10] [c000000000347e8c] .driver_probe_device+0x110/0x1f0
[c00000003f0dbaa0] [c000000000348014] .__driver_attach+0xa8/0x134
[c00000003f0dbb30] [c0000000003472ac] .bus_for_each_dev+0x80/0xd0
[c00000003f0dbbe0] [c000000000347c14] .driver_attach+0x28/0x40
[c00000003f0dbc60] [c000000000346788] .bus_add_driver+0xfc/0x2d0
[c00000003f0dbd10] [c0000000003482cc] .driver_register+0x80/0x9c
[c00000003f0dbd90] [c0000000002f4bb0] .__pci_register_driver+0x5c/0xcc
[c00000003f0dbe20] [c000000000604b38] .ipr_init+0x38/0x50
[c00000003f0dbea0] [c0000000005d6428] .kernel_init+0x214/0x3ec
[c00000003f0dbf90] [c000000000026734] .kernel_thread+0x4c/0x68
Instruction dump:
e8410028 39200001 38210080 7d234b78 e8010010 ebc1fff0 7c0803a6 4e800020
80030000 7c0007b4 2f800000 409e0008 <0fe00000> 7c001828 30000001



