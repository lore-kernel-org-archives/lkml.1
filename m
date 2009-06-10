Return-Path: <linux-kernel-owner+w=401wt.eu-S1760188AbZFJJnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188AbZFJJnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758825AbZFJJih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:38:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40334 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758752AbZFJJiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:38:19 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 20/24] GFS2: Remove args subdir from gfs2 sysfs files
Date: Wed, 10 Jun 2009 09:31:01 +0100
Message-Id: <1244622665-7470-21-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244622665-7470-20-git-send-email-swhiteho@redhat.com>
References: <1244622665-7470-1-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-2-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-3-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-4-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-5-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-6-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-7-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-8-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-9-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-10-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-11-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-12-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-13-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-14-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-15-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-16-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-17-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-18-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-19-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-20-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we can cat /proc/mounts there is no need to have this
subdirectory in the gfs2 sysfs files. In fact this does not
reflect the full range of possible mount argumenmts, where
as /proc/mounts does.

There was only one userland user of this set of sysfs files
and it will function perfectly well without these files
being present (in fact that subcommand of gfs2_tool is
obsolete anyway).

The tune/* subdirectory is also considered mostly obsolete,
but there are a few uses of this until mount arguments can
be added for the last few functions for which there are no
equivalents currently. However the tune/* directory is still
in my sights and new code should avoid using it. Only the gfs2_quota
and gfs2_tool programs are know to use tune/* at the moment.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 94bd59e..23419dc 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -411,44 +411,6 @@ static struct attribute *lock_module_attrs[] = {
 	NULL,
 };
 
-#define ARGS_ATTR(name, fmt)                                                \
-static ssize_t name##_show(struct gfs2_sbd *sdp, char *buf)                 \
-{                                                                           \
-	return snprintf(buf, PAGE_SIZE, fmt, sdp->sd_args.ar_##name);       \
-}                                                                           \
-static struct gfs2_attr args_attr_##name = __ATTR_RO(name)
-
-ARGS_ATTR(lockproto,       "%s\n");
-ARGS_ATTR(locktable,       "%s\n");
-ARGS_ATTR(hostdata,        "%s\n");
-ARGS_ATTR(spectator,       "%d\n");
-ARGS_ATTR(ignore_local_fs, "%d\n");
-ARGS_ATTR(localcaching,    "%d\n");
-ARGS_ATTR(localflocks,     "%d\n");
-ARGS_ATTR(debug,           "%d\n");
-ARGS_ATTR(upgrade,         "%d\n");
-ARGS_ATTR(posix_acl,       "%d\n");
-ARGS_ATTR(quota,           "%u\n");
-ARGS_ATTR(suiddir,         "%d\n");
-ARGS_ATTR(data,            "%d\n");
-
-static struct attribute *args_attrs[] = {
-	&args_attr_lockproto.attr,
-	&args_attr_locktable.attr,
-	&args_attr_hostdata.attr,
-	&args_attr_spectator.attr,
-	&args_attr_ignore_local_fs.attr,
-	&args_attr_localcaching.attr,
-	&args_attr_localflocks.attr,
-	&args_attr_debug.attr,
-	&args_attr_upgrade.attr,
-	&args_attr_posix_acl.attr,
-	&args_attr_quota.attr,
-	&args_attr_suiddir.attr,
-	&args_attr_data.attr,
-	NULL,
-};
-
 /*
  * get and set struct gfs2_tune fields
  */
@@ -545,11 +507,6 @@ static struct attribute *tune_attrs[] = {
 	NULL,
 };
 
-static struct attribute_group args_group = {
-	.name = "args",
-	.attrs = args_attrs,
-};
-
 static struct attribute_group tune_group = {
 	.name = "tune",
 	.attrs = tune_attrs,
@@ -570,13 +527,9 @@ int gfs2_sys_fs_add(struct gfs2_sbd *sdp)
 	if (error)
 		goto fail;
 
-	error = sysfs_create_group(&sdp->sd_kobj, &args_group);
-	if (error)
-		goto fail_reg;
-
 	error = sysfs_create_group(&sdp->sd_kobj, &tune_group);
 	if (error)
-		goto fail_args;
+		goto fail_reg;
 
 	error = sysfs_create_group(&sdp->sd_kobj, &lock_module_group);
 	if (error)
@@ -587,8 +540,6 @@ int gfs2_sys_fs_add(struct gfs2_sbd *sdp)
 
 fail_tune:
 	sysfs_remove_group(&sdp->sd_kobj, &tune_group);
-fail_args:
-	sysfs_remove_group(&sdp->sd_kobj, &args_group);
 fail_reg:
 	kobject_put(&sdp->sd_kobj);
 fail:
@@ -599,7 +550,6 @@ fail:
 void gfs2_sys_fs_del(struct gfs2_sbd *sdp)
 {
 	sysfs_remove_group(&sdp->sd_kobj, &tune_group);
-	sysfs_remove_group(&sdp->sd_kobj, &args_group);
 	sysfs_remove_group(&sdp->sd_kobj, &lock_module_group);
 	kobject_put(&sdp->sd_kobj);
 }
-- 
1.6.0.6

