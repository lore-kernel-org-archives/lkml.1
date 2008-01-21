Return-Path: <linux-kernel-owner+w=401wt.eu-S1763667AbYAUKMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763667AbYAUKMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759883AbYAUKCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758868AbYAUKCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:40 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: "Fabio M. Di Nitto" <fabbione@ubuntu.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 29/58] [GFS2] Remove unrequired code
Date: Mon, 21 Jan 2008 09:21:47 +0000
Message-Id: <12009073913676-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073891848-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
 <12009073542596-git-send-email-swhiteho@redhat.com>
 <1200907356883-git-send-email-swhiteho@redhat.com>
 <12009073571991-git-send-email-swhiteho@redhat.com>
 <12009073591688-git-send-email-swhiteho@redhat.com>
 <12009073611695-git-send-email-swhiteho@redhat.com>
 <1200907362266-git-send-email-swhiteho@redhat.com>
 <12009073642512-git-send-email-swhiteho@redhat.com>
 <12009073662309-git-send-email-swhiteho@redhat.com>
 <12009073671755-git-send-email-swhiteho@redhat.com>
 <12009073698-git-send-email-swhiteho@redhat.com>
 <12009073701982-git-send-email-swhiteho@redhat.com>
 <12009073722253-git-send-email-swhiteho@redhat.com>
 <1200907374616-git-send-email-swhiteho@redhat.com>
 <12009073753723-git-send-email-swhiteho@redhat.com>
 <12009073771883-git-send-email-swhiteho@redhat.com>
 <1200907378664-git-send-email-swhiteho@redhat.com>
 <12009073803732-git-send-email-swhiteho@redhat.com>
 <12009073823161-git-send-email-swhiteho@redhat.com>
 <12009073841692-git-send-email-swhiteho@redhat.com>
 <12009073862261-git-send-email-swhiteho@redhat.com>
 <12009073883125-git-send-email-swhiteho@redhat.com>
 <12009073891848-git-send-email-swhiteho@redhat.com>
Message-Id: <cc2cd5260a4f2ca55ba561fa08539f86c304d872.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio M. Di Nitto <fabbione@ubuntu.com>

Signed-off-by: Fabio M. Di Nitto <fabbione@ubuntu.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/eaops.c b/fs/gfs2/eaops.c
index 14fbd95..f114ba2 100644
--- a/fs/gfs2/eaops.c
+++ b/fs/gfs2/eaops.c
@@ -56,21 +56,6 @@ unsigned int gfs2_ea_name2type(const char *name, const char **truncated_name)
 	return type;
 }
 
-static int user_eo_get(struct gfs2_inode *ip, struct gfs2_ea_request *er)
-{
-	return gfs2_ea_get_i(ip, er);
-}
-
-static int user_eo_set(struct gfs2_inode *ip, struct gfs2_ea_request *er)
-{
-	return gfs2_ea_set_i(ip, er);
-}
-
-static int user_eo_remove(struct gfs2_inode *ip, struct gfs2_ea_request *er)
-{
-	return gfs2_ea_remove_i(ip, er);
-}
-
 static int system_eo_get(struct gfs2_inode *ip, struct gfs2_ea_request *er)
 {
 	if (!GFS2_ACL_IS_ACCESS(er->er_name, er->er_name_len) &&
@@ -143,25 +128,10 @@ static int system_eo_remove(struct gfs2_inode *ip, struct gfs2_ea_request *er)
 	return gfs2_ea_remove_i(ip, er);
 }
 
-static int security_eo_get(struct gfs2_inode *ip, struct gfs2_ea_request *er)
-{
-	return gfs2_ea_get_i(ip, er);
-}
-
-static int security_eo_set(struct gfs2_inode *ip, struct gfs2_ea_request *er)
-{
-	return gfs2_ea_set_i(ip, er);
-}
-
-static int security_eo_remove(struct gfs2_inode *ip, struct gfs2_ea_request *er)
-{
-	return gfs2_ea_remove_i(ip, er);
-}
-
 static const struct gfs2_eattr_operations gfs2_user_eaops = {
-	.eo_get = user_eo_get,
-	.eo_set = user_eo_set,
-	.eo_remove = user_eo_remove,
+	.eo_get = gfs2_ea_get_i,
+	.eo_set = gfs2_ea_set_i,
+	.eo_remove = gfs2_ea_remove_i,
 	.eo_name = "user",
 };
 
@@ -173,9 +143,9 @@ const struct gfs2_eattr_operations gfs2_system_eaops = {
 };
 
 static const struct gfs2_eattr_operations gfs2_security_eaops = {
-	.eo_get = security_eo_get,
-	.eo_set = security_eo_set,
-	.eo_remove = security_eo_remove,
+	.eo_get = gfs2_ea_get_i,
+	.eo_set = gfs2_ea_set_i,
+	.eo_remove = gfs2_ea_remove_i,
 	.eo_name = "security",
 };
 
-- 
1.5.1.2

