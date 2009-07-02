Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbZGBIYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbZGBIYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 04:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZGBIYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 04:24:06 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:47868 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZGBIYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 04:24:04 -0400
Message-ID: <4A4C6EA4.9030108@monstr.eu>
Date: Thu, 02 Jul 2009 10:24:04 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: linux-aio@kvack.org
CC: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: generic_file_aio_write on nfs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

I am doing LTP tests on Microblaze cpu and I am getting some faults.
I found that the problem is caused by generic_file_aio_write function.
I did quick patch with disable usage of generic_file_aio_write function and
use only write function which works. I haven't debug
generic_file_aio_write function.

I am running Linux with initramfs and LTP programs are run from nfs.

Have you ever met with this problem?

Thanks,
Michal

[monstr@monstr linux-monstr.eu-commit]$ git diff fs/read_write.c
diff --git a/fs/read_write.c b/fs/read_write.c
index 400fe81..e639098 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -642,7 +642,8 @@ static ssize_t do_readv_writev(int type, struct file
*file,
                fnv = file->f_op->aio_read;
        } else {
                fn = (io_fn_t)file->f_op->write;
-               fnv = file->f_op->aio_write;
+               //fnv = file->f_op->aio_write;
+               fnv = 0;
        }
 
        if (fnv)

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854

