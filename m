Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbZA2PJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbZA2PJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbZA2PJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:09:17 -0500
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:35508 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbZA2PJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:09:16 -0500
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Jan 2009 10:09:15 EST
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [PATCH 1/1] s_umount in sget()
Date: Fri, 30 Jan 2009 00:00:09 +0900
Message-Id: <1233241209-12782-1-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems to be forgotten to release s_umount rwsem in a error path of
sget(). I don't think it harmful generally since the rwsem is freed. But
I am afarid unnecessary info left in some debugging subsystem (lockdep
or something).

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 645e540..0331ff9 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -372,6 +372,7 @@ retry:
 	err = set(s, data);
 	if (err) {
 		spin_unlock(&sb_lock);
+		up_write(&s->s_umount);
 		destroy_super(s);
 		return ERR_PTR(err);
 	}
-- 
1.6.1.284.g5dc13

