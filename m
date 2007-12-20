Return-Path: <linux-kernel-owner+w=401wt.eu-S965084AbXLTO26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965084AbXLTO26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933122AbXLTONE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:13:04 -0500
Received: from ns.suse.de ([195.135.220.2]:40972 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933130AbXLTONA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:13:00 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:47 2007
Message-Id: <20071220140946.896521142@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:46 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 36/47] Allow permission functions to tell between parent and leaf checks
Content-Disposition: inline; filename=parent-permission.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the LOOKUP_CONTINUE flag when checking parent permissions. This allows
permission functions to tell between parent and leaf checks.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/namei.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1511,6 +1511,8 @@ static inline int may_create(struct inod
 		return -EEXIST;
 	if (IS_DEADDIR(dir))
 		return -ENOENT;
+	if (nd)
+		nd->flags |= LOOKUP_CONTINUE;
 	return permission(dir,MAY_WRITE | MAY_EXEC, nd);
 }
 

-- 

