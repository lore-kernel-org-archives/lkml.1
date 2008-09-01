Return-Path: <linux-kernel-owner+w=401wt.eu-S1756417AbYIALCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417AbYIALCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYIALCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:02:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:37033 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbYIALCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:02:45 -0400
Message-ID: <48BBCB62.4040309@kernel.org>
Date: Mon, 01 Sep 2008 13:00:50 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       dm-devel@redhat.com
Subject: [PATCH #blk-for-2.8] init: DEBUG_BLOCK_EXT_DEVT requires explicit
 root= param
References: <20080827183453.eb651f50.sfr@canb.auug.org.au> <200808292123.07246.bzolnier@gmail.com> <48B90E81.5060905@kernel.org> <200808311538.38918.bzolnier@gmail.com>
In-Reply-To: <200808311538.38918.bzolnier@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 01 Sep 2008 11:01:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DEBUG_BLOCK_EXT_DEVT shuffles SCSI and IDE device numbers and root
device number set using rdev become meaningless.  Root devices should
be explicitly specified using textual names.  Warn about it if root
can't be found and DEBUG_BLOCK_EXT_DEVT is enabled.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
There are other ways to specify device numbers directly (ie. root=8:0)
and DEBUG_BLOCK_EXT_DEVT being a debug option I don't think it
warrants a complex logic, so I just added simple warning message.

 init/do_mounts.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: work/init/do_mounts.c
===================================================================
--- work.orig/init/do_mounts.c
+++ work/init/do_mounts.c
@@ -263,6 +263,10 @@ retry:
 		printk("Please append a correct \"root=\" boot option; here are the available partitions:\n");
 
 		printk_all_partitions();
+#ifdef CONFIG_DEBUG_BLOCK_EXT_DEVT
+		printk("DEBUG_BLOCK_EXT_DEVT is enabled, you need to specify "
+		       "explicit textual name for \"root=\" boot option.\n");
+#endif
 		panic("VFS: Unable to mount root fs on %s", b);
 	}
 
