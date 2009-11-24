Return-Path: <linux-kernel-owner+w=401wt.eu-S932207AbZKXI0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbZKXI0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 03:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932186AbZKXI0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 03:26:47 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:52089 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139AbZKXI0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 03:26:46 -0500
Date: Tue, 24 Nov 2009 09:26:51 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Karel Zak <kzak@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] partitions: use sector size for EFI GPT
Message-ID: <20091124082651.GM8742@kernel.dk>
References: <1257802611-9889-1-git-send-email-kzak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257802611-9889-1-git-send-email-kzak@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09 2009, Karel Zak wrote:
> Currently, kernel uses strictly 512-byte sectors for EFI GPT parsing.
> That's wrong.
> 
> UEFI standard (version 2.3, May 2009, 5.3.1 GUID Format overview, page
> 95) defines that LBA is always based on the logical block size. It
> means bdev_logical_block_size() (aka BLKSSZGET) for Linux.
> 
> This patch removes static sector size from EFI GPT parser.
> 
> The problem is reproducible with the latest GNU Parted:
> 
>  # modprobe scsi_debug dev_size_mb=50 sector_size=4096
> 
>   # ./parted /dev/sdb print
>   Model: Linux scsi_debug (scsi)
>   Disk /dev/sdb: 52.4MB
>   Sector size (logical/physical): 4096B/4096B
>   Partition Table: gpt
> 
>   Number  Start   End     Size    File system  Name     Flags
>    1      24.6kB  3002kB  2978kB               primary
>    2      3002kB  6001kB  2998kB               primary
>    3      6001kB  9003kB  3002kB               primary
> 
>   # blockdev --rereadpt /dev/sdb
>   # dmesg | tail -1
>    sdb: unknown partition table      <---- !!!
> 
> with this patch:
> 
>   # blockdev --rereadpt /dev/sdb
>   # dmesg | tail -1
>    sdb: sdb1 sdb2 sdb3
> 
> Signed-off-by: Karel Zak <kzak@redhat.com>

I have applied this patch with the division fixup, and 2/2 as well.
Thanks!

-- 
Jens Axboe

