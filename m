Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbYACXwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbYACXwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 18:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYACXw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 18:52:29 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:45920 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbYACXw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 18:52:28 -0500
From: Guillaume Chazarain <guichaz@yahoo.fr>
Subject: [PATCH] proc: advertise new restrictions on /proc/*/maps &
	/proc/*/smaps
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Date: Fri, 04 Jan 2008 00:51:50 +0100
Message-ID: <20080103235150.2870.31703.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that strangers are kept out of /proc/<pid>/maps, let's welcome them
with -EPERM instead of a blank file.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
---

 fs/proc/base.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/proc/base.c b/fs/proc/base.c
index 7411bfb..c824b23 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2207,7 +2207,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	INF("cmdline",    S_IRUGO, pid_cmdline),
 	INF("stat",       S_IRUGO, tgid_stat),
 	INF("statm",      S_IRUGO, pid_statm),
-	REG("maps",       S_IRUGO, maps),
+	REG("maps",       S_IRUSR, maps),
 #ifdef CONFIG_NUMA
 	REG("numa_maps",  S_IRUGO, numa_maps),
 #endif
@@ -2219,7 +2219,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("mountstats", S_IRUSR, mountstats),
 #ifdef CONFIG_MMU
 	REG("clear_refs", S_IWUSR, clear_refs),
-	REG("smaps",      S_IRUGO, smaps),
+	REG("smaps",      S_IRUSR, smaps),
 #endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",       S_IRUGO|S_IXUGO, attr_dir),
@@ -2533,7 +2533,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	INF("cmdline",   S_IRUGO, pid_cmdline),
 	INF("stat",      S_IRUGO, tid_stat),
 	INF("statm",     S_IRUGO, pid_statm),
-	REG("maps",      S_IRUGO, maps),
+	REG("maps",      S_IRUSR, maps),
 #ifdef CONFIG_NUMA
 	REG("numa_maps", S_IRUGO, numa_maps),
 #endif
@@ -2544,7 +2544,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("mounts",    S_IRUGO, mounts),
 #ifdef CONFIG_MMU
 	REG("clear_refs", S_IWUSR, clear_refs),
-	REG("smaps",     S_IRUGO, smaps),
+	REG("smaps",     S_IRUSR, smaps),
 #endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",      S_IRUGO|S_IXUGO, attr_dir),

