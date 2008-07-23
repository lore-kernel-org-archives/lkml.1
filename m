Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbYGWXwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbYGWXwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 19:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbYGWXw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 19:52:26 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:44716 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbYGWXwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 19:52:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=aNpXvxNnZk8z8PYqs4bQ7RDwiwSTJlE0ZnNxL56pL+QIGHmeRtt78dyuPt6bfDMf2x
         3ZHhYEftYLirdBM3SfxblRNI33z2HqNgqrVMMpNpNRbJazARK3nfy753XifImNEydROY
         EeFxQIMNlFylLJGSpng6b0EQ1L1IUsH/Lus1E=
Subject: [PATCH] cifs: avoid mixing bool and le16
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 23 Jul 2008 16:52:18 -0700
Message-Id: <1216857138.30386.33.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/cifs/cifssmb.c:3917:13: warning: incorrect type in assignment (different base types)
fs/cifs/cifssmb.c:3917:13:    expected bool [unsigned] [usertype] is_unicode
fs/cifs/cifssmb.c:3917:13:    got restricted __le16

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/cifs/cifssmb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 4511b70..56f1a71 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3914,7 +3914,7 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
 	bool is_unicode;
 	struct dfs_referral_level_3 *ref;
 
-	is_unicode = pSMBr->hdr.Flags2 & SMBFLG2_UNICODE;
+	is_unicode = !!(pSMBr->hdr.Flags2 & SMBFLG2_UNICODE);
 	*num_of_nodes = le16_to_cpu(pSMBr->NumberOfReferrals);
 
 	if (*num_of_nodes < 1) {
-- 
1.5.6.4.570.g052e



