Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbZE1XIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbZE1XIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 19:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbZE1XD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 19:03:26 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48849 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbZE1XCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 19:02:22 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Thu, 28 May 2009 16:00:50 -0700
Message-Id: <1243551665-23596-9-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 09/24] sysfs: Simplify iattr assignments
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

The granularity of sysfs time when we keep it is 1 ns.  Which
when passed to timestamp_trunc results in a nop.  So remove
the unnecessary function call making sysfs_setattr slightly
easier to read.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/inode.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 70ff2a2..5020a1d 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -96,14 +96,11 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
 	if (ia_valid & ATTR_GID)
 		sd_iattr->ia_gid = iattr->ia_gid;
 	if (ia_valid & ATTR_ATIME)
-		sd_iattr->ia_atime = timespec_trunc(iattr->ia_atime,
-						inode->i_sb->s_time_gran);
+		sd_iattr->ia_atime = iattr->ia_atime;
 	if (ia_valid & ATTR_MTIME)
-		sd_iattr->ia_mtime = timespec_trunc(iattr->ia_mtime,
-						inode->i_sb->s_time_gran);
+		sd_iattr->ia_mtime = iattr->ia_mtime;
 	if (ia_valid & ATTR_CTIME)
-		sd_iattr->ia_ctime = timespec_trunc(iattr->ia_ctime,
-						inode->i_sb->s_time_gran);
+		sd_iattr->ia_ctime = iattr->ia_ctime;
 	if (ia_valid & ATTR_MODE)
 		sd_iattr->ia_mode = iattr->ia_mode;
 
-- 
1.6.3.1.54.g99dd.dirty

