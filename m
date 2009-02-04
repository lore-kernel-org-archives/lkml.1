Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbZBDJQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbZBDJQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 04:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbZBDJPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 04:15:46 -0500
Received: from mx6.mail.ru ([194.67.23.26]:19522 "EHLO mx6.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbZBDJPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 04:15:42 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: [PATCH] Fix pm_notifiers during user mode hibernation
To: linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org
Date: Wed, 04 Feb 2009 12:15:37 +0300
Message-ID: <20090204091509.9383.43143.stgit@cooker.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Snapshot device is opened with O_RDONLY during suspend and
O_WRONLY durig resume. Make sure we also call notifiers with
correct parameter telling them what we are really doing.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

---

 kernel/power/user.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/power/user.c b/kernel/power/user.c
index 005b93d..6c85359 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -95,15 +95,15 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 		data->swap = swsusp_resume_device ?
 			swap_type_of(swsusp_resume_device, 0, NULL) : -1;
 		data->mode = O_RDONLY;
-		error = pm_notifier_call_chain(PM_RESTORE_PREPARE);
+		error = pm_notifier_call_chain(PM_HIBERNATION_PREPARE);
 		if (error)
-			pm_notifier_call_chain(PM_POST_RESTORE);
+			pm_notifier_call_chain(PM_POST_HIBERNATION);
 	} else {
 		data->swap = -1;
 		data->mode = O_WRONLY;
-		error = pm_notifier_call_chain(PM_HIBERNATION_PREPARE);
+		error = pm_notifier_call_chain(PM_RESTORE_PREPARE);
 		if (error)
-			pm_notifier_call_chain(PM_POST_HIBERNATION);
+			pm_notifier_call_chain(PM_POST_RESTORE);
 	}
 	if (error)
 		atomic_inc(&snapshot_device_available);

