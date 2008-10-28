Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbYJ1J3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbYJ1J3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 05:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbYJ1J3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 05:29:24 -0400
Received: from qb-out-0506.google.com ([72.14.204.227]:52174 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbYJ1J3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 05:29:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=FIN1FjYFcQFnoaNGWhWa7h7OMeim8Ew15PYdXENvrA9OG+9WYI8wWmYGX3R4jI4x1I
         YAsvU00mJq91b/OLEPOX7L6iakkVUKrd4c1irdCMZFtrX3H69hgh2Cew8NbsQv3Ovhc2
         9/OfCoS2V3x/MsxQhC1L4IOVTaFS7R67xyPRw=
Message-ID: <21d34cad0810280229y790ca761je9f0c8695e0b44ba@mail.gmail.com>
Date: Tue, 28 Oct 2008 17:29:20 +0800
From: "qinghuang feng" <qhfeng.kernel@gmail.com>
To: mingo@redhat.com, peterz@infradead.org
Subject: [PATCH RESEND] LOCKDEP: minor fix for debug_show_all_locks()
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we failed to get tasklist_lock eventually (count equals 0),
we should only print " ignoring it.\n", and not print
" locked it.\n" needlessly.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index dbda475..6533fd9 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3417,8 +3417,7 @@ retry:
 		}
 		printk(" ignoring it.\n");
 		unlock = 0;
-	}
-	if (count != 10)
+	} else if (count != 10)
 		printk(" locked it.\n");

 	do_each_thread(g, p) {
