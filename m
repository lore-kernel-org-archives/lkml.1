Return-Path: <linux-kernel-owner+w=401wt.eu-S1762733AbYFESk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762733AbYFESk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYFESkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:40:14 -0400
Received: from smtp-out.google.com ([216.239.33.17]:48943 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301AbYFESkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:40:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:mime-version:
	content-type:content-transfer-encoding:content-disposition;
	b=lfw3eBksQ1lhaDD/LR14F5pGA5IbOWkI0mFYA6Q7cmalT5kbr/OG+PuPNj63hAgVT
	1/s1h+xrbmMgyHVBHIieA==
Message-ID: <4ca0a85e0806051140r5985f6a4h42f12e60fe29050e@mail.gmail.com>
Date: Thu, 5 Jun 2008 14:40:07 -0400
From: "Thomas Tuttle" <ttuttle@google.com>
To: mpm@selenic.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] pagemap: Return EINVAL, not EIO, for unaligned reads of kpagecount or kpageflags (v2 of series)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the user tries to read from a position that is not a multiple of 8, or
read a number of bytes that is not a multiple of 8, they have passed an
invalid argument to read, for the purpose of reading these files.  It's
not an IO error because we didn't encounter any trouble finding the data
they asked for.

Signed-off-by: Thomas Tuttle
---
 fs/proc/proc_misc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 5a16090..7e277f2 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -716,7 +716,7 @@ static ssize_t kpagecount_read(struct file *file,
char __user *buf,
        pfn = src / KPMSIZE;
        count = min_t(size_t, count, (max_pfn * KPMSIZE) - src);
        if (src & KPMMASK || count & KPMMASK)
-               return -EIO;
+               return -EINVAL;

        while (count > 0) {
                ppage = NULL;
@@ -782,7 +782,7 @@ static ssize_t kpageflags_read(struct file *file,
char __user *buf,
        pfn = src / KPMSIZE;
        count = min_t(unsigned long, count, (max_pfn * KPMSIZE) - src);
        if (src & KPMMASK || count & KPMMASK)
-               return -EIO;
+               return -EINVAL;

        while (count > 0) {
                ppage = NULL;
--
1.5.3.6
