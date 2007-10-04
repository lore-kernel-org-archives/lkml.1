Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbXJDJ0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbXJDJ0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759422AbXJDJSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:18:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759521AbXJDJR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:17:58 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 24/51] [GFS2] Add NULL entry to token table
Date: Thu,  4 Oct 2007 09:49:17 +0100
Message-Id: <11914878342921-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878323899-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
 <1191487802255-git-send-email-swhiteho@redhat.com>
 <11914878043598-git-send-email-swhiteho@redhat.com>
 <11914878063121-git-send-email-swhiteho@redhat.com>
 <11914878081562-git-send-email-swhiteho@redhat.com>
 <11914878102813-git-send-email-swhiteho@redhat.com>
 <1191487812928-git-send-email-swhiteho@redhat.com>
 <11914878141625-git-send-email-swhiteho@redhat.com>
 <1191487815172-git-send-email-swhiteho@redhat.com>
 <11914878173677-git-send-email-swhiteho@redhat.com>
 <11914878191964-git-send-email-swhiteho@redhat.com>
 <11914878214113-git-send-email-swhiteho@redhat.com>
 <11914878231394-git-send-email-swhiteho@redhat.com>
 <11914878252873-git-send-email-swhiteho@redhat.com>
 <11914878271468-git-send-email-swhiteho@redhat.com>
 <11914878283252-git-send-email-swhiteho@redhat.com>
 <11914878304004-git-send-email-swhiteho@redhat.com>
 <11914878323899-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

match_token() was returning garbage data instead of a fail value. This data
happened to match a valid option id for an option that required an argument (in
this case, lockproto=%s) For match_token() to correctly fail if the option
doesn't match any of the tokens, the token table must end with a NULL entry.
This patch adds the NULL entry.

Signed-off-by: Benjamin E. Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/mount.c b/fs/gfs2/mount.c
index 4864659..b941f9f 100644
--- a/fs/gfs2/mount.c
+++ b/fs/gfs2/mount.c
@@ -42,6 +42,7 @@ enum {
 	Opt_nosuiddir,
 	Opt_data_writeback,
 	Opt_data_ordered,
+	Opt_err,
 };
 
 static match_table_t tokens = {
@@ -64,7 +65,8 @@ static match_table_t tokens = {
 	{Opt_suiddir, "suiddir"},
 	{Opt_nosuiddir, "nosuiddir"},
 	{Opt_data_writeback, "data=writeback"},
-	{Opt_data_ordered, "data=ordered"}
+	{Opt_data_ordered, "data=ordered"},
+	{Opt_err, NULL}
 };
 
 /**
@@ -237,6 +239,7 @@ int gfs2_mount_args(struct gfs2_sbd *sdp, char *data_arg, int remount)
 		case Opt_data_ordered:
 			args->ar_data = GFS2_DATA_ORDERED;
 			break;
+		case Opt_err:
 		default:
 			fs_info(sdp, "unknown option: %s\n", o);
 			error = -EINVAL;
-- 
1.5.1.2

