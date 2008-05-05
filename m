Return-Path: <linux-kernel-owner+w=401wt.eu-S1759925AbYEERFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925AbYEERFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 13:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYEERFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 13:05:44 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:18829 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbYEERFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 13:05:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ILZuN2Nu1oMLCYhDQEjbOSYEeLj7jiJSAk72VPPJZu1yUpvelQZUvXK879adip1NU+21IpsjhwmVMImnq4uGXrIUoN7h5wRO4lvE+glN+dTjPzqeuAiEo47ciuBSC4EnimsH/VW31cHanJ8nF/m053BwCUfm/TtRr8IOiOZ4CW0=
From: Denis Cheng <crquan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Denis <cr_quan@163.com>
Subject: [PATCH] mm/pdflush.c: merge the same code in two path
Date: Tue,  6 May 2008 01:05:09 +0800
Message-Id: <1210007109-15998-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 mm/pdflush.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/pdflush.c b/mm/pdflush.c
index 1c96cfc..9d834aa 100644
--- a/mm/pdflush.c
+++ b/mm/pdflush.c
@@ -207,7 +207,6 @@ int pdflush_operation(void (*fn)(unsigned long), unsigned long arg0)
 
 	spin_lock_irqsave(&pdflush_lock, flags);
 	if (list_empty(&pdflush_list)) {
-		spin_unlock_irqrestore(&pdflush_lock, flags);
 		ret = -1;
 	} else {
 		struct pdflush_work *pdf;
@@ -219,8 +218,9 @@ int pdflush_operation(void (*fn)(unsigned long), unsigned long arg0)
 		pdf->fn = fn;
 		pdf->arg0 = arg0;
 		wake_up_process(pdf->who);
-		spin_unlock_irqrestore(&pdflush_lock, flags);
 	}
+	spin_unlock_irqrestore(&pdflush_lock, flags);
+
 	return ret;
 }
 
-- 
1.5.5.1

