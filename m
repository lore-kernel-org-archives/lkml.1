Return-Path: <linux-kernel-owner+w=401wt.eu-S966719AbZLHWWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966719AbZLHWWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756336AbZLHWWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:22:47 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:59163 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966653AbZLHWWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:22:46 -0500
Message-ID: <4B1ED122.3040309@lougher.demon.co.uk>
Date: Tue, 08 Dec 2009 22:20:18 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, phillip.lougher@gmail.com,
       tim.bird@am.sony.com
Subject: Re: [PATCH 1/9] Squashfs: move zlib decompression wrapper code into
 a separate file
References: <E1NHTHg-0001sM-NQ@dylan.lougher.demon.co.uk> <20091207145705.cd30cae8.akpm@linux-foundation.org>
In-Reply-To: <20091207145705.cd30cae8.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 07 Dec 2009 02:25:08 +0000
> Phillip Lougher <phillip@lougher.demon.co.uk> wrote:
> 
>> +
>> +int zlib_uncompress(struct squashfs_sb_info *msblk, void **buffer,
>> +	struct buffer_head **bh, int b, int offset, int length, int srclength,
>> +	int pages)
> 
> This isn't a very good function name.  zlib_uncompress() now becomes a
> kernel-wide identifier, but it's part of squashfs, not part of zlib.
> 
> Maybe that gets fixed in a later patch.  If so, thwap me.
> 

Yes, they get fixed up in [PATCH 3/9] Squashfs: add a decompressor framework.
That patch makes the functions static, and instead exports them via a
suitably named decompressor ops structure.

+const struct squashfs_decompressor squashfs_zlib_comp_ops = {
+	.init = zlib_init,
+	.free = zlib_free,
+	.decompress = zlib_uncompress,
+	.id = ZLIB_COMPRESSION,
+	.name = "zlib",
+	.supported = 1
+};

I split the patches up to make them easier to review.  The first two patches
move the zlib code out to a separate file (ready for adding the framework).
The third patch adds the framework.  At the time of the second patch, however,
to not break compilation, the functions have to be global.  In hindsight
I should have made named the functions squashfs_xxx, and removed the squashfs_
when they were made static in the third patch.

Thanks

Phillip
