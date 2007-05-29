Return-Path: <linux-kernel-owner+w=401wt.eu-S1762426AbXE2Box@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762426AbXE2Box (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 21:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbXE2Bop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 21:44:45 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:21357 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbXE2Boo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 21:44:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Cd0STuZEZNSIGOgfZY+6Nlgqo3vmlWIq7/XjzF0v/LefWmZN3/j30anEK70UZPkaIar5cbpkEwiiIB5wR6/EbyLhkT9Kv9QoFPe/kOpjWfjx9oENCT4koQVs6dZn/X0ZoXG32O8YKRi5FdqTwkZgU8D8OynCq5E0dnjyrmYrbgg=
Date: Tue, 29 May 2007 09:44:58 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] UDF: coding style conversion - lindent
Message-ID: <20070529014458.GC2218@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: Cyrill Gorcunov <gorcunov@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
References: <20070528143038.GB8766@cvg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070528143038.GB8766@cvg>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 06:30:38PM +0400, Cyrill Gorcunov wrote:
>This patch converts UDF coding style to kernel
>coding style using Lindent.
>
>Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>---
>
> fs/udf/balloc.c    |  709 ++++++++++++-----------
> fs/udf/crc.c       |   19 +-
> fs/udf/dir.c       |  132 ++---
> fs/udf/directory.c |  207 ++++----
> fs/udf/ecma_167.h  |  875 +++++++++++++---------------
> fs/udf/file.c      |  114 ++--
> fs/udf/fsync.c     |    4 +-
> fs/udf/ialloc.c    |   69 ++--
> fs/udf/inode.c     | 1494 ++++++++++++++++++++++++-----------------------
> fs/udf/lowlevel.c  |   25 +-
> fs/udf/misc.c      |  172 +++---
> fs/udf/namei.c     |  720 +++++++++++------------
> fs/udf/osta_udf.h  |  239 ++++----
> fs/udf/partition.c |  273 ++++++----
> fs/udf/super.c     | 1630 ++++++++++++++++++++++++++++------------------------
> fs/udf/symlink.c   |   56 +-
> fs/udf/truncate.c  |  230 +++++----
> fs/udf/udf_i.h     |    2 +-
> fs/udf/udf_sb.h    |    6 +-
> fs/udf/udfdecl.h   |  106 +++--
> fs/udf/udfend.h    |    2 +-
> fs/udf/udftime.c   |   93 ++--
> fs/udf/unicode.c   |  299 +++++------
> 23 files changed, 3812 insertions(+), 3664 deletions(-)
>
>diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
>index 4cec910..ef48d09 100644
>--- a/fs/udf/balloc.c
>+++ b/fs/udf/balloc.c
>@@ -41,18 +41,17 @@
> #define uint(x) xuint(x)
> #define xuint(x) __le ## x
> 
>-static inline int find_next_one_bit (void * addr, int size, int offset)
>+static inline int find_next_one_bit(void *addr, int size, int offset)
> {
>-	uintBPL_t * p = ((uintBPL_t *) addr) + (offset / BITS_PER_LONG);
>-	int result = offset & ~(BITS_PER_LONG-1);
>+	uintBPL_t *p = ((uintBPL_t *) addr) + (offset / BITS_PER_LONG);
>+	int result = offset & ~(BITS_PER_LONG - 1);
> 	unsigned long tmp;
> 
> 	if (offset >= size)
> 		return size;
> 	size -= result;
>-	offset &= (BITS_PER_LONG-1);
>-	if (offset)
>-	{
>+	offset &= (BITS_PER_LONG - 1);
>+	if (offset) {
> 		tmp = leBPL_to_cpup(p++);
> 		tmp &= ~0UL << offset;
> 		if (size < BITS_PER_LONG)
>@@ -62,8 +61,7 @@ static inline int find_next_one_bit (void * addr, int size, int offset)
> 		size -= BITS_PER_LONG;
> 		result += BITS_PER_LONG;
> 	}
>-	while (size & ~(BITS_PER_LONG-1))
>-	{
>+	while (size & ~(BITS_PER_LONG - 1)) {
> 		if ((tmp = leBPL_to_cpup(p++)))
> 			goto found_middle;
> 		result += BITS_PER_LONG;
>@@ -72,17 +70,18 @@ static inline int find_next_one_bit (void * addr, int size, int offset)
> 	if (!size)
> 		return result;
> 	tmp = leBPL_to_cpup(p);
>-found_first:
>-	tmp &= ~0UL >> (BITS_PER_LONG-size);
>-found_middle:
>+      found_first:
>+	tmp &= ~0UL >> (BITS_PER_LONG - size);
>+      found_middle:


I doubt about this change. First, it seems that you replace a tab with whitespaces. Second, IMO, the labels should not be aligned with the statements.


> 	return result + ffz(~tmp);
> }
> 
> #define find_first_one_bit(addr, size)\
> 	find_next_one_bit((addr), (size), 0)
> 
>-static int read_block_bitmap(struct super_block * sb,
>-	struct udf_bitmap *bitmap, unsigned int block, unsigned long bitmap_nr)
>+static int read_block_bitmap(struct super_block *sb,
>+			     struct udf_bitmap *bitmap, unsigned int block,
>+			     unsigned long bitmap_nr)
> {
> 	struct buffer_head *bh = NULL;
> 	int retval = 0;
>@@ -92,38 +91,39 @@ static int read_block_bitmap(struct super_block * sb,
> 	loc.partitionReferenceNum = UDF_SB_PARTITION(sb);
> 
> 	bh = udf_tread(sb, udf_get_lb_pblock(sb, loc, block));
>-	if (!bh)
>-	{
>+	if (!bh) {
> 		retval = -EIO;
> 	}
> 	bitmap->s_block_bitmap[bitmap_nr] = bh;
> 	return retval;
> }
> 
>-static int __load_block_bitmap(struct super_block * sb,
>-	struct udf_bitmap *bitmap, unsigned int block_group)
>+static int __load_block_bitmap(struct super_block *sb,
>+			       struct udf_bitmap *bitmap,
>+			       unsigned int block_group)
> {
> 	int retval = 0;
> 	int nr_groups = bitmap->s_nr_groups;
> 
>-	if (block_group >= nr_groups)
>-	{
>-		udf_debug("block_group (%d) > nr_groups (%d)\n", block_group, nr_groups);
>+	if (block_group >= nr_groups) {
>+		udf_debug("block_group (%d) > nr_groups (%d)\n", block_group,
>+			  nr_groups);
> 	}
> 
> 	if (bitmap->s_block_bitmap[block_group])
> 		return block_group;
>-	else
>-	{
>-		retval = read_block_bitmap(sb, bitmap, block_group, block_group);
>+	else {
>+		retval =
>+		    read_block_bitmap(sb, bitmap, block_group, block_group);
> 		if (retval < 0)
> 			return retval;
> 		return block_group;
> 	}
> }
> 
>-static inline int load_block_bitmap(struct super_block * sb,
>-	struct udf_bitmap *bitmap, unsigned int block_group)
>+static inline int load_block_bitmap(struct super_block *sb,
>+				    struct udf_bitmap *bitmap,
>+				    unsigned int block_group)
> {
> 	int slot;
> 
>@@ -138,13 +138,14 @@ static inline int load_block_bitmap(struct super_block * sb,
> 	return slot;
> }
> 
>-static void udf_bitmap_free_blocks(struct super_block * sb,
>-	struct inode * inode,
>-	struct udf_bitmap *bitmap,
>-	kernel_lb_addr bloc, uint32_t offset, uint32_t count)
>+static void udf_bitmap_free_blocks(struct super_block *sb,
>+				   struct inode *inode,
>+				   struct udf_bitmap *bitmap,
>+				   kernel_lb_addr bloc, uint32_t offset,
>+				   uint32_t count)
> {
> 	struct udf_sb_info *sbi = UDF_SB(sb);
>-	struct buffer_head * bh = NULL;
>+	struct buffer_head *bh = NULL;
> 	unsigned long block;
> 	unsigned long block_group;
> 	unsigned long bit;
>@@ -154,17 +155,22 @@ static void udf_bitmap_free_blocks(struct super_block * sb,
> 
> 	mutex_lock(&sbi->s_alloc_mutex);
> 	if (bloc.logicalBlockNum < 0 ||
>-		(bloc.logicalBlockNum + count) > UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum))
>-	{
>-		udf_debug("%d < %d || %d + %d > %d\n",
>-			bloc.logicalBlockNum, 0, bloc.logicalBlockNum, count,
>-			UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum));
>+	    (bloc.logicalBlockNum + count) > UDF_SB_PARTLEN(sb,
>+							    bloc.
>+							    partitionReferenceNum))
>+	{
>+		udf_debug("%d < %d || %d + %d > %d\n", bloc.logicalBlockNum, 0,
>+			  bloc.logicalBlockNum, count, UDF_SB_PARTLEN(sb,
>+								      bloc.
>+								      partitionReferenceNum));
> 		goto error_return;
> 	}
> 
>-	block = bloc.logicalBlockNum + offset + (sizeof(struct spaceBitmapDesc) << 3);
>+	block =
>+	    bloc.logicalBlockNum + offset +
>+	    (sizeof(struct spaceBitmapDesc) << 3);
> 
>-do_more:
>+      do_more:
> 	overflow = 0;
> 	block_group = block >> (sb->s_blocksize_bits + 3);
> 	bit = block % (sb->s_blocksize << 3);
>@@ -172,8 +178,7 @@ do_more:
> 	/*
> 	 * Check to see if we are freeing blocks across a group boundary.
> 	 */
>-	if (bit + count > (sb->s_blocksize << 3))
>-	{
>+	if (bit + count > (sb->s_blocksize << 3)) {
> 		overflow = bit + count - (sb->s_blocksize << 3);
> 		count -= overflow;
> 	}
>@@ -182,32 +187,31 @@ do_more:
> 		goto error_return;
> 
> 	bh = bitmap->s_block_bitmap[bitmap_nr];
>-	for (i=0; i < count; i++)
>-	{
>-		if (udf_set_bit(bit + i, bh->b_data))
>-		{
>+	for (i = 0; i < count; i++) {
>+		if (udf_set_bit(bit + i, bh->b_data)) {
> 			udf_debug("bit %ld already set\n", bit + i);
>-			udf_debug("byte=%2x\n", ((char *)bh->b_data)[(bit + i) >> 3]);
>-		}
>-		else
>-		{
>+			udf_debug("byte=%2x\n",
>+				  ((char *)bh->b_data)[(bit + i) >> 3]);
>+		} else {
> 			if (inode)
> 				DQUOT_FREE_BLOCK(inode, 1);
>-			if (UDF_SB_LVIDBH(sb))
>-			{
>-				UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)] =
>-					cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)])+1);
>+			if (UDF_SB_LVIDBH(sb)) {
>+				UDF_SB_LVID(sb)->
>+				    freeSpaceTable[UDF_SB_PARTITION(sb)] =
>+				    cpu_to_le32(le32_to_cpu
>+						(UDF_SB_LVID(sb)->
>+						 freeSpaceTable[UDF_SB_PARTITION
>+								(sb)]) + 1);
> 			}
> 		}
> 	}
> 	mark_buffer_dirty(bh);
>-	if (overflow)
>-	{
>+	if (overflow) {
> 		block += count;
> 		count = overflow;
> 		goto do_more;
> 	}
>-error_return:
>+      error_return:
> 	sb->s_dirt = 1;
> 	if (UDF_SB_LVIDBH(sb))
> 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
>@@ -215,10 +219,11 @@ error_return:
> 	return;
> }
> 
>-static int udf_bitmap_prealloc_blocks(struct super_block * sb,
>-	struct inode * inode,
>-	struct udf_bitmap *bitmap, uint16_t partition, uint32_t first_block,
>-	uint32_t block_count)
>+static int udf_bitmap_prealloc_blocks(struct super_block *sb,
>+				      struct inode *inode,
>+				      struct udf_bitmap *bitmap,
>+				      uint16_t partition, uint32_t first_block,
>+				      uint32_t block_count)
> {
> 	struct udf_sb_info *sbi = UDF_SB(sb);
> 	int alloc_count = 0;
>@@ -233,9 +238,10 @@ static int udf_bitmap_prealloc_blocks(struct super_block * sb,
> 	if (first_block + block_count > UDF_SB_PARTLEN(sb, partition))
> 		block_count = UDF_SB_PARTLEN(sb, partition) - first_block;
> 
>-repeat:
>+      repeat:
> 	nr_groups = (UDF_SB_PARTLEN(sb, partition) +
>-		(sizeof(struct spaceBitmapDesc) << 3) + (sb->s_blocksize * 8) - 1) / (sb->s_blocksize * 8);
>+		     (sizeof(struct spaceBitmapDesc) << 3) +
>+		     (sb->s_blocksize * 8) - 1) / (sb->s_blocksize * 8);
> 	block = first_block + (sizeof(struct spaceBitmapDesc) << 3);
> 	block_group = block >> (sb->s_blocksize_bits + 3);
> 	group_start = block_group ? 0 : sizeof(struct spaceBitmapDesc);
>@@ -247,31 +253,30 @@ repeat:
> 
> 	bit = block % (sb->s_blocksize << 3);
> 
>-	while (bit < (sb->s_blocksize << 3) && block_count > 0)
>-	{
>+	while (bit < (sb->s_blocksize << 3) && block_count > 0) {
> 		if (!udf_test_bit(bit, bh->b_data))
> 			goto out;
> 		else if (DQUOT_PREALLOC_BLOCK(inode, 1))
> 			goto out;
>-		else if (!udf_clear_bit(bit, bh->b_data))
>-		{
>+		else if (!udf_clear_bit(bit, bh->b_data)) {
> 			udf_debug("bit already cleared for block %d\n", bit);
> 			DQUOT_FREE_BLOCK(inode, 1);
> 			goto out;
> 		}
>-		block_count --;
>-		alloc_count ++;
>-		bit ++;
>-		block ++;
>+		block_count--;
>+		alloc_count++;
>+		bit++;
>+		block++;
> 	}
> 	mark_buffer_dirty(bh);
> 	if (block_count > 0)
> 		goto repeat;
>-out:
>-	if (UDF_SB_LVIDBH(sb))
>-	{
>+      out:
>+	if (UDF_SB_LVIDBH(sb)) {
> 		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
>-			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition])-alloc_count);
>+		    cpu_to_le32(le32_to_cpu
>+				(UDF_SB_LVID(sb)->freeSpaceTable[partition]) -
>+				alloc_count);
> 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
> 	}
> 	sb->s_dirt = 1;
>@@ -279,12 +284,13 @@ out:
> 	return alloc_count;
> }
> 
>-static int udf_bitmap_new_block(struct super_block * sb,
>-	struct inode * inode,
>-	struct udf_bitmap *bitmap, uint16_t partition, uint32_t goal, int *err)
>+static int udf_bitmap_new_block(struct super_block *sb,
>+				struct inode *inode,
>+				struct udf_bitmap *bitmap, uint16_t partition,
>+				uint32_t goal, int *err)
> {
> 	struct udf_sb_info *sbi = UDF_SB(sb);
>-	int newbit, bit=0, block, block_group, group_start;
>+	int newbit, bit = 0, block, block_group, group_start;
> 	int end_goal, nr_groups, bitmap_nr, i;
> 	struct buffer_head *bh = NULL;
> 	char *ptr;
>@@ -293,7 +299,7 @@ static int udf_bitmap_new_block(struct super_block * sb,
> 	*err = -ENOSPC;
> 	mutex_lock(&sbi->s_alloc_mutex);
> 
>-repeat:
>+      repeat:
> 	if (goal < 0 || goal >= UDF_SB_PARTLEN(sb, partition))
> 		goal = 0;
> 
>@@ -306,38 +312,39 @@ repeat:
> 	if (bitmap_nr < 0)
> 		goto error_return;
> 	bh = bitmap->s_block_bitmap[bitmap_nr];
>-	ptr = memscan((char *)bh->b_data + group_start, 0xFF, sb->s_blocksize - group_start);
>+	ptr =
>+	    memscan((char *)bh->b_data + group_start, 0xFF,
>+		    sb->s_blocksize - group_start);
> 
>-	if ((ptr - ((char *)bh->b_data)) < sb->s_blocksize)
>-	{
>+	if ((ptr - ((char *)bh->b_data)) < sb->s_blocksize) {
> 		bit = block % (sb->s_blocksize << 3);
> 
>-		if (udf_test_bit(bit, bh->b_data))
>-		{
>+		if (udf_test_bit(bit, bh->b_data)) {
> 			goto got_block;
> 		}
> 		end_goal = (bit + 63) & ~63;
> 		bit = udf_find_next_one_bit(bh->b_data, end_goal, bit);
> 		if (bit < end_goal)
> 			goto got_block;
>-		ptr = memscan((char *)bh->b_data + (bit >> 3), 0xFF, sb->s_blocksize - ((bit + 7) >> 3));
>+		ptr =
>+		    memscan((char *)bh->b_data + (bit >> 3), 0xFF,
>+			    sb->s_blocksize - ((bit + 7) >> 3));
> 		newbit = (ptr - ((char *)bh->b_data)) << 3;
>-		if (newbit < sb->s_blocksize << 3)
>-		{
>+		if (newbit < sb->s_blocksize << 3) {
> 			bit = newbit;
> 			goto search_back;
> 		}
>-		newbit = udf_find_next_one_bit(bh->b_data, sb->s_blocksize << 3, bit);
>-		if (newbit < sb->s_blocksize << 3)
>-		{
>+		newbit =
>+		    udf_find_next_one_bit(bh->b_data, sb->s_blocksize << 3,
>+					  bit);
>+		if (newbit < sb->s_blocksize << 3) {
> 			bit = newbit;
> 			goto got_block;
> 		}
> 	}
> 
>-	for (i=0; i<(nr_groups*2); i++)
>-	{
>-		block_group ++;
>+	for (i = 0; i < (nr_groups * 2); i++) {
>+		block_group++;
> 		if (block_group >= nr_groups)
> 			block_group = 0;
> 		group_start = block_group ? 0 : sizeof(struct spaceBitmapDesc);
>@@ -346,67 +353,69 @@ repeat:
> 		if (bitmap_nr < 0)
> 			goto error_return;
> 		bh = bitmap->s_block_bitmap[bitmap_nr];
>-		if (i < nr_groups)
>-		{
>-			ptr = memscan((char *)bh->b_data + group_start, 0xFF, sb->s_blocksize - group_start);
>-			if ((ptr - ((char *)bh->b_data)) < sb->s_blocksize)
>-			{
>+		if (i < nr_groups) {
>+			ptr =
>+			    memscan((char *)bh->b_data + group_start, 0xFF,
>+				    sb->s_blocksize - group_start);
>+			if ((ptr - ((char *)bh->b_data)) < sb->s_blocksize) {
> 				bit = (ptr - ((char *)bh->b_data)) << 3;
> 				break;
> 			}
>-		}
>-		else
>-		{
>-			bit = udf_find_next_one_bit((char *)bh->b_data, sb->s_blocksize << 3, group_start << 3);
>+		} else {
>+			bit =
>+			    udf_find_next_one_bit((char *)bh->b_data,
>+						  sb->s_blocksize << 3,
>+						  group_start << 3);
> 			if (bit < sb->s_blocksize << 3)
> 				break;
> 		}
> 	}
>-	if (i >= (nr_groups*2))
>-	{
>+	if (i >= (nr_groups * 2)) {
> 		mutex_unlock(&sbi->s_alloc_mutex);
> 		return newblock;
> 	}
> 	if (bit < sb->s_blocksize << 3)
> 		goto search_back;
> 	else
>-		bit = udf_find_next_one_bit(bh->b_data, sb->s_blocksize << 3, group_start << 3);
>-	if (bit >= sb->s_blocksize << 3)
>-	{
>+		bit =
>+		    udf_find_next_one_bit(bh->b_data, sb->s_blocksize << 3,
>+					  group_start << 3);
>+	if (bit >= sb->s_blocksize << 3) {
> 		mutex_unlock(&sbi->s_alloc_mutex);
> 		return 0;
> 	}
> 
>-search_back:
>-	for (i=0; i<7 && bit > (group_start << 3) && udf_test_bit(bit - 1, bh->b_data); i++, bit--);
>+      search_back:
>+	for (i = 0;
>+	     i < 7 && bit > (group_start << 3)
>+	     && udf_test_bit(bit - 1, bh->b_data); i++, bit--) ;
> 
>-got_block:
>+      got_block:
> 
> 	/*
> 	 * Check quota for allocation of this block.
> 	 */
>-	if (inode && DQUOT_ALLOC_BLOCK(inode, 1))
>-	{
>+	if (inode && DQUOT_ALLOC_BLOCK(inode, 1)) {
> 		mutex_unlock(&sbi->s_alloc_mutex);
> 		*err = -EDQUOT;
> 		return 0;
> 	}
> 
> 	newblock = bit + (block_group << (sb->s_blocksize_bits + 3)) -
>-		(sizeof(struct spaceBitmapDesc) << 3);
>+	    (sizeof(struct spaceBitmapDesc) << 3);
> 
>-	if (!udf_clear_bit(bit, bh->b_data))
>-	{
>+	if (!udf_clear_bit(bit, bh->b_data)) {
> 		udf_debug("bit already cleared for block %d\n", bit);
> 		goto repeat;
> 	}
> 
> 	mark_buffer_dirty(bh);
> 
>-	if (UDF_SB_LVIDBH(sb))
>-	{
>+	if (UDF_SB_LVIDBH(sb)) {
> 		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
>-			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition])-1);
>+		    cpu_to_le32(le32_to_cpu
>+				(UDF_SB_LVID(sb)->freeSpaceTable[partition]) -
>+				1);
> 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
> 	}
> 	sb->s_dirt = 1;
>@@ -414,16 +423,17 @@ got_block:
> 	*err = 0;
> 	return newblock;
> 
>-error_return:
>+      error_return:

Also here.

<snip>

> 
>-error_return:
>+      error_return:

Here again.

<snip>

> 
>-#endif /* defined(TEST) */
>+#endif				/* defined(TEST) */

Is this necessary?


