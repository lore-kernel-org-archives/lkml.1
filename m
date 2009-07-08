Return-Path: <linux-kernel-owner+w=401wt.eu-S1758431AbZGHCmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431AbZGHCmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 22:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbZGHCmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 22:42:01 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:51492 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbZGHCmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 22:42:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=dL63f6ufutk5O5/3J1IhbH2W150GBMzx95vxEBXwMJczkRwgI1PednPe7I0ID1/ZZN
         EYPNnWpempMZl9rbseTk9E6FgS75Bj/nDHnICuv8cZS+LCg3SYH8TccXbXRrmJHUADda
         +JvoNhTEKIeR6EUSvd4o6XmRBdL8w96h/HbD0=
Date: Tue, 7 Jul 2009 22:41:50 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-desktop
To: linux-kernel@vger.kernel.org
cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       teawater@gmail.com, mingo@elte.hu, tj@kernel.org,
       xiyou.wangcong@gmail.com
Subject: [PATCH] elfcore.h : Fix UML build breakage
Message-ID: <alpine.DEB.2.00.0907072226140.24195@parag-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-787006916-1247020918=:24195"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-787006916-1247020918=:24195
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

Commit a65e7bfcd74e4c0939f235d2bf9f48ddb3a57991 breaks UML build with 
below error - 

In file included from fs/proc/kcore.c:17:
include/linux/elfcore.h: In function ¡elf_core_copy_task_regs¢:
include/linux/elfcore.h:129: error: implicit declaration of function 
¡task_pt_regs¢

Fix this by restoring the previous behavior of returning 0 for all arches 
like UML that don't define task_pt_regs.

Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>

diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
index 03ec167..28f722e 100644
--- a/include/linux/elfcore.h
+++ b/include/linux/elfcore.h
@@ -125,7 +125,7 @@ static inline int elf_core_copy_task_regs(struct task_struct *t, elf_gregset_t*
 #ifdef ELF_CORE_COPY_TASK_REGS
 	
 	return ELF_CORE_COPY_TASK_REGS(t, elfregs);
-#else
+#elif defined task_pt_regs
 	elf_core_copy_regs(elfregs, task_pt_regs(t));
 #endif
 	return 0;

--8323329-787006916-1247020918=:24195--
