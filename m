Return-Path: <linux-kernel-owner+w=401wt.eu-S965061AbZLPUnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965061AbZLPUnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 15:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965046AbZLPUnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 15:43:13 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:65083 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964845AbZLPUnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 15:43:12 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAKrUKEurR7H+/2dsb2JhbAC/WpcNhCsE
X-IronPort-AV: E=Sophos;i="4.47,408,1257120000"; 
   d="scan'208";a="450836945"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: re-export alloc_file()
X-Message-Flag: Warning: May contain useful information
Date: Wed, 16 Dec 2009 12:43:11 -0800
Message-ID: <adabphy8xb4.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Dec 2009 20:43:11.0604 (UTC) FILETIME=[61E18340:01CA7E90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3d1e4631 ("get rid of init_file()") removed the export of
alloc_file() -- possibly inadvertently, since that commit mainly
consisted of deleting the lines between the end of alloc_file() and
the start of the code in init_file().

There is in fact one modular use of alloc_file() in the tree, in
drivers/infiniband/core/uverbs_main.c, so re-add the export to fix:

    ERROR: "alloc_file" [drivers/infiniband/core/ib_uverbs.ko] undefined!

when CONFIG_INFINIBAND_USER_ACCESS=m.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 fs/file_table.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 17a55b8..0afacf6 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -194,6 +194,7 @@ struct file *alloc_file(struct path *path, fmode_t mode,
 	ima_counts_get(file);
 	return file;
 }
+EXPORT_SYMBOL(alloc_file);
 
 void fput(struct file *file)
 {
