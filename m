Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbZLIKBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbZLIKBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 05:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbZLIKBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 05:01:30 -0500
Received: from smtp.nokia.com ([192.100.105.134]:28907 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbZLIKB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 05:01:28 -0500
Subject: Re: [PATCH 1/9] Squashfs: move zlib decompression wrapper code
 into a separate file
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       phillip.lougher@gmail.com, tim.bird@am.sony.com
In-Reply-To: <4B1ED122.3040309@lougher.demon.co.uk>
References: <E1NHTHg-0001sM-NQ@dylan.lougher.demon.co.uk>
	 <20091207145705.cd30cae8.akpm@linux-foundation.org>
	 <4B1ED122.3040309@lougher.demon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Dec 2009 12:00:52 +0200
Message-Id: <1260352852.19669.1253.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Dec 2009 10:00:58.0183 (UTC) FILETIME=[8147D570:01CA78B6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 22:20 +0000, Phillip Lougher wrote:
> Andrew Morton wrote:
> > On Mon, 07 Dec 2009 02:25:08 +0000
> > Phillip Lougher <phillip@lougher.demon.co.uk> wrote:
> > 
> >> +
> >> +int zlib_uncompress(struct squashfs_sb_info *msblk, void **buffer,
> >> +	struct buffer_head **bh, int b, int offset, int length, int srclength,
> >> +	int pages)
> > 
> > This isn't a very good function name.  zlib_uncompress() now becomes a
> > kernel-wide identifier, but it's part of squashfs, not part of zlib.
> > 
> > Maybe that gets fixed in a later patch.  If so, thwap me.
> > 
> 
> Yes, they get fixed up in [PATCH 3/9] Squashfs: add a decompressor framework.
> That patch makes the functions static, and instead exports them via a
> suitably named decompressor ops structure.
> 
> +const struct squashfs_decompressor squashfs_zlib_comp_ops = {
> +	.init = zlib_init,
> +	.free = zlib_free,
> +	.decompress = zlib_uncompress,
> +	.id = ZLIB_COMPRESSION,
> +	.name = "zlib",
> +	.supported = 1
> +};
> 
> I split the patches up to make them easier to review.  The first two patches
> move the zlib code out to a separate file (ready for adding the framework).
> The third patch adds the framework.  At the time of the second patch, however,
> to not break compilation, the functions have to be global.  In hindsight
> I should have made named the functions squashfs_xxx, and removed the squashfs_
> when they were made static in the third patch.

Did you consider using cryptoapi? UBIFS uses zlib/lzo in cryptoapi - it
is a very clean way.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

