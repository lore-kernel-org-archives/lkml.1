Return-Path: <linux-kernel-owner+w=401wt.eu-S1030534AbXBGIlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030534AbXBGIlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 03:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030560AbXBGIlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 03:41:23 -0500
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:48735 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030534AbXBGIlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 03:41:22 -0500
Date: Wed, 7 Feb 2007 09:41:05 +0100
From: Paolo Ornati <ornati@fastwebnet.it>
To: "Trevor Offner Caira" <toc3@cornell.edu>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: Re: PROBLEM: sata timeouts with intel 82801HB on amd64
Message-ID: <20070207094105.7ab1c601@localhost>
In-Reply-To: <34171.74.71.32.29.1170727713.squirrel@webmail.cornell.edu>
References: <34171.74.71.32.29.1170727713.squirrel@webmail.cornell.edu>
X-Mailer: Sylpheed-Claws 2.4.0 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Feb 2007 21:08:33 -0500 (EST)
"Trevor Offner Caira" <toc3@cornell.edu> wrote:

> (1) One-line summary: I'm getting SATA timeouts with Intel 82801HB on amd64.
> 
> (2) Full description: Unless CONFIG_RCU_TORTURE_TEST is set, I get sata
> timeouts of this form periodically:
> 
> ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
> ata1.00: cmd 60/18:00:b3:22:0a/00:00:00:00:00/40 tag 0 cdb 0x0 data 12288 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1: soft resetting port
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: configured for UDMA/133
> ata1: EH complete
> SCSI device sda: 625142448 512-byte hdwr sectors (320073 MB)
> sda: Write Protect is off
> SCSI device sda: write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> 
> This entails complete blocking of all disk i/o (I only have one disk) for
> about 45 seconds. The kernel then negotiates the next lowest transfer
> speed (UDMA/166 all the way down to PIO0, when it errors saying it cannot
> go slower). I get this issue on amd64 kernels only. The issue is only
> present in 2.6.18+, since earlier kernels do not support my chipset at all
> (intel 82801HB).
> 
> Knoppix 5.1.1 does not show this issue (i.e., no disk i/o issues even
> without rcutorture running). However, a native amd64 build of exactly the
> same kernel config shows the issue.
> 
> (3) Keywords: SATA, AHCI, modules, kernel, Intel.
> 

[CUT]

> (8.7) Other information: There's nothing in the system except for the
> DG965WH motherboard, E6600 processor, 1GB of kingston RAM, the ST3320620AS
> hard drive and 430 W PSU.
> 
> Thanks for reading this far! :)


Are you using XFS, right?

Can you see if the problem goes away either:

1) disabling NCQ ("echo 1 > /sys/block/sda/device/queue_depth" in a
boot script)

	OR

2) mounting XFS filesystem(s) with "nobarrier" option

	?


I've seen this problem with very similar hardware (and so I've added
Tejun to CC :).


If mounting XFS with "nobarrier" fixes the problem it seems that more
than one Seagate disk cannot handle the Cache Flush command while other
commands are in fly...

-- 
	Paolo Ornati
	Linux 2.6.20 on x86_64
