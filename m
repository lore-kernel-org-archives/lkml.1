Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbYLFIVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbYLFIVA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 03:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756222AbYLFIUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 03:20:49 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:62446 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYLFIUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 03:20:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=BBzRvXxPQ5PQmrbRvBWWnD6YFBxSOU/UIexhfCl3pAfPHrbwW/6f1+DwDbBVpajayl
         KwJfMc2iZit7rfZzQjq2GODip2vsS4n062Nu8sn5Rq7bdPNZ6zkfZcZ3l5u9bbPelJf6
         HcWCrfz+qTQqaFeNN2sthAPR1wwVAs+5mSY/Y=
Message-ID: <b9df5fa10812060020i40373ed3rdc97812ed46ba959@mail.gmail.com>
Date: Sat, 6 Dec 2008 14:20:47 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/freezer.c : Removing extra checking.
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Reduces an extra checking.

Following patch removes an extra checking. We can remove it since, the
current task is frozen. If the current task is not frozen, then it
will return from __else__ condition of freezing(current) check. So,
the check becames unnecessary. It also reduces 32 bytes of text space
on my x86  (32 bit) system.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linux-2.6-orig/kernel/freezer.c	2008-12-05 19:53:45.000000000 +0600
+++ linux-2.6/kernel/freezer.c	2008-12-05 19:55:40.000000000 +0600
@@ -46,8 +46,6 @@ void refrigerator(void)

 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (!frozen(current))
-			break;
 		schedule();
 	}
 	pr_debug("%s left refrigerator\n", current->comm);
