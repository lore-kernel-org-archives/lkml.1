Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbYHVMze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbYHVMze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 08:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbYHVMzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 08:55:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:16303 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbYHVMzV (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 08:55:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TJxZcn5vZeFX9xnBfjlAuQz/RLf9ZOd8Z0NJwIusmAK5edkgZAf9S2ZxhnT7wbQJEu
         lnv7xF8pPtKhQ6/PgHcUXVnysb5te1YetAvMjp9ihVVgd7AuKQlrM4nvipaaMCw6A9YA
         jMjm+eWcnUWCwQcNnTdNLYwrcpoPQtICeqV9o=
Date: Fri, 22 Aug 2008 14:54:40 +0200
From: Bernhard Reutner-Fischer <rep.dot.nop@gmail.com>
To: Jared Hulbert <jaredeh@gmail.com>
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, tim.bird@AM.SONY.COM,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 07/10] AXFS: axfs_bdev.c
Message-ID: <20080822125440.GA1396@mx.loc>
References: <48AD010B.6030209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AD010B.6030209@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 10:45:47PM -0700, Jared Hulbert wrote:
>+/******************************************************************************
>+ *
>+ * axfs_copy_block_data
>+ *
>+ * Description: Helper function to read data from block device
>+ *
>+ * Parameters:
>+ *    (IN) sb - pointer to super block structure.
>+ *
>+ *    (IN) dst_addr - pointer to buffer into which data is to be read.
>+ *
>+ *    (IN) boffset - offset within block device
>+ *
>+ *    (IN) len - length of data to be read
>+ *
>+ * Returns:
>+ *     0 or error number
>+ *
>+ *****************************************************************************/
>+int axfs_copy_block(struct super_block *sb, void *dst_addr, u64 fsoffset,
>+		    u64 len)

mismatch between documentation and implementation WRT the function name ;)


>+{
>+	struct axfs_super *sbi = AXFS_SB(sb);
>+	u64 boffset = AXFS_FSOFFSET_2_DEVOFFSET(sbi, fsoffset);
>+	u64 blocks;
>+	u64 blksize = sb->s_blocksize;
>+	unsigned long dst;
>+	unsigned long src;
>+	sector_t block;
>+	size_t bytes;
>+	struct buffer_head *bh;
>+	u64 copied = 0;
>+
>+	if (len == 0)
>+		return 0;
>+
>+	blocks = len / blksize;
>+	if ((len % blksize) > 0)
>+		blocks += 1;
>+
>+	while (copied < len) {
>+		/* Explicit casting for ARM linker errors. */

did it try to emit some external div()? Is this still needed?
