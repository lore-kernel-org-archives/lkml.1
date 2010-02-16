Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab0BPQWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 11:22:03 -0500
Received: from mail-gx0-f227.google.com ([209.85.217.227]:60044 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab0BPQWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 11:22:00 -0500
X-Greylist: delayed 1355 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Feb 2010 11:22:00 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Zj5TkwJFTVvrml29A2sDuavJ3zFtfuRGnPtvjw19yxlYXXV+3APn0XAcxHiuLipOJQ
         ewwSmWC3sB+XQjCw6nVhYd9bH5Pkhv8PNm3yuzYzryImDtkhpLhmNNmT7Tz7+RwrcSyX
         mOzZ5nVQtXz+uWXlqTJl2wou3G9huvZKFdygE=
Subject: [PATCH -mm] Kill existing current task quickly
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Feb 2010 00:59:17 +0900
Message-ID: <1266335957.1709.67.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not sure why didn't we break the loop until now. 
As looking git log, I found it is removed by Nick at b78483a.
He mentioned "introduced a problem". If I miss something, 
pz, correct me. 

== CUT_HERE ==

[PATCH -mm] Kill existing current task quickly

If we found current task is existing but didn't set TIF_MEMDIE
during OOM victim selection, let's stop unnecessary looping for
getting high badness score task and go ahead for killing current.

This patch would make side effect skip OOM_DISABLE test.
But It's okay since the task is existing and oom_kill_process
doesn't show any killing message since __oom_kill_task will
interrupt it in oom_kill_process.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>
---
 mm/oom_kill.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 3618be3..5c21398 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -295,6 +295,7 @@ static struct task_struct
*select_bad_process(unsigned long *ppoints,
 
 			chosen = p;
 			*ppoints = ULONG_MAX;
+			break;
 		}
 
 		if (p->signal->oom_adj == OOM_DISABLE)
-- 
1.6.5



-- 
Kind regards,
Minchan Kim


