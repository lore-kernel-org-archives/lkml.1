Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0CGTsf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 14:48:35 -0500
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:37358 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab0CGTse convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 14:48:34 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH] FS: NTFS: fix whitespace and pointer issues in mst.c
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <1267962651-11217-1-git-send-email-mali0037@gmail.com>
Date: Sun, 7 Mar 2010 19:48:30 +0000
Cc: ntfs-dev <linux-ntfs-dev@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <AEB82EA4-852A-40AC-BF8C-8D836038D134@cam.ac.uk>
References: <1267962651-11217-1-git-send-email-mali0037@gmail.com>
To: Stewart Malik <mali0037@gmail.com>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK.

What pointer issues are you talking about?!?  Your patch only changes the whitespace in the type casts and I like it how it is at the moment, I don't like type casts with a space in them.

The "if ( size..." change to "if (size..." is fine.  No idea how that happened.  I never put space after a bracket normally!

Best regards,

	Anton

On 7 Mar 2010, at 11:50, Stewart Malik wrote:

> ---
> fs/ntfs/mst.c |   18 +++++++++---------
> 1 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ntfs/mst.c b/fs/ntfs/mst.c
> index 5a858d8..097a4c9 100644
> --- a/fs/ntfs/mst.c
> +++ b/fs/ntfs/mst.c
> @@ -49,13 +49,13 @@ int post_read_mst_fixup(NTFS_RECORD *b, const u32 size)
> 	/* Decrement usa_count to get number of fixups. */
> 	usa_count = le16_to_cpu(b->usa_count) - 1;
> 	/* Size and alignment checks. */
> -	if ( size & (NTFS_BLOCK_SIZE - 1)	||
> +	if (size & (NTFS_BLOCK_SIZE - 1)	||
> 	     usa_ofs & 1			||
> 	     usa_ofs + (usa_count * 2) > size	||
> 	     (size >> NTFS_BLOCK_SIZE_BITS) != usa_count)
> 		return 0;
> 	/* Position of usn in update sequence array. */
> -	usa_pos = (u16*)b + usa_ofs/sizeof(u16);
> +	usa_pos = (u16 *)b + usa_ofs/sizeof(u16);
> 	/*
> 	 * The update sequence number which has to be equal to each of the
> 	 * u16 values before they are fixed up. Note no need to care for
> @@ -67,7 +67,7 @@ int post_read_mst_fixup(NTFS_RECORD *b, const u32 size)
> 	/*
> 	 * Position in protected data of first u16 that needs fixing up.
> 	 */
> -	data_pos = (u16*)b + NTFS_BLOCK_SIZE/sizeof(u16) - 1;
> +	data_pos = (u16 *)b + NTFS_BLOCK_SIZE/sizeof(u16) - 1;
> 	/*
> 	 * Check for incomplete multi sector transfer(s).
> 	 */
> @@ -85,7 +85,7 @@ int post_read_mst_fixup(NTFS_RECORD *b, const u32 size)
> 	}
> 	/* Re-setup the variables. */
> 	usa_count = le16_to_cpu(b->usa_count) - 1;
> -	data_pos = (u16*)b + NTFS_BLOCK_SIZE/sizeof(u16) - 1;
> +	data_pos = (u16 *)b + NTFS_BLOCK_SIZE/sizeof(u16) - 1;
> 	/* Fixup all sectors. */
> 	while (usa_count--) {
> 		/*
> @@ -135,13 +135,13 @@ int pre_write_mst_fixup(NTFS_RECORD *b, const u32 size)
> 	/* Decrement usa_count to get number of fixups. */
> 	usa_count = le16_to_cpu(b->usa_count) - 1;
> 	/* Size and alignment checks. */
> -	if ( size & (NTFS_BLOCK_SIZE - 1)	||
> +	if (size & (NTFS_BLOCK_SIZE - 1)	||
> 	     usa_ofs & 1			||
> 	     usa_ofs + (usa_count * 2) > size	||
> 	     (size >> NTFS_BLOCK_SIZE_BITS) != usa_count)
> 		return -EINVAL;
> 	/* Position of usn in update sequence array. */
> -	usa_pos = (le16*)((u8*)b + usa_ofs);
> +	usa_pos = (le16 *)((u8 *)b + usa_ofs);
> 	/*
> 	 * Cyclically increment the update sequence number
> 	 * (skipping 0 and -1, i.e. 0xffff).
> @@ -152,7 +152,7 @@ int pre_write_mst_fixup(NTFS_RECORD *b, const u32 size)
> 	le_usn = cpu_to_le16(usn);
> 	*usa_pos = le_usn;
> 	/* Position in data of first u16 that needs fixing up. */
> -	data_pos = (le16*)b + NTFS_BLOCK_SIZE/sizeof(le16) - 1;
> +	data_pos = (le16 *)b + NTFS_BLOCK_SIZE/sizeof(le16) - 1;
> 	/* Fixup all sectors. */
> 	while (usa_count--) {
> 		/*
> @@ -184,10 +184,10 @@ void post_write_mst_fixup(NTFS_RECORD *b)
> 	u16 usa_count = le16_to_cpu(b->usa_count) - 1;
> 
> 	/* Position of usn in update sequence array. */
> -	usa_pos = (le16*)b + usa_ofs/sizeof(le16);
> +	usa_pos = (le16 *)b + usa_ofs/sizeof(le16);
> 
> 	/* Position in protected data of first u16 that needs fixing up. */
> -	data_pos = (le16*)b + NTFS_BLOCK_SIZE/sizeof(le16) - 1;
> +	data_pos = (le16 *)b + NTFS_BLOCK_SIZE/sizeof(le16) - 1;
> 
> 	/* Fixup all sectors. */
> 	while (usa_count--) {

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

