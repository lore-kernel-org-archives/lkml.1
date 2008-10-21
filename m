Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbYJUQpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbYJUQpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 12:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYJUQpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 12:45:36 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:52682 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbYJUQpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 12:45:34 -0400
Subject: Re: Subject: [PATCH 12/16] Squashfs: header files
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
In-Reply-To: <E1KqrTX-0001y4-JE@dylan>
References: <E1KqrTX-0001y4-JE@dylan>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 12:25:18 -0400
Message-Id: <1224606318.31157.80.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-17 at 16:42 +0100, Phillip Lougher wrote:
[snip]

> +
> +struct squashfs_reg_inode {
> +	__le16			inode_type;
> +	__le16			mode;
> +	__le16			uid;
> +	__le16			guid;
> +	__le32			mtime;
> +	__le32	 		inode_number;
> +	__le32			start_block;
> +	__le32			fragment;
> +	__le32			offset;
> +	__le32			file_size;
> +	__le16			block_list[0];
> +};
> +
> +struct squashfs_lreg_inode {
> +	__le16			inode_type;
> +	__le16			mode;
> +	__le16			uid;
> +	__le16			guid;
> +	__le32			mtime;
> +	__le32	 		inode_number;
> +	__le64			start_block;
> +	__le64			file_size;
> +	__le64			sparse;
> +	__le32			nlink;
> +	__le32			fragment;
> +	__le32			offset;
> +	__le32			xattr;
> +	__le16			block_list[0];
> +};
> +
> +struct squashfs_dir_inode {
> +	__le16			inode_type;
> +	__le16			mode;
> +	__le16			uid;
> +	__le16			guid;
> +	__le32			mtime;
> +	__le32	 		inode_number;
> +	__le32			start_block;
> +	__le32			nlink;
> +	__le16			file_size;
> +	__le16			offset;
> +	__le32			parent_inode;
> +};
> +
> +struct squashfs_ldir_inode {
> +	__le16			inode_type;
> +	__le16			mode;
> +	__le16			uid;
> +	__le16			guid;
> +	__le32			mtime;
> +	__le32	 		inode_number;
> +	__le32			nlink;
> +	__le32			file_size;
> +	__le32			start_block;
> +	__le32			parent_inode;
> +	__le16			i_count;
> +	__le16			offset;
> +	struct squashfs_dir_index	index[0];
> +};
> +
[snip]

Something that seems weird is the inconsistency in the ordering of these
structs. The base part is the same across all inodes but for your
reg/lreg dir/ldir pairs you seem to shuffle the order of the added
parts. Is there a reason for this? Is their layout the same on disk
(baring the extra data in the l versions)? If so they probably should be
the same in the struct.

