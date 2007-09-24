Return-Path: <linux-kernel-owner+w=401wt.eu-S1759611AbXIXTlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611AbXIXTlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 15:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761395AbXIXTlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 15:41:25 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:57145 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761304AbXIXTlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 15:41:24 -0400
Message-ID: <46F812DF.4010909@linux.vnet.ibm.com>
Date: Tue, 25 Sep 2007 01:11:19 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, neilb@suse.de
Subject: Re: 2.6.23-rc7-mm1
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
In-Reply-To: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The build fails with following error

CC drivers/block/ps3disk.o
drivers/block/ps3disk.c: In function ‘ps3disk_scatter_gather’:
drivers/block/ps3disk.c:115: error: ‘bio’ undeclared (first use in this
function)
drivers/block/ps3disk.c:115: error: (Each undeclared identifier is
reported only once
drivers/block/ps3disk.c:115: error: for each function it appears in.)
drivers/block/ps3disk.c:115: error: ‘j’ undeclared (first use in this
function)
drivers/block/ps3disk.c:116: error: implicit declaration of function
‘bio_kunmap_bvec’
make[2]: *** [drivers/block/ps3disk.o] Error 1
make[1]: *** [drivers/block] Error 2
make: *** [drivers] Error 2

The function bio_kunmap_bvec is missing.I tried checking the git-block.patch
as well as the linux/kernel/git/axboe/linux-2.6-block.git and did not
find this function.

Previously this function was replaced by __bio_kunmap_atomic();
This patch does not solves the implicit "declaration of function
‘bio_kunmap_bvec’"

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com
<mailto:kamalesh@linux.vnet.ibm.com>>
---

--- linux-2.6.23-rc7/drivers/block/ps3disk.c    2007-09-24 20:50:41.000000000 +0530
+++ linux-2.6.23-rc7/drivers/block/~ps3disk.c   2007-09-24 20:50:59.000000000 +0530
@@ -112,7 +112,7 @@ static void ps3disk_scatter_gather(struc
                else
                        memcpy(buf, dev->bounce_buf+offset, size);
                offset += size;
-               flush_kernel_dcache_page(bio_iovec_idx(bio, j)->bv_page);
+              flush_kernel_dcache_page(bio_iovec_idx(iter.bio, iter.i)->bv_page);
                bio_kunmap_bvec(bvec, flags);
                i++;
        }

-- 

Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

