Return-Path: <linux-kernel-owner+w=401wt.eu-S1751852AbZIHRDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbZIHRDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 13:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbZIHRDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 13:03:39 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:57113 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbZIHRDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 13:03:39 -0400
X-Mailer: QUALCOMM Windows Eudora Version 7.1.0.9
Date: Tue, 08 Sep 2009 10:03:44 -0700
To: lkml <linux-kernel@vger.kernel.org>
From: jeffunit <jeff@jeffunit.com>
Subject: system hang - I suspect a sata problem - 2.6.30.5 debug kernel
In-Reply-To: <20090908165438.24437.40931.stgit@dhcp-100-2-132.bos.redhat
 .com>
References: <4A99E8CB.1040600@redhat.com>
 <20090908165438.24437.40931.stgit@dhcp-100-2-132.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Message-Id: <20090908170341469.NQO14103@cdptpa-omta02.mail.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a fileserver with a pata boot disk, pata dvd drive, and 7 sata 
disks configured with mdadm to be
a raid-5 array. I am using a supermicro sat2-mv8 pcix controller, 
which has a marvell 88sx6081 controller.
Every few hours, the machine hangs, and I have to power cycle it.

I build a kernel with debugging enabled, version 2.6.30.5
Here are the last few messages from syslog. I suspect they are from 
the ata layer.
I would appreciate any advise.

jeff

Sep  8 09:13:26 sata_fileserver klogd: ata8: exception Emask 0x10 
SAct 0x0 SErr 0x180000 action 0x6 frozen
Sep  8 09:13:26 sata_fileserver klogd: ata8: edma_err_cause=02000020 
pp_flags=00000003, SError=00180000
Sep  8 09:13:26 sata_fileserver klogd: ata8: SError: { 10B8B Dispar }
Sep  8 09:13:26 sata_fileserver klogd: ata8: hard resetting link
Sep  8 09:13:26 sata_fileserver klogd: ata3: exception Emask 0x10 
SAct 0x0 SErr 0x100000 action 0x6 frozen
Sep  8 09:13:26 sata_fileserver klogd: ata3: edma_err_cause=02000020 
pp_flags=00000003, SError=00100000
Sep  8 09:13:26 sata_fileserver klogd: ata3: SError: { Dispar }
Sep  8 09:13:26 sata_fileserver klogd: ata3: hard resetting link
Sep  8 09:13:26 sata_fileserver klogd: ata5: exception Emask 0x10 
SAct 0x0 SErr 0x100000 action 0x6 frozen
Sep  8 09:13:26 sata_fileserver klogd: ata5: edma_err_cause=02000020 
pp_flags=00000003, SError=00100000
Sep  8 09:13:26 sata_fileserver klogd: ata5: SError: { Dispar }
Sep  8 09:13:26 sata_fileserver klogd: ata5: hard resetting link
Sep  8 09:13:26 sata_fileserver klogd: ata7: exception Emask 0x10 
SAct 0x0 SErr 0x100000 action 0x6 frozen
Sep  8 09:13:26 sata_fileserver klogd: ata7: edma_err_cause=02000020 
pp_flags=00000003, SError=00100000
Sep  8 09:13:26 sata_fileserver klogd: ata7: SError: { Dispar }
Sep  8 09:13:26 sata_fileserver klogd: ata7: hard resetting link
Sep  8 09:13:26 sata_fileserver klogd: ata3: SATA link up 3.0 Gbps 
(SStatus 123 SControl 300)
Sep  8 09:13:26 sata_fileserver klogd: ata8: SATA link up 3.0 Gbps 
(SStatus 123 SControl 300)
Sep  8 09:13:26 sata_fileserver klogd: ata8.00: failed to IDENTIFY 
(I/O error, err_mask=0x40)
Sep  8 09:13:26 sata_fileserver klogd: ata8.00: revalidation failed (errno=-5)
Sep  8 09:13:27 sata_fileserver klogd: ata3.00: configured for UDMA/133
Sep  8 09:13:27 sata_fileserver klogd: ata3: EH complete
Sep  8 09:13:27 sata_fileserver klogd: ata5: SATA link up 3.0 Gbps 
(SStatus 123 SControl 300)
Sep  8 09:13:27 sata_fileserver klogd: ata7: SATA link up 3.0 Gbps 
(SStatus 123 SControl 300)
Sep  8 09:13:27 sata_fileserver klogd: ata7.00: configured for UDMA/133
Sep  8 09:13:27 sata_fileserver klogd: ata7: EH complete
Sep  8 09:13:27 sata_fileserver klogd: ata5.00: configured for UDMA/133
Sep  8 09:13:27 sata_fileserver klogd: ata5: EH complete
Sep  8 09:13:31 sata_fileserver klogd: ata8: hard resetting link
Sep  8 09:13:32 sata_fileserver klogd: ata8: SATA link up 3.0 Gbps 
(SStatus 123 SControl 300)
Sep  8 09:13:32 sata_fileserver klogd: ata8.00: configured for UDMA/133
Sep  8 09:13:32 sata_fileserver klogd: ata8: exception Emask 0x10 
SAct 0x0 SErr 0x0 action 0x1 t4
Sep  8 09:13:32 sata_fileserver klogd: ata8: edma_err_cause=00000020 
pp_flags=00000000, SError=00080000
Sep  8 09:13:32 sata_fileserver klogd: ata8.00: configured for UDMA/133
Sep  8 09:13:32 sata_fileserver klogd: ata8: EH complete
Sep  8 09:21:34 sata_fileserver syslogd 1.5.0: restart.

