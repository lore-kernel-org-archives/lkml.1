Return-Path: <linux-kernel-owner+w=401wt.eu-S1758148AbYFCCDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbYFCCDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 22:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756859AbYFCCAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 22:00:07 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:40491 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757434AbYFCCAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 22:00:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Pavel Emelyanov" <xemul@openvz.org>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
References: <19f34abd0806012331m7c57468bu820e9b6b0184836d@mail.gmail.com>
	<19f34abd0806020000h407e3fb1kadff228a3cf4c6f@mail.gmail.com>
Date: Mon, 02 Jun 2008 18:59:46 -0700
In-Reply-To: <19f34abd0806020000h407e3fb1kadff228a3cf4c6f@mail.gmail.com>
	(Vegard Nossum's message of "Mon, 2 Jun 2008 09:00:56 +0200")
Message-ID: <m163srxoq5.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Vegard Nossum" <vegard.nossum@gmail.com>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: find: WARNING: Hard link count is wrong for /proc/1
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Mon, 2 Jun 2008 08:57:45 +0200
Subject: [PATCH] proc: fix /proc/<pid> link count

commit e9720acd728a46cb40daa52c99a979f7c4ff195c
Author: Pavel Emelyanov <xemul@openvz.org>
Date:   Fri Mar 7 11:08:40 2008 -0800

    [NET]: Make /proc/net a symlink on /proc/self/net (v3)

introduced /proc/net without bumping the link count on /proc/self.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

---
 fs/proc/base.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index c447e07..10ee4a2 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2589,6 +2589,9 @@ static struct dentry
*proc_pid_instantiate(struct inode *dir,
 #ifdef CONFIG_SECURITY
 	inode->i_nlink += 1;
 #endif
+#ifdef CONFIG_NET
+	inode->i_nlink += 1;
+#endif

 	dentry->d_op = &pid_dentry_operations;

-- 
1.5.4.1
