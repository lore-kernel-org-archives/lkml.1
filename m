Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbYDCMXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbYDCMXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 08:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbYDCMXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 08:23:35 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:27021 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750748AbYDCMXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 08:23:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jr2JlB9iuU/6USyJKb93gmFYxqj5DPxnMjyQ8LQ/oIvU1QuSQCk2g+rtlv9sJey9Aim5DekaTAO9OlNPHATzwT/LpffCuMMts8HfG5dEuh7s39k4Du+87yJ1vZLexRlB5DaPak8HUiw2ku2pOjGMddkVT/9oys865ASjFE0XOg8=  ;
X-YMail-OSG: Ma4Kxv4VM1mO.sHJWiQgv0..eRqnmoxLAuWB1oe2qo_khHaX.2X_Igoknsvamj95GXC13VFt7Q--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: Re: [PATCH] Modify RAMDISK (brd) device to be able to manage partitions
Date: Thu, 3 Apr 2008 23:23:23 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <12072230943942-git-send-email-Laurent.Vivier@bull.net>
In-Reply-To: <12072230943942-git-send-email-Laurent.Vivier@bull.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804032323.24088.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 April 2008 22:44, Laurent Vivier wrote:
> This patch adds partition management for Block RAM Device (BRD).
>
> This patch is done to keep in sync BRD and loop device drivers.

Hi Laurent,

Thanks very much for this. I will ensure Andrew gets this.

Nick

>
> This patch adds a parameter to the module, max_part, to specify
> the maximum number of partitions per RAM device.
>
> Example:
>
> # modprobe brd max_part=63
> # ls -l /dev/ram*
> brw-rw---- 1 root disk 1,   0 2008-04-03 13:39 /dev/ram0
> brw-rw---- 1 root disk 1,  64 2008-04-03 13:39 /dev/ram1
> brw-rw---- 1 root disk 1, 640 2008-04-03 13:39 /dev/ram10
> brw-rw---- 1 root disk 1, 704 2008-04-03 13:39 /dev/ram11
> brw-rw---- 1 root disk 1, 768 2008-04-03 13:39 /dev/ram12
> brw-rw---- 1 root disk 1, 832 2008-04-03 13:39 /dev/ram13
> brw-rw---- 1 root disk 1, 896 2008-04-03 13:39 /dev/ram14
> brw-rw---- 1 root disk 1, 960 2008-04-03 13:39 /dev/ram15
> brw-rw---- 1 root disk 1, 128 2008-04-03 13:39 /dev/ram2
> brw-rw---- 1 root disk 1, 192 2008-04-03 13:39 /dev/ram3
> brw-rw---- 1 root disk 1, 256 2008-04-03 13:39 /dev/ram4
> brw-rw---- 1 root disk 1, 320 2008-04-03 13:39 /dev/ram5
> brw-rw---- 1 root disk 1, 384 2008-04-03 13:39 /dev/ram6
> brw-rw---- 1 root disk 1, 448 2008-04-03 13:39 /dev/ram7
> brw-rw---- 1 root disk 1, 512 2008-04-03 13:39 /dev/ram8
> brw-rw---- 1 root disk 1, 576 2008-04-03 13:39 /dev/ram9
> # fdisk /dev/ram0
> Device contains neither a valid DOS partition table, nor Sun, SGI or OSF
> disklabel Building a new DOS disklabel. Changes will remain in memory only,
> until you decide to write them. After that, of course, the previous
> content won't be recoverable.
>
> Warning: invalid flag 0x0000 of partition table 4 will be corrected by
> w(rite)
>
> Command (m for help): o
> Building a new DOS disklabel. Changes will remain in memory only,
> until you decide to write them. After that, of course, the previous
> content won't be recoverable.
>
> Warning: invalid flag 0x0000 of partition table 4 will be corrected by
> w(rite)
>
> Command (m for help): n
> Command action
>    e   extended
>    p   primary partition (1-4)
> p
> Partition number (1-4): 1
> First cylinder (1-2, default 1): 1
> Last cylinder or +size or +sizeM or +sizeK (1-2, default 2): 2
>
> Command (m for help): w
> The partition table has been altered!
>
> Calling ioctl() to re-read partition table.
> Syncing disks.
> # ls -l /dev/ram0*
> brw-rw---- 1 root disk 1, 0 2008-04-03 13:40 /dev/ram0
> brw-rw---- 1 root disk 1, 1 2008-04-03 13:40 /dev/ram0p1
> # mkfs /dev/ram0p1
> mke2fs 1.40-WIP (14-Nov-2006)
> Filesystem label=
> OS type: Linux
> Block size=1024 (log=0)
> Fragment size=1024 (log=0)
> 4016 inodes, 16032 blocks
> 801 blocks (5.00%) reserved for the super user
> First data block=1
> Maximum filesystem blocks=16515072
> 2 block groups
> 8192 blocks per group, 8192 fragments per group
> 2008 inodes per group
> Superblock backups stored on blocks:
> 	8193
>
> Writing inode tables: done
> Writing superblocks and filesystem accounting information: done
>
> This filesystem will be automatically checked every 26 mounts or
> 180 days, whichever comes first.  Use tune2fs -c or -i to override.
> # mount /dev/ram0p1 /mnt
> df /mnt
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/ram0p1              15521       138     14582   1% /mnt
> # ls -l /mnt
> total 12
> drwx------ 2 root root 12288 2008-04-03 13:41 lost+found
> # umount /mnt
> # rmmod brd
>
> Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
> ---
>  drivers/block/brd.c |   19 ++++++++++++++-----
>  1 files changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> index 8536480..8baf781 100644
> --- a/drivers/block/brd.c
> +++ b/drivers/block/brd.c
> @@ -386,10 +386,14 @@ static struct block_device_operations brd_fops = {
>   */
>  static int rd_nr;
>  int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
> +static int max_part;
> +static int part_shift;
>  module_param(rd_nr, int, 0);
>  MODULE_PARM_DESC(rd_nr, "Maximum number of brd devices");
>  module_param(rd_size, int, 0);
>  MODULE_PARM_DESC(rd_size, "Size of each RAM disk in kbytes.");
> +module_param(max_part, int, 0);
> +MODULE_PARM_DESC(max_part, "Maximum number of partitions per RAM disk");
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS_BLOCKDEV_MAJOR(RAMDISK_MAJOR);
>
> @@ -434,11 +438,11 @@ static struct brd_device *brd_alloc(int i)
>  	blk_queue_max_sectors(brd->brd_queue, 1024);
>  	blk_queue_bounce_limit(brd->brd_queue, BLK_BOUNCE_ANY);
>
> -	disk = brd->brd_disk = alloc_disk(1);
> +	disk = brd->brd_disk = alloc_disk(1 << part_shift);
>  	if (!disk)
>  		goto out_free_queue;
>  	disk->major		= RAMDISK_MAJOR;
> -	disk->first_minor	= i;
> +	disk->first_minor	= i << part_shift;
>  	disk->fops		= &brd_fops;
>  	disk->private_data	= brd;
>  	disk->queue		= brd->brd_queue;
> @@ -522,7 +526,12 @@ static int __init brd_init(void)
>  	 *     themselves and have kernel automatically instantiate actual
>  	 *     device on-demand.
>  	 */
> -	if (rd_nr > 1UL << MINORBITS)
> +
> +	part_shift = 0;
> +	if (max_part > 0)
> +		part_shift = fls(max_part);
> +
> +	if (rd_nr > 1UL << (MINORBITS - part_shift))
>  		return -EINVAL;
>
>  	if (rd_nr) {
> @@ -530,7 +539,7 @@ static int __init brd_init(void)
>  		range = rd_nr;
>  	} else {
>  		nr = CONFIG_BLK_DEV_RAM_COUNT;
> -		range = 1UL << MINORBITS;
> +		range = 1UL << (MINORBITS - part_shift);
>  	}
>
>  	if (register_blkdev(RAMDISK_MAJOR, "ramdisk"))
> @@ -569,7 +578,7 @@ static void __exit brd_exit(void)
>  	unsigned long range;
>  	struct brd_device *brd, *next;
>
> -	range = rd_nr ? rd_nr :  1UL << MINORBITS;
> +	range = rd_nr ? rd_nr :  1UL << (MINORBITS - part_shift);
>
>  	list_for_each_entry_safe(brd, next, &brd_devices, brd_list)
>  		brd_del_one(brd);
