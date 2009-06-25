Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbZFYRxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbZFYRxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 13:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZFYRxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 13:53:33 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:54212 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752571AbZFYRxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 13:53:32 -0400
From: Frans Pop <elendil@planet.nl>
To: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [2.6.31-rc1] device-mapper: target device sda6 is misaligned
Date: Thu, 25 Jun 2009 19:53:32 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       martin.petersen@oracle.com
References: <200906250904.57149.elendil@planet.nl> <200906251840.07617.elendil@planet.nl> <20090625172041.GA22891@redhat.com>
In-Reply-To: <20090625172041.GA22891@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906251953.34253.elendil@planet.nl>
X-OriginalArrivalTime: 25 Jun 2009 17:53:34.0748 (UTC) FILETIME=[DC2005C0:01C9F5BD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 June 2009, Mike Snitzer wrote:
> > I'm afraid those files don't exist on my systems (none of them: arm,
> > s390 and x86_64 notebook). Some kernel config option I'm missing
> > maybe?
>
> You should definitely have the topology attributes in the associated
> device's sysfs tree.

Ah, sorry. I'd switched back to .30 for the arm system because of this.
(And on the s390 box I looked for sda instead of dasdb; duh!)

Here are the values for arm:

$ cat /sys/block/sda/sda6/alignment_offset
0
$ cat /sys/block/sda/queue/physical_block_size
512
$ cat /sys/block/sda/queue/logical_block_size
512

And here's the lot for the s390 emulator:

# grep . /sys/block/dasdb/dasdb*/alignment_offset
/sys/block/dasdb/dasdb1/alignment_offset:0
/sys/block/dasdb/dasdb2/alignment_offset:0
# grep . /sys/block/dasdb/queue/physical_block_size
4096
# grep . /sys/block/dasdb/queue/logical_block_size
4096

# pvs -o +pe_start
  PV          VG     Fmt  Attr PSize   PFree 1st PE
  /dev/dasdb1 mordor lvm2 a-   388.00M    0  192.00K
  /dev/dasdb2 mordor lvm2 a-   388.00M    0  192.00K
# dmsetup ls
mordor-home     (254, 0)
# dmsetup table
mordor-home: 0 794624 linear 94:5 384
mordor-home: 794624 794624 linear 94:6 384

# fdasd -p /dev/dasdb
reading volume label ..: VOL1
reading vtoc ..........: ok

Disk /dev/dasdb:
  cylinders ............: 1113
  tracks per cylinder ..: 15
  blocks per track .....: 12
  bytes per block ......: 4096
  volume label .........: VOL1
  volume serial ........: 0X0121
  max partitions .......: 3

 ------------------------------- tracks -------------------------------
               Device      start      end   length   Id  System
          /dev/dasdb1          2     8346     8345    1  Linux native
          /dev/dasdb2       8347    16694     8348    2  Linux native
