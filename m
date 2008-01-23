Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbYAWWMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbYAWWMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 17:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbYAWWMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 17:12:19 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35372 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751951AbYAWWMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:12:17 -0500
Date: Wed, 23 Jan 2008 14:06:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com,
       Andy Whitcroft <apw@shadowen.org>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 30/49] ext4: Convert truncate_mutex to read write
 semaphore.
Message-Id: <20080123140659.5b70ae6b.akpm@linux-foundation.org>
In-Reply-To: <1200970948-17903-31-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
	<1200970948-17903-15-git-send-email-tytso@mit.edu>
	<1200970948-17903-16-git-send-email-tytso@mit.edu>
	<1200970948-17903-17-git-send-email-tytso@mit.edu>
	<1200970948-17903-18-git-send-email-tytso@mit.edu>
	<1200970948-17903-19-git-send-email-tytso@mit.edu>
	<1200970948-17903-20-git-send-email-tytso@mit.edu>
	<1200970948-17903-21-git-send-email-tytso@mit.edu>
	<1200970948-17903-22-git-send-email-tytso@mit.edu>
	<1200970948-17903-23-git-send-email-tytso@mit.edu>
	<1200970948-17903-24-git-send-email-tytso@mit.edu>
	<1200970948-17903-25-git-send-email-tytso@mit.edu>
	<1200970948-17903-26-git-send-email-tytso@mit.edu>
	<1200970948-17903-27-git-send-email-tytso@mit.edu>
	<1200970948-17903-28-git-send-email-tytso@mit.edu>
	<1200970948-17903-29-git-send-email-tytso@mit.edu>
	<1200970948-17903-30-git-send-email-tytso@mit.edu>
	<1200970948-17903-31-git-send-email-tytso@mit.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 21 Jan 2008 22:02:09 -0500 "Theodore Ts'o" <tytso@MIT.EDU> wrote:
> +int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
> +			unsigned long max_blocks, struct buffer_head *bh,
> +			int create, int extend_disksize)
> +{
> +	int retval;
> +	if (create) {
> +		down_write((&EXT4_I(inode)->i_data_sem));
> +	} else {
> +		down_read((&EXT4_I(inode)->i_data_sem));
> +	}
> +	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
> +		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
> +				bh, create, extend_disksize);
> +	} else {
> +		retval = ext4_get_blocks_handle(handle, inode, block,
> +				max_blocks, bh, create, extend_disksize);
> +	}
> +	if (create) {
> +		up_write((&EXT4_I(inode)->i_data_sem));
> +	} else {
> +		up_read((&EXT4_I(inode)->i_data_sem));
> +	}

This function has many unneeded braces.  checkpatch used to detect this
but it seems to have broken.

> +	return retval;
> +}
>  static int ext4_get_block(struct inode *inode, sector_t iblock,
>  			struct buffer_head *bh_result, int create)

Mising newline.
