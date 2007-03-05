Return-Path: <linux-kernel-owner+w=401wt.eu-S1751949AbXCEBr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbXCEBr6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbXCEBr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:47:57 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49917 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751861AbXCEBrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:47:47 -0500
Date: Mon, 5 Mar 2007 02:47:48 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [-mm patch] drivers/cpuidle/: make code static
Message-ID: <20070305014748.GT3441@stusta.de>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 03:00:26AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-mm2:
>...
>  git-acpi.patch
>...
>  git trees
>...

This patch makes the following needlessly global code static:
- driver.c: __cpuidle_find_driver()
- governor.c: __cpuidle_find_governor()
- ladder.c: struct ladder_governor
 
Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/cpuidle/cpuidle.h          |    2 --
 drivers/cpuidle/driver.c           |    2 +-
 drivers/cpuidle/governor.c         |    2 +-
 drivers/cpuidle/governors/ladder.c |    2 +-
 4 files changed, 3 insertions(+), 5 deletions(-)

--- linux-2.6.21-rc2-mm1/drivers/cpuidle/cpuidle.h.old	2007-03-04 20:42:29.000000000 +0100
+++ linux-2.6.21-rc2-mm1/drivers/cpuidle/cpuidle.h	2007-03-04 20:43:13.000000000 +0100
@@ -23,13 +23,11 @@
 /* drivers */
 extern int cpuidle_attach_driver(struct cpuidle_device *dev);
 extern void cpuidle_detach_driver(struct cpuidle_device *dev);
-extern struct cpuidle_driver * __cpuidle_find_driver(const char *str);
 extern int cpuidle_switch_driver(struct cpuidle_driver *drv);
 
 /* governors */
 extern int cpuidle_attach_governor(struct cpuidle_device *dev);
 extern void cpuidle_detach_governor(struct cpuidle_device *dev);
-extern struct cpuidle_governor * __cpuidle_find_governor(const char *str);
 extern int cpuidle_switch_governor(struct cpuidle_governor *gov);
 
 /* sysfs */
--- linux-2.6.21-rc2-mm1/drivers/cpuidle/driver.c.old	2007-03-04 20:42:46.000000000 +0100
+++ linux-2.6.21-rc2-mm1/drivers/cpuidle/driver.c	2007-03-04 20:42:55.000000000 +0100
@@ -73,7 +73,7 @@
  *
  * Must be called with cpuidle_lock aquired.
  */
-struct cpuidle_driver * __cpuidle_find_driver(const char *str)
+static struct cpuidle_driver * __cpuidle_find_driver(const char *str)
 {
 	struct cpuidle_driver *drv;
 
--- linux-2.6.21-rc2-mm1/drivers/cpuidle/governor.c.old	2007-03-04 20:43:22.000000000 +0100
+++ linux-2.6.21-rc2-mm1/drivers/cpuidle/governor.c	2007-03-04 20:43:29.000000000 +0100
@@ -72,7 +72,7 @@
  *
  * Must be called with cpuidle_lock aquired.
  */
-struct cpuidle_governor * __cpuidle_find_governor(const char *str)
+static struct cpuidle_governor * __cpuidle_find_governor(const char *str)
 {
 	struct cpuidle_governor *gov;
 
--- linux-2.6.21-rc2-mm1/drivers/cpuidle/governors/ladder.c.old	2007-03-04 20:43:51.000000000 +0100
+++ linux-2.6.21-rc2-mm1/drivers/cpuidle/governors/ladder.c	2007-03-04 20:44:01.000000000 +0100
@@ -199,7 +199,7 @@
 	kfree(dev->governor_data);
 }
 
-struct cpuidle_governor ladder_governor = {
+static struct cpuidle_governor ladder_governor = {
 	.name =		"ladder",
 	.init =		ladder_init_device,
 	.exit =		ladder_exit_device,

