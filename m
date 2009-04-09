Return-Path: <linux-kernel-owner+w=401wt.eu-S932523AbZDIKDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbZDIKDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbZDIKDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:03:34 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59163 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756193AbZDIKDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:03:33 -0400
X-Sasl-enc: UQUZSI9NS7OzvoMqZcpvKYMTJ7aSJGJIpS2F+1b5xysf 1239271412
Message-ID: <49DDC7F1.3050401@fastmail.fm>
Date: Thu, 09 Apr 2009 11:03:29 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org, kernel-janitors@vger.kernel.org, neilb@suse.de
Subject: Re: [PATCH 21/56] md: Remove void casts
References: <> <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-22-git-send-email-jwjstone@fastma
 il.fm>
In-Reply-To: <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added maintainer CC]
Jack Stone wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  drivers/md/bitmap.c   |    8 ++++----
>  drivers/md/dm-table.c |    4 ++--
>  drivers/md/md.c       |   19 +++++++++----------
>  3 files changed, 15 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index f8a9f7a..2a11c90 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -493,7 +493,7 @@ void bitmap_update_sb(struct bitmap *bitmap)
>  		return;
>  	}
>  	spin_unlock_irqrestore(&bitmap->lock, flags);
> -	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
> +	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
>  	sb->events = cpu_to_le64(bitmap->mddev->events);
>  	if (bitmap->mddev->events < bitmap->events_cleared) {
>  		/* rocking back to read-only */
> @@ -511,7 +511,7 @@ void bitmap_print_sb(struct bitmap *bitmap)
>  
>  	if (!bitmap || !bitmap->sb_page)
>  		return;
> -	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
> +	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
>  	printk(KERN_DEBUG "%s: bitmap file superblock:\n", bmname(bitmap));
>  	printk(KERN_DEBUG "         magic: %08x\n", le32_to_cpu(sb->magic));
>  	printk(KERN_DEBUG "       version: %d\n", le32_to_cpu(sb->version));
> @@ -559,7 +559,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
>  		return err;
>  	}
>  
> -	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
> +	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
>  
>  	chunksize = le32_to_cpu(sb->chunksize);
>  	daemon_sleep = le32_to_cpu(sb->daemon_sleep);
> @@ -646,7 +646,7 @@ static int bitmap_mask_state(struct bitmap *bitmap, enum bitmap_state bits,
>  		return 0;
>  	}
>  	spin_unlock_irqrestore(&bitmap->lock, flags);
> -	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
> +	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
>  	old = le32_to_cpu(sb->state) & bits;
>  	switch (op) {
>  		case MASK_SET: sb->state |= cpu_to_le32(bits);
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index e8361b1..6e57fe2 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -211,7 +211,7 @@ static int alloc_targets(struct dm_table *t, unsigned int num)
>  	 * Append an empty entry to catch sectors beyond the end of
>  	 * the device.
>  	 */
> -	n_highs = (sector_t *) dm_vcalloc(num + 1, sizeof(struct dm_target) +
> +	n_highs = dm_vcalloc(num + 1, sizeof(struct dm_target) +
>  					  sizeof(sector_t));
>  	if (!n_highs)
>  		return -ENOMEM;
> @@ -775,7 +775,7 @@ static int setup_indexes(struct dm_table *t)
>  		total += t->counts[i];
>  	}
>  
> -	indexes = (sector_t *) dm_vcalloc(total, (unsigned long) NODE_SIZE);
> +	indexes = dm_vcalloc(total, (unsigned long) NODE_SIZE);
>  	if (!indexes)
>  		return -ENOMEM;
>  
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ed5727c..22cd6b3 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -767,7 +767,7 @@ static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version
>  	ret = -EINVAL;
>  
>  	bdevname(rdev->bdev, b);
> -	sb = (mdp_super_t*)page_address(rdev->sb_page);
> +	sb = page_address(rdev->sb_page);
>  
>  	if (sb->md_magic != MD_SB_MAGIC) {
>  		printk(KERN_ERR "md: invalid raid superblock magic on %s\n",
> @@ -817,7 +817,7 @@ static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version
>  		ret = 1;
>  	} else {
>  		__u64 ev1, ev2;
> -		mdp_super_t *refsb = (mdp_super_t*)page_address(refdev->sb_page);
> +		mdp_super_t *refsb = page_address(refdev->sb_page);
>  		if (!uuid_equal(refsb, sb)) {
>  			printk(KERN_WARNING "md: %s has different UUID to %s\n",
>  				b, bdevname(refdev->bdev,b2));
> @@ -852,7 +852,7 @@ static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version
>  static int super_90_validate(mddev_t *mddev, mdk_rdev_t *rdev)
>  {
>  	mdp_disk_t *desc;
> -	mdp_super_t *sb = (mdp_super_t *)page_address(rdev->sb_page);
> +	mdp_super_t *sb = page_address(rdev->sb_page);
>  	__u64 ev1 = md_event(sb);
>  
>  	rdev->raid_disk = -1;
> @@ -972,7 +972,7 @@ static void super_90_sync(mddev_t *mddev, mdk_rdev_t *rdev)
>  
>  	rdev->sb_size = MD_SB_BYTES;
>  
> -	sb = (mdp_super_t*)page_address(rdev->sb_page);
> +	sb = page_address(rdev->sb_page);
>  
>  	memset(sb, 0, sizeof(*sb));
>  
> @@ -1166,7 +1166,7 @@ static int super_1_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
>  	if (ret) return ret;
>  
>  
> -	sb = (struct mdp_superblock_1*)page_address(rdev->sb_page);
> +	sb = page_address(rdev->sb_page);
>  
>  	if (sb->magic != cpu_to_le32(MD_SB_MAGIC) ||
>  	    sb->major_version != cpu_to_le32(1) ||
> @@ -1219,8 +1219,7 @@ static int super_1_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
>  		ret = 1;
>  	} else {
>  		__u64 ev1, ev2;
> -		struct mdp_superblock_1 *refsb = 
> -			(struct mdp_superblock_1*)page_address(refdev->sb_page);
> +		struct mdp_superblock_1 *refsb = page_address(refdev->sb_page);
>  
>  		if (memcmp(sb->set_uuid, refsb->set_uuid, 16) != 0 ||
>  		    sb->level != refsb->level ||
> @@ -1258,7 +1257,7 @@ static int super_1_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
>  
>  static int super_1_validate(mddev_t *mddev, mdk_rdev_t *rdev)
>  {
> -	struct mdp_superblock_1 *sb = (struct mdp_superblock_1*)page_address(rdev->sb_page);
> +	struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
>  	__u64 ev1 = le64_to_cpu(sb->events);
>  
>  	rdev->raid_disk = -1;
> @@ -1355,7 +1354,7 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev_t *rdev)
>  	int max_dev, i;
>  	/* make rdev->sb match mddev and rdev data. */
>  
> -	sb = (struct mdp_superblock_1*)page_address(rdev->sb_page);
> +	sb = page_address(rdev->sb_page);
>  
>  	sb->feature_map = 0;
>  	sb->pad0 = 0;
> @@ -1453,7 +1452,7 @@ super_1_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
>  			num_sectors = max_sectors;
>  		rdev->sb_start = sb_start;
>  	}
> -	sb = (struct mdp_superblock_1 *) page_address(rdev->sb_page);
> +	sb = page_address(rdev->sb_page);
>  	sb->data_size = cpu_to_le64(num_sectors);
>  	sb->super_offset = rdev->sb_start;
>  	sb->sb_csum = calc_sb_1_csum(sb);
>   

