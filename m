Return-Path: <linux-kernel-owner+w=401wt.eu-S1756016AbYKCOMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbYKCOMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 09:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbYKCOL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 09:11:58 -0500
Received: from tservice.net.ru ([195.178.208.66]:36480 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000AbYKCOL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 09:11:57 -0500
Date: Mon, 3 Nov 2008 17:11:56 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: [PATCH V2 11/16] Squashfs: block operations
Message-ID: <20081103141156.GB27263@ioremap.net>
References: <E1Kv0C4-0006HV-DN@dylan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Kv0C4-0006HV-DN@dylan>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, Oct 29, 2008 at 01:49:56AM +0000, Phillip Lougher (phillip@lougher.demon.co.uk) wrote:
> +int squashfs_read_data(struct super_block *sb, void *buffer,
> +			long long index, int length, long long *next_index,
> +			int srclength)
> +{
> +	struct squashfs_sb_info *msblk = sb->s_fs_info;
> +	struct buffer_head **bh;
> +	int offset = index & ((1 << msblk->devblksize_log2) - 1);
> +	long long cur_index = index >> msblk->devblksize_log2;
> +	int avail, bytes, compressed, b = 0, k = 0;
> +	int c_byte = length;
> +
> +	bh = kcalloc((msblk->block_size >> msblk->devblksize_log2) + 1,
> +				sizeof(*bh), GFP_KERNEL);

Could be great to have a memory pool though...

-- 
	Evgeniy Polyakov
