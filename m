Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab0CLMLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 07:11:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:12065 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab0CLMLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 07:11:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=hezASlo1oZEHgmG99BiuVGuIx8tKTS2COSS44qSsb0R1EiqDRQPc0MKtF7NRuOSm7g
         jUSJPXpOykYSkmhwSPjuyIYha/dPDR2prfkcaL968ewCY9rZUIU9+Y2uph75x3PHzgEu
         oRly2kp7/kMbI0Kwm+3LwOatIrwCjbvz9zmnE=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       rt-users <linux-rt-users@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Wu Zhangjin <wuzhangjin@gmail.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH] ide: Build break in ide-iops.c
Date: Fri, 12 Mar 2010 13:10:50 +0100
Message-Id: <1268395850-23408-2-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1268395850-23408-1-git-send-email-jkacur@redhat.com>
References: <1268395850-23408-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get the following build break due to 876c52cc046e00eaa2ffc5124dc187106ef57594

drivers/ide/ide-iops.c:29:26: error: asm/bootinfo.h: No such file or directory

Protect the include by #ifdef CONFIG_MIPS

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/ide/ide-iops.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 9dba71e..8d32dda 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -26,7 +26,10 @@
 #include <asm/irq.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
+
+#ifdef CONFIG_MIPS
 #include <asm/bootinfo.h>
+#endif
 
 void SELECT_MASK(ide_drive_t *drive, int mask)
 {
-- 
1.6.6.1

