Return-Path: <linux-kernel-owner+w=401wt.eu-S935759AbYBCDEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935759AbYBCDEu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 22:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932990AbYBCDEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 22:04:42 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:11282 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932640AbYBCDEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 22:04:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:sender;
        b=Asozq78DioA7Lu4EIknlNvkD82H8u34XcHKUtrF/gIRGuyNiHCdDz9kngqka8tRQypttJsEabxLfC3rciczuKpb6xq9gKfhCx3Qg+J/3cLDohvlntAjKPxxR/W23Ui6zhAn6rc6yiblpCYDyOqsOICRDcZUKTqV9Hw7KiSJklVc=
Date: Sun, 3 Feb 2008 08:34:29 +0530
From: Rabin Vincent <rabin@rab.in>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Remove unneeded code in sys_getpriority
Message-ID: <20080203030429.GB7459@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This check is not required because the condition is always true.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 kernel/sys.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index d1fe71e..a001974 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -212,11 +212,8 @@ asmlinkage long sys_getpriority(int which, int who)
 				p = find_task_by_vpid(who);
 			else
 				p = current;
-			if (p) {
-				niceval = 20 - task_nice(p);
-				if (niceval > retval)
-					retval = niceval;
-			}
+			if (p)
+				retval = 20 - task_nice(p);
 			break;
 		case PRIO_PGRP:
 			if (who)
-- 
1.5.3.8

