Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbZDMWv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbZDMWv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbZDMWvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:51:48 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:37726 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752365AbZDMWvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:51:48 -0400
Message-ID: <49E3C209.5030705@lougher.demon.co.uk>
Date: Mon, 13 Apr 2009 23:51:53 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Doug Chapman <doug.chapman@hp.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] squashfs broken when pageszie > blocksize
References: <1239652637.1127.10.camel@oberon>
In-Reply-To: <1239652637.1127.10.camel@oberon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Chapman wrote:
> Squashfs is broken on any system where the pageszie is larger than either
> the block size of the squashfs image or larger than the metadata size (8192).
> This is easily fixed by ensuring cache->pages is always > 0.
> 
> Signed-off-by: Doug Chapman <doug.chapman@hp.com>
> Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
> 

Good catch.  BTW what is the page size on ia64?

For completeness there should also be a mount time check that
the block size used in the Squashfs filesystem is at least as
large as the pagesize.  This doesn't matter for metadata
(size 8192), but does matter for data blocks, because Squashfs
read_page doesn't handle block_size < pagesize.

Squashfs read_page used to handle block_size < pagesize but I
removed that code when I removed filesystem support for block_sizes
< 4K.  If ia64 users (or any other architecture with larger than
4K pagesizes) want to use Squashfs filesystems with blocksizes less
than their pagesize, then I can put that code back in.

Phillip

