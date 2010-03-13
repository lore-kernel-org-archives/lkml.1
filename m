Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935780Ab0CMArt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:47:49 -0500
Received: from kroah.org ([198.145.64.141]:47062 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935512Ab0CMAcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:32:15 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:14 2010
Message-Id: <20100313002714.911259308@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:27:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tao Ma <tao.ma@oracle.com>, Joel Becker <joel.becker@oracle.com>
Subject: [111/145] ocfs2: Only bug out in direct io write for reflinked extent.
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Tao Ma <tao.ma@oracle.com>

commit cbaee472f274ea9a98aabe47025f6e5551acadcb upstream.

In ocfs2_direct_IO_get_blocks, we only need to bug out
in case of we are going to write a recounted extent rec.

What a silly bug introduced by me!

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/aops.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -591,8 +591,9 @@ static int ocfs2_direct_IO_get_blocks(st
 		goto bail;
 	}
 
-	/* We should already CoW the refcounted extent. */
-	BUG_ON(ext_flags & OCFS2_EXT_REFCOUNTED);
+	/* We should already CoW the refcounted extent in case of create. */
+	BUG_ON(create && (ext_flags & OCFS2_EXT_REFCOUNTED));
+
 	/*
 	 * get_more_blocks() expects us to describe a hole by clearing
 	 * the mapped bit on bh_result().


