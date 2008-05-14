Return-Path: <linux-kernel-owner+w=401wt.eu-S1751583AbYENUUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbYENUUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 16:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbYENUUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 16:20:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:51831 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbYENUUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 16:20:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=TSYMQx8jREK9dGSEWaZwEBH2J5eknMaMF6BmnSudxZYckFKPSXMbfiHFmvaTRx0rTp5jLp4dhmd2expI8EpAmTgUaXOkACF7XLynJMAbH5vqz6hgTDee+iGWfV/Ej3P3qxFM8J51aowkv2+7ahsb9jL74zYjbV2AJmzrqIIQPhk=
Date: Thu, 15 May 2008 01:16:00 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.26-rc2-mm1: sloooow mkfs.ext2
Message-ID: <20080514211600.GA4748@martell.zuzino.mipt.ru>
References: <20080514010129.4f672378.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514010129.4f672378.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mkfs.ext2 became kick-ass slow:

+ sudo mkfs.ext2 -F 
mke2fs 1.40.6 (09-Feb-2008)
Warning: 256-byte inodes not usable on older systems
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
9773056 inodes, 39072726 blocks
1953636 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=4294967296
1193 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
	...

Writing inode tables:  193/1193
		       ^^^^
		       counter moves slowly,
		       occasional counting at what seems to be normal
		       speed occur.

160 GB SATA disk, no partitions.
According to sysfs, CFQ is in use, the rest is compiled out.
2.6.26-rc2 is fine, mkfs takes ~1 min.

Slowdown is totally reproducible.


CONFIG_ATA=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=y
CONFIG_ATA_SFF=y
CONFIG_ATA_PIIX=y
CONFIG_PATA_JMICRON=y


/sys/block/sdb/queue/iosched/back_seek_max
16384
/sys/block/sdb/queue/iosched/back_seek_penalty
2
/sys/block/sdb/queue/iosched/fifo_expire_async
250
/sys/block/sdb/queue/iosched/fifo_expire_sync
120
/sys/block/sdb/queue/iosched/quantum
4
/sys/block/sdb/queue/iosched/slice_async
40
/sys/block/sdb/queue/iosched/slice_async_rq
2
/sys/block/sdb/queue/iosched/slice_idle
10
/sys/block/sdb/queue/iosched/slice_sync
100

