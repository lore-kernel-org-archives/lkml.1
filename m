Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbYKFKpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbYKFKpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 05:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbYKFKpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 05:45:11 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:55419 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbYKFKpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 05:45:09 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
Date: Thu, 06 Nov 2008 02:38:49 -0800
Message-ID: <m1ej1p2l6u.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, containers@lists.osdl.org, viro@ZenIV.linux.org.uk, adobriyan@gmail.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH 1/7] vfs: Fix shrink_submounts
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In the last refactoring of shrink_submounts a variable was
not completely renamed.  So finish the renaming of mnt to m
now.

Without this if you attempt to mount an nfs mount that has
both automatic nfs sub mounts on it, and has normal mounts
on it.  The unmount will succeed when it should not.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/namespace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index cce4670..65b3dc8 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1815,8 +1815,8 @@ static void shrink_submounts(struct vfsmount *mnt, struct list_head *umounts)
 		while (!list_empty(&graveyard)) {
 			m = list_first_entry(&graveyard, struct vfsmount,
 						mnt_expire);
-			touch_mnt_namespace(mnt->mnt_ns);
-			umount_tree(mnt, 1, umounts);
+			touch_mnt_namespace(m->mnt_ns);
+			umount_tree(m, 1, umounts);
 		}
 	}
 }
-- 
1.5.3.rc6.17.g1911

