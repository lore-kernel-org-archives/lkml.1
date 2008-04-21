Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbYDUWrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbYDUWrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 18:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbYDUWrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 18:47:09 -0400
Received: from relay2.sgi.com ([192.48.171.30]:40953 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753012AbYDUWrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 18:47:07 -0400
Message-ID: <480D1968.5050704@sgi.com>
Date: Mon, 21 Apr 2008 15:47:04 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jack Steiner <steiner@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: PATCH [1/1]: x86:fix i686 panic with the early_per_cpu macro
References: <20080416133114.GL6304@elte.hu> <20080416134502.GA24209@elte.hu> <48061677.1080801@sgi.com> <48062928.6020304@sgi.com> <20080416192527.GA15973@elte.hu> <20080416192713.GA16802@elte.hu> <20080416210033.GA25899@elte.hu> <4807D200.6080103@sgi.com> <20080421154429.GG18452@elte.hu> <480CBA80.1030201@sgi.com> <20080421161627.GA10121@elte.hu> <480CE4BC.2030002@sgi.com>
In-Reply-To: <480CE4BC.2030002@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Ingo Molnar wrote:
>> * Mike Travis <travis@sgi.com> wrote:
>>
>>> ...  Do you 
>>> want me to consolidate the outstanding patches and send them again all 
>>> together?  
...
>> resending would be appreciated, if it's not hard. I had to disable the 
>> early-pointers cleanup patch because of the breakage it caused.
>>
>> 	Ingo
> 

The build tests have passed.  The kernel in all it's variations runs on
my intel box fine but fails on the amd box with boot disk errors.  Here's
what it should say:

    scsi0 : sata_nv
    ata1: SATA max UDMA/133 cmd 0x34d0 ctl 0x34c4 bmdma 0x3490 irq 19
    ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
    ata1.00: ATA-7: WDC WD2500YD-01NVB1, 10.02E01, max UDMA/133
    ata1.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 0/1)
    ata1.00: configured for UDMA/133
    scsi 0:0:0:0: Direct-Access     ATA      WDC WD2500YD-01N 10.0 PQ: 0 ANSI: 5
    sd 0:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
    ...
     sda: sda1 sda2 < sda5 sda6 sda7 sda8 >
    sd 0:0:0:0: [sda] Attached SCSI disk
    sd 0:0:0:0: Attached scsi generic sg0 type 0
    ...
    EXT3-fs: mounted filesystem with ordered data mode.
    VFS: Mounted root (ext3 filesystem) readonly.

But instead it fails:

    scsi0 : sata_nv
    ata1: SATA max UDMA/133 cmd 0x34d0 ctl 0x34c4 bmdma 0x3490 irq 19
    ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
    ...
    Root-NFS: No NFS server available, giving up.
    VFS: Unable to mount root fs via NFS, trying floppy.
    VFS: Insert root floppy and press ENTER

This is linux-2.6 + sched-latest with or without my patches installed
and different configurations including the simplest nosmp.  The root
FS is ok as I can boot an older kernel fine.  I've checked to insure
the file system is configured (ext2 in this case).  [Obviously the sata
driver is config'd.]

Any ideas?

Thanks,
Mike
