Return-Path: <linux-kernel-owner+w=401wt.eu-S1752010AbZINFUC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbZINFUC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 01:20:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZINFT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 01:19:59 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:38645 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbZINFT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 01:19:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=YIqXjyVX5YODF6Ef/9GUcmtvOU6gCutAG+sfy4607mKOm9ymku5CcPf8oX4rSwEyM1
         6xvPBegaDMFNVw6jVRAa5ZHWIN8caHW92tojhahTiQFHHlcwSkOJ881Q1t8pWKxj4s4M
         iQfkzSWCZLxuR86gZnsoE6iiCt3YoWJJEx1Kc=
MIME-Version: 1.0
Date: Mon, 14 Sep 2009 17:20:02 +1200
Message-ID: <202cde0e0909132220v6a28ce5che6b216d296aeb33d@mail.gmail.com>
Subject: [PATCH 3/3] Export of hugetlb_file_setup function. (Take 3)
From: Alexey Korolev <akorolex@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>, Eric Munson <linux-mm@mgebm.net>,
       Alexey Korolev <akorolev@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides drivers with export of hugetlb_file_setup function.
This patch exports hugetlb_file_setup function, that will be used to
create a file on the internal vfsmount. Also it adds enum entry just
to notify that  file is created by device driver. Accounting rules are
the same as for HUGETLB_ANONHUGE_INODE.

fs/hugetlbfs/inode.c    |    1 +
include/linux/hugetlb.h |    5 +++++
2 files changed, 6 insertions(+)
---
Signed-off-by: Alexey Korolev <akorolev@infradead.org>

diff -aurp clean/fs/hugetlbfs/inode.c patched/fs/hugetlbfs/inode.c
--- clean/fs/hugetlbfs/inode.c	2009-09-11 15:33:48.000000000 +1200
+++ patched/fs/hugetlbfs/inode.c	2009-09-11 15:29:31.000000000 +1200
@@ -1012,6 +1012,7 @@ out_shm_unlock:
 	}
 	return ERR_PTR(error);
 }
+EXPORT_SYMBOL_GPL(hugetlb_file_setup);

 static int __init init_hugetlbfs_fs(void)
 {
diff -aurp clean/include/linux/hugetlb.h patched/include/linux/hugetlb.h
--- clean/include/linux/hugetlb.h	2009-09-11 15:33:48.000000000 +1200
+++ patched/include/linux/hugetlb.h	2009-09-11 20:09:02.000000000 +1200
@@ -123,6 +126,11 @@ enum {
 	 * accounting rules do not apply
 	 */
 	HUGETLB_ANONHUGE_INODE  = 2,
+	/*
+	 * The file is being created for use of device drivers,shmfs
+	 * accounting rules do not apply
+	 */
+	HUGETLB_DEVBACK_INODE	= 3,
 };

 #ifdef CONFIG_HUGETLBFS
