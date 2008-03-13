Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbYCMMGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbYCMMGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYCMMGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:06:32 -0400
Received: from styx.suse.cz ([82.119.242.94]:36288 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752524AbYCMMGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:06:31 -0400
Date: Thu, 13 Mar 2008 13:06:30 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Remove superfluous DQUOT_OFF() in fs/namespace.c
Message-ID: <20080313120630.GD12523@duck.suse.cz>
References: <20080313120344.GB12523@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313120344.GB12523@duck.suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to turn quotas off before remounting root ro, because
do_remount_sb() already handles this.

Signed-off-by: Jan Kara <jack@suse.cz>

---
 namespace.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 7953c96..b6facef 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -14,7 +14,6 @@
 #include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/quotaops.h>
 #include <linux/acct.h>
 #include <linux/capability.h>
 #include <linux/module.h>
@@ -638,7 +637,6 @@ static int do_umount(struct vfsmount *mnt, int flags)
 		down_write(&sb->s_umount);
 		if (!(sb->s_flags & MS_RDONLY)) {
 			lock_kernel();
-			DQUOT_OFF(sb);
 			retval = do_remount_sb(sb, MS_RDONLY, NULL, 0);
 			unlock_kernel();
 		}
