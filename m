Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbYKWFDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbYKWFDi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 00:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbYKWFD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 00:03:28 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:60954 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbYKWFD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 00:03:28 -0500
To: phillip@lougher.demon.co.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Zero-clearing all zero-clearable bytes.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200811221236.FJE81778.LtMHOQFJFVFSOO@I-love.SAKURA.ne.jp>
	<4928DBAF.4030209@lougher.demon.co.uk>
In-Reply-To: <4928DBAF.4030209@lougher.demon.co.uk>
Message-Id: <200811231403.BHG87011.OFOOQFHVJLFSMt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sun, 23 Nov 2008 14:03:24 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Phillip Lougher wrote:
> Most filesystems will not create a sparse file if zero-byte filled 
> blocks are written.  To create a sparse file you normally have to seek 
> beyond the file end and then write blocks, leaving a hole in-between the 
> positions.
> 
> The information from stat can tell you if a file has been stored 
> sparsely, because the blocks used count will be less than the file size 
> suggests.
>
Then, I can use "dd if=/dev/zero" without worrying sparse files.

Phillip Lougher wrote:
> You don't mention what you're using to compress the ext3 image file.  If 
> you're using Squashfs then it's much better to zero-fill the blocks 
> rather than use 255, because Squashfs detects zero-filled blocks and 
> stores them sparsely.  This not only gets slightly better compression 
> (than a compressed zero-filled block), but reading is also slightly faster.
> 
Yes, I use squashfs.



What I wanted to do is "Zero-clearing *all zero-clearable* bytes".
Suppose blocks for inode are 8192 bytes and only 128 bytes are in use,
I think there are 8064 bytes I can zero-fill.
Suppose blocks for file data are 8192 bytes and a file's size is 1 byte,
I think there are 8191 bytes I can zero-fill.
Such bytes may have non-zero values because directory entries can be
unlink()ed and file data can be truncate()d.
I wished there is a utility to zero-fill such bytes.


Thanks a lot.
