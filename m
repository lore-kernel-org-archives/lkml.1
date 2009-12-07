Return-Path: <linux-kernel-owner+w=401wt.eu-S1758575AbZLGW52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbZLGW52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935635AbZLGW52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:57:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757698AbZLGW51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:57:27 -0500
Date: Mon, 7 Dec 2009 14:57:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, phillip.lougher@gmail.com,
       tim.bird@am.sony.com
Subject: Re: [PATCH 1/9] Squashfs: move zlib decompression wrapper code into
 a separate file
Message-Id: <20091207145705.cd30cae8.akpm@linux-foundation.org>
In-Reply-To: <E1NHTHg-0001sM-NQ@dylan.lougher.demon.co.uk>
References: <E1NHTHg-0001sM-NQ@dylan.lougher.demon.co.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Dec 2009 02:25:08 +0000
Phillip Lougher <phillip@lougher.demon.co.uk> wrote:

> +++ b/fs/squashfs/zlib_wrapper.c
> @@ -0,0 +1,109 @@
> +/*
> + * Squashfs - a compressed read only filesystem for Linux
> + *
> + * Copyright (c) 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009
> + * Phillip Lougher <phillip@lougher.demon.co.uk>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2,
> + * or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
> + *
> + * zlib_wrapper.c
> + */
> +
> +
> +#include <linux/mutex.h>
> +#include <linux/buffer_head.h>
> +#include <linux/zlib.h>
> +
> +#include "squashfs_fs.h"
> +#include "squashfs_fs_sb.h"
> +#include "squashfs_fs_i.h"
> +#include "squashfs.h"
> +
> +int zlib_uncompress(struct squashfs_sb_info *msblk, void **buffer,
> +	struct buffer_head **bh, int b, int offset, int length, int srclength,
> +	int pages)

This isn't a very good function name.  zlib_uncompress() now becomes a
kernel-wide identifier, but it's part of squashfs, not part of zlib.

Maybe that gets fixed in a later patch.  If so, thwap me.
