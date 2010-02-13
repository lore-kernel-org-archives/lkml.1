Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab0BMDWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 22:22:55 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:51240 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab0BMDWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 22:22:52 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 2/6] sysfs: Pack sysfs_dirent more tightly.
Date: Fri, 12 Feb 2010 19:22:24 -0800
Message-Id: <1266031348-30068-2-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1mxzdstx2.fsf_-_@fess.ebiederm.org>
References: <m1mxzdstx2.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@aristanetworks.com>

Placing the 16bit s_mode between a pointer and a long doesn't pack well
especailly on 64bit where we wast 48 bits.  So move s_mode and
declare it as a unsigned short.  This is the sysfs backing store
after all we don't need fields extra large just in case someday
we want userspace to be able to use a larger value.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/sysfs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 37e0e08..5a3192a 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -66,8 +66,8 @@ struct sysfs_dirent {
 	};
 
 	unsigned int		s_flags;
+	unsigned short		s_mode;
 	ino_t			s_ino;
-	umode_t			s_mode;
 	struct sysfs_inode_attrs *s_iattr;
 };
 
-- 
1.6.5.2.143.g8cc62

