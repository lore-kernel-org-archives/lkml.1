Return-Path: <linux-kernel-owner+w=401wt.eu-S1753178AbZKHH1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbZKHH1l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 02:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbZKHH1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 02:27:40 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:46978 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbZKHH1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 02:27:35 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@maxwell.aristanetworks.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 14/15] sysfs: sysfs_setattr remove unnecessary permission check.
Date: Sat,  7 Nov 2009 23:27:12 -0800
Message-Id: <1257665233-12468-14-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1pr7tmqb4.fsf@fess.ebiederm.org>
References: <m1pr7tmqb4.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@maxwell.aristanetworks.com>

inode_change_ok already clears the SGID bit when necessary
so there is no reason for sysfs_setattr to carry code to do
the same, and it is good to kill the extra copy because when
I moved the code last in certain corner cases the code will
look at the wrong gid.

Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/inode.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 082a3eb..8197e1a 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -117,10 +117,6 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
 		return error;
 
 	iattr->ia_valid &= ~ATTR_SIZE; /* ignore size changes */
-	if (iattr->ia_valid & ATTR_MODE) {
-		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
-			iattr->ia_mode &= ~S_ISGID;
-	}
 
 	error = inode_setattr(inode, iattr);
 	if (error)
-- 
1.6.5.2.143.g8cc62

