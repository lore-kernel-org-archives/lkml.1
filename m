Return-Path: <linux-kernel-owner+w=401wt.eu-S1761125AbZFKPad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761125AbZFKPad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbZFKP31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:29:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55899 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582AbZFKP30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:29:26 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/4] dlm: Make name input parameter of {,dlm_}new_lockspace() const
Date: Thu, 11 Jun 2009 10:20:46 -0500
Message-Id: <1244733649-26003-2-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

| fs/gfs2/lock_dlm.c:207: warning: passing argument 1 of 'dlm_new_lockspace' discards qualifiers from pointer target type

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lockspace.c  |    4 ++--
 include/linux/dlm.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index cd8e2df..82528d9 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -384,7 +384,7 @@ static void threads_stop(void)
 	dlm_astd_stop();
 }
 
-static int new_lockspace(char *name, int namelen, void **lockspace,
+static int new_lockspace(const char *name, int namelen, void **lockspace,
 			 uint32_t flags, int lvblen)
 {
 	struct dlm_ls *ls;
@@ -614,7 +614,7 @@ static int new_lockspace(char *name, int namelen, void **lockspace,
 	return error;
 }
 
-int dlm_new_lockspace(char *name, int namelen, void **lockspace,
+int dlm_new_lockspace(const char *name, int namelen, void **lockspace,
 		      uint32_t flags, int lvblen)
 {
 	int error = 0;
diff --git a/include/linux/dlm.h b/include/linux/dlm.h
index b9cd386..0b3518c 100644
--- a/include/linux/dlm.h
+++ b/include/linux/dlm.h
@@ -81,8 +81,8 @@ struct dlm_lksb {
  * the cluster, the calling node joins it.
  */
 
-int dlm_new_lockspace(char *name, int namelen, dlm_lockspace_t **lockspace,
-		      uint32_t flags, int lvblen);
+int dlm_new_lockspace(const char *name, int namelen,
+		      dlm_lockspace_t **lockspace, uint32_t flags, int lvblen);
 
 /*
  * dlm_release_lockspace
-- 
1.5.5.6

