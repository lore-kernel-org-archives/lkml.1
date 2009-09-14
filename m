Return-Path: <linux-kernel-owner+w=401wt.eu-S933608AbZINUIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608AbZINUIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933598AbZINUIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:50 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54074 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933556AbZINUIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:39 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 32/72] Blackfin: do not try displaying the end of the stack
Date: Mon, 14 Sep 2009 16:07:36 -0400
Message-Id: <1252958896-25150-33-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

The end of the stack may not be valid (and that could be OK), so do not
attempt to parse it.  If we do, we might use a bad pointer in kernel space
which makes things panic().

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/traps.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 519acca..18c6cd4 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -911,7 +911,7 @@ void show_stack(struct task_struct *task, unsigned long *stack)
 		frame_no = 0;
 
 		for (addr = (unsigned int *)((unsigned int)stack & ~0xF), i = 0;
-		     addr <= endstack; addr++, i++) {
+		     addr < endstack; addr++, i++) {
 
 			ret_addr = 0;
 			if (!j && i % 8 == 0)
-- 
1.6.4.2

