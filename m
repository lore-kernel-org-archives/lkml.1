Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbZKHM0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbZKHM0L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbZKHM0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:26:09 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:59088 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbZKHMWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:22:33 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       David Howells <dhowells@redhat.com>
Subject: [PATCH 12/23] sysctl security/keys: Remove dead binary sysctl support
Date: Sun,  8 Nov 2009 04:21:59 -0800
Message-Id: <1257682930-31401-12-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m14op5jjo4.fsf@fess.ebiederm.org>
References: <m14op5jjo4.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that sys_sysctl is a generic wrapper around /proc/sys  .ctl_name
and .strategy members of sysctl tables are dead code.  Remove them.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 security/keys/sysctl.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/security/keys/sysctl.c b/security/keys/sysctl.c
index 5e05dc0..3565e2f 100644
--- a/security/keys/sysctl.c
+++ b/security/keys/sysctl.c
@@ -17,7 +17,6 @@ static const int zero, one = 1, max = INT_MAX;
 
 ctl_table key_sysctls[] = {
 	{
-		.ctl_name = CTL_UNNUMBERED,
 		.procname = "maxkeys",
 		.data = &key_quota_maxkeys,
 		.maxlen = sizeof(unsigned),
@@ -27,7 +26,6 @@ ctl_table key_sysctls[] = {
 		.extra2 = (void *) &max,
 	},
 	{
-		.ctl_name = CTL_UNNUMBERED,
 		.procname = "maxbytes",
 		.data = &key_quota_maxbytes,
 		.maxlen = sizeof(unsigned),
@@ -37,7 +35,6 @@ ctl_table key_sysctls[] = {
 		.extra2 = (void *) &max,
 	},
 	{
-		.ctl_name = CTL_UNNUMBERED,
 		.procname = "root_maxkeys",
 		.data = &key_quota_root_maxkeys,
 		.maxlen = sizeof(unsigned),
@@ -47,7 +44,6 @@ ctl_table key_sysctls[] = {
 		.extra2 = (void *) &max,
 	},
 	{
-		.ctl_name = CTL_UNNUMBERED,
 		.procname = "root_maxbytes",
 		.data = &key_quota_root_maxbytes,
 		.maxlen = sizeof(unsigned),
@@ -57,7 +53,6 @@ ctl_table key_sysctls[] = {
 		.extra2 = (void *) &max,
 	},
 	{
-		.ctl_name = CTL_UNNUMBERED,
 		.procname = "gc_delay",
 		.data = &key_gc_delay,
 		.maxlen = sizeof(unsigned),
@@ -66,5 +61,5 @@ ctl_table key_sysctls[] = {
 		.extra1 = (void *) &zero,
 		.extra2 = (void *) &max,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
-- 
1.6.5.2.143.g8cc62

