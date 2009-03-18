Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbZCRNbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbZCRNbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 09:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756750AbZCRN1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 09:27:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756627AbZCRN0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 09:26:54 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 13/18] GFS2: Support quota/noquota mount arguments
Date: Wed, 18 Mar 2009 12:23:48 +0000
Message-Id: <1237379033-28095-14-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1237379033-28095-13-git-send-email-swhiteho@redhat.com>
References: <1237379033-28095-1-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-2-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-3-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-4-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-5-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-6-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-7-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-8-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-9-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-10-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-11-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-12-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-13-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This adds support for "quota" and "noquota" mount options in addition to the
existing "quota=on/off/account" so that we are compatible with the names by
which these options are more generally known.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/mount.c b/fs/gfs2/mount.c
index ee69701..f7e8527 100644
--- a/fs/gfs2/mount.c
+++ b/fs/gfs2/mount.c
@@ -36,6 +36,8 @@ enum {
 	Opt_quota_off,
 	Opt_quota_account,
 	Opt_quota_on,
+	Opt_quota,
+	Opt_noquota,
 	Opt_suiddir,
 	Opt_nosuiddir,
 	Opt_data_writeback,
@@ -62,6 +64,8 @@ static const match_table_t tokens = {
 	{Opt_quota_off, "quota=off"},
 	{Opt_quota_account, "quota=account"},
 	{Opt_quota_on, "quota=on"},
+	{Opt_quota, "quota"},
+	{Opt_noquota, "noquota"},
 	{Opt_suiddir, "suiddir"},
 	{Opt_nosuiddir, "nosuiddir"},
 	{Opt_data_writeback, "data=writeback"},
@@ -138,12 +142,14 @@ int gfs2_mount_args(struct gfs2_sbd *sdp, struct gfs2_args *args, char *options)
 			args->ar_posix_acl = 0;
 			break;
 		case Opt_quota_off:
+		case Opt_noquota:
 			args->ar_quota = GFS2_QUOTA_OFF;
 			break;
 		case Opt_quota_account:
 			args->ar_quota = GFS2_QUOTA_ACCOUNT;
 			break;
 		case Opt_quota_on:
+		case Opt_quota:
 			args->ar_quota = GFS2_QUOTA_ON;
 			break;
 		case Opt_suiddir:
-- 
1.6.0.3

