Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbZLXAQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbZLXAQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 19:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZLXAQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 19:16:10 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50955 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbZLXAQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 19:16:09 -0500
Date: Thu, 24 Dec 2009 11:16:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: linux-next: kgdb tree build failure
Message-Id: <20091224111605.6abf0b20.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

Today's linux-next build (x86_64 allmodconfig) failed like this:

ERROR: "kgdb_active" [drivers/video/console/fbcon.ko] undefined!
ERROR: "want_console" [drivers/serial/kgdboc.ko] undefined!
ERROR: "last_console" [drivers/serial/kgdboc.ko] undefined!
ERROR: "kgdb_active" [drivers/gpu/drm/drm_kms_helper.ko] undefined!

Caused by various commits from the kgdb tree.

I added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 24 Dec 2009 11:10:41 +1100
Subject: [PATCH] kgdb: export symbols used by modules

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/char/vt.c         |    2 ++
 kernel/debug/debug_core.c |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 50faa1f..ef106d8 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -190,7 +190,9 @@ static DECLARE_WORK(console_work, console_callback);
  */
 int fg_console;
 int last_console;
+EXPORT_SYMBOL_GPL(last_console);
 int want_console = -1;
+EXPORT_SYMBOL_GPL(want_console);
 
 /*
  * For each existing display, we have a pointer to console currently visible
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 14d7c4e..c58924f 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -106,6 +106,7 @@ static struct kgdb_bkpt		kgdb_break[KGDB_MAX_BREAKPOINTS] = {
  * The CPU# of the active CPU, or -1 if none:
  */
 atomic_t			kgdb_active = ATOMIC_INIT(-1);
+EXPORT_SYMBOL_GPL(kgdb_active);
 
 /*
  * We use NR_CPUs not PERCPU, in case kgdb is used to debug early
-- 
1.6.5.4


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
