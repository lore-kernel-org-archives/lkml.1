Return-Path: <linux-kernel-owner+w=401wt.eu-S1755733AbXKFNSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbXKFNSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 08:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbXKFNSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 08:18:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:26719 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbXKFNSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 08:18:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=A5QySW1caVFa5hFT5krMnALMcn1efd/dkNtY/grNM2f8qtIQUCEhudXG2kPzXm0aGbQowO1zVLjXtQ06SF4xDVPUoMRKoJKrYRuRgIH27up+UpYV8mYtvGvsugpwf24sWSl7EV666mT0TjF5lKRHLCE9TEJjBMvZfhUd3+twwNU=
Date: Tue, 6 Nov 2007 14:17:22 +0100
From: Frederik Deweerdt <deweerdt@free.fr>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] fix getblk_slow "integer constant is too large" warning
Message-ID: <20071106131722.GE21227@slug>
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 02:33:53AM -0800, akpm@linux-foundation.org wrote:
> The mm snapshot broken-out-2007-11-06-02-32.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-11-06-02-32.tar.gz
> 
> It contains the following patches against 2.6.24-rc1:
> 
[...]
> getblk-handle-2tb-devices.patch
[...]
0xffffffff00000000 is unsigned long long on 32 bits
fs/buffer.c: In function '__getblk_slow':
fs/buffer.c:1126: warning: integer constant is too large for 'unsigned long' type

Regards,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>


diff --git a/fs/buffer.c b/fs/buffer.c
index ca713df..795fe86 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1123,7 +1123,7 @@ __getblk_slow(struct block_device *bdev, sector_t block, int size)
 
 #if (BITS_PER_LONG == 32) && defined(CONFIG_LBD)
 	if ((block >> (PAGE_CACHE_SHIFT - bdev->bd_inode->i_blkbits)) &
-			0xffffffff00000000UL) {
+			0xffffffff00000000ULL) {
 		/*
 		 * We'll fail because the block is outside the range
 		 * which a 32-bit pagecache index can address
