Return-Path: <linux-kernel-owner+w=401wt.eu-S1761572AbYB2S0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572AbYB2S0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbYB2S0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:26:34 -0500
Received: from er-systems.de ([85.25.136.202]:47245 "EHLO er-systems.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504AbYB2S0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:26:33 -0500
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Feb 2008 13:26:33 EST
Date: Fri, 29 Feb 2008 19:16:51 +0100 (CET)
From: Thomas Voegtle <tv@lio96.de>
To: linux-kernel@vger.kernel.org
cc: tilman.baumann@collax.com, Andreas Hofmeister <andi@collax.com>
Subject: permissions on /proc/tty/driver/
Message-ID: <Pine.LNX.4.64.0802291912310.24941@er-systems.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="425052808-150254357-1204309011=:24941"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--425052808-150254357-1204309011=:24941
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi,

we noticed that only root can enter /proc/tty/driver/, which appears to be 
wrong, because the files therein are actually world readable...



Signed-off-by: Tilman Baumann <tilman.baumann@collax.comy>
Signed-off-by: Thomas Voegtle <tv@lio96.de>
---
 fs/proc/proc_tty.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/proc/proc_tty.c b/fs/proc/proc_tty.c
index 49816e0..eb73d96 100644
--- a/fs/proc/proc_tty.c
+++ b/fs/proc/proc_tty.c
@@ -224,7 +224,9 @@ void __init proc_tty_init(void)
 	 * password lengths and inter-keystroke timings during password
 	 * entry.
 	 */
-	proc_tty_driver = proc_mkdir_mode("tty/driver", S_IRUSR | S_IXUSR, NULL);
+	proc_tty_driver = proc_mkdir_mode("tty/driver",
+			S_IRUSR|S_IXUSR|S_IRGRP|S_IXGRP|S_IROTH|S_IXOTH,
+			NULL);
 
 	create_proc_read_entry("tty/ldiscs", 0, NULL, tty_ldiscs_read_proc, NULL);
 	entry = create_proc_entry("tty/drivers", 0, NULL);
-- 
1.5.3

      Thomas

-- 
 Thomas Vögtle    email: thomas@voegtle-clan.de
 ----- http://www.voegtle-clan.de/thomas ------
--425052808-150254357-1204309011=:24941--
