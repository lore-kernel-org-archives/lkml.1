Return-Path: <linux-kernel-owner+w=401wt.eu-S933005AbXHJBCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005AbXHJBCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 21:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760098AbXHJBCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 21:02:23 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36226 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759698AbXHJBCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 21:02:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@sw.ru>,
       axboe@kernel.dk, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 08/10] sysctl: Remove broken cdrom binary sysctls
References: <20070726164518.GB16937@localhost.sw.ru>
	<m13azbulhf.fsf@ebiederm.dsl.xmission.com>
	<20070727145235.GC6924@localhost.sw.ru>
	<20070806124530.GD6634@localhost.sw.ru>
	<m1tzr8a3ms.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps1wa3kf.fsf_-_@ebiederm.dsl.xmission.com>
	<m1hcn8a2rq.fsf_-_@ebiederm.dsl.xmission.com>
	<m1d4xw9psl.fsf_-_@ebiederm.dsl.xmission.com>
	<m18x8k9ppv.fsf_-_@ebiederm.dsl.xmission.com>
	<m14pj89pmt.fsf_-_@ebiederm.dsl.xmission.com>
	<m1zm108axi.fsf_-_@ebiederm.dsl.xmission.com>
	<m1vebo8avf.fsf_-_@ebiederm.dsl.xmission.com>
	<m1r6mc8at5.fsf_-_@ebiederm.dsl.xmission.com>
	<m1myx08arh.fsf_-_@ebiederm.dsl.xmission.com>
Date: Thu, 09 Aug 2007 19:01:14 -0600
In-Reply-To: <m1myx08arh.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Thu, 09 Aug 2007 18:59:46 -0600")
Message-ID: <m1ir7o8ap1.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The binary interface for the cdrom sysctls can't possilby work.
So remove the binary sysctls and update the test for finding
out which sysctl table entry we are dealy with to use the procname
and not the ctl_name (which I am removing).

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/cdrom/cdrom.c |   31 +++++++++----------------------
 1 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 67ee3d4..f0c6318 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -3468,32 +3468,25 @@ static int cdrom_sysctl_handler(ctl_table *ctl, int write, struct file * filp,
 		else
 			*valp = 0;
 
-		switch (ctl->ctl_name) {
-		case DEV_CDROM_AUTOCLOSE: {
+		if (strcmp(ctl->procname, "autoclose") == 0) {
 			if (valp == &cdrom_sysctl_settings.autoclose)
 				autoclose = cdrom_sysctl_settings.autoclose;
-			break;
-			}
-		case DEV_CDROM_AUTOEJECT: {
+		}
+		else if (strcmp(ctl->procname, "autoeject") == 0) {
 			if (valp == &cdrom_sysctl_settings.autoeject)
 				autoeject = cdrom_sysctl_settings.autoeject;
-			break;
-			}
-		case DEV_CDROM_DEBUG: {
+		}
+		else if (strcmp(ctl->procname, "debug") == 0) {
 			if (valp == &cdrom_sysctl_settings.debug)
 				debug = cdrom_sysctl_settings.debug;
-			break;
-			}
-		case DEV_CDROM_LOCK: {
+		}
+		else if (strcmp(ctl->procname, "lock") == 0) {
 			if (valp == &cdrom_sysctl_settings.lock)
 				lockdoor = cdrom_sysctl_settings.lock;
-			break;
-			}
-		case DEV_CDROM_CHECK_MEDIA: {
+		}
+		else if (strcmp(ctl->procname, "check_media") == 0) {
 			if (valp == &cdrom_sysctl_settings.check)
 				check_media_type = cdrom_sysctl_settings.check;
-			break;
-			}
 		}
 		/* update the option flags according to the changes. we
 		   don't have per device options through sysctl yet,
@@ -3507,7 +3500,6 @@ static int cdrom_sysctl_handler(ctl_table *ctl, int write, struct file * filp,
 /* Place files in /proc/sys/dev/cdrom */
 static ctl_table cdrom_table[] = {
 	{
-		.ctl_name	= DEV_CDROM_INFO,
 		.procname	= "info",
 		.data		= &cdrom_sysctl_settings.info, 
 		.maxlen		= CDROM_STR_SIZE,
@@ -3515,7 +3507,6 @@ static ctl_table cdrom_table[] = {
 		.proc_handler	= &cdrom_sysctl_info,
 	},
 	{
-		.ctl_name	= DEV_CDROM_AUTOCLOSE,
 		.procname	= "autoclose",
 		.data		= &cdrom_sysctl_settings.autoclose,
 		.maxlen		= sizeof(int),
@@ -3523,7 +3514,6 @@ static ctl_table cdrom_table[] = {
 		.proc_handler	= &cdrom_sysctl_handler,
 	},
 	{
-		.ctl_name	= DEV_CDROM_AUTOEJECT,
 		.procname	= "autoeject",
 		.data		= &cdrom_sysctl_settings.autoeject,
 		.maxlen		= sizeof(int),
@@ -3531,7 +3521,6 @@ static ctl_table cdrom_table[] = {
 		.proc_handler	= &cdrom_sysctl_handler,
 	},
 	{
-		.ctl_name	= DEV_CDROM_DEBUG,
 		.procname	= "debug",
 		.data		= &cdrom_sysctl_settings.debug,
 		.maxlen		= sizeof(int),
@@ -3539,7 +3528,6 @@ static ctl_table cdrom_table[] = {
 		.proc_handler	= &cdrom_sysctl_handler,
 	},
 	{
-		.ctl_name	= DEV_CDROM_LOCK,
 		.procname	= "lock",
 		.data		= &cdrom_sysctl_settings.lock,
 		.maxlen		= sizeof(int),
@@ -3547,7 +3535,6 @@ static ctl_table cdrom_table[] = {
 		.proc_handler	= &cdrom_sysctl_handler,
 	},
 	{
-		.ctl_name	= DEV_CDROM_CHECK_MEDIA,
 		.procname	= "check_media",
 		.data		= &cdrom_sysctl_settings.check,
 		.maxlen		= sizeof(int),
-- 
1.5.1.1.181.g2de0

