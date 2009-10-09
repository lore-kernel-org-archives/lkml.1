Return-Path: <linux-kernel-owner+w=401wt.eu-S1761349AbZJIT1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761349AbZJIT1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 15:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761326AbZJIT1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 15:27:44 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:45453 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761316AbZJIT1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 15:27:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=on4ldNgLa1ZFYzziQfuQ+H30GVHYGIukcDuxjzNF2RzQQqum19dr0ZDBnfwBV5jHkc
         w5NECY6znnWK8Gd4m5FbN3KzsAroblLHLVLEXoEPicTSyWVD6yqiaMRrlZLjbu4eVDFr
         /HKEqLnGMfqnu1x0zbHz7I3rthClTQeY+3ySE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Jonathan Corbet <corbet@lwn.net>,
       Alessio Igor Bogani <abogani@texware.it>, Greg KH <gregkh@suse.de>
Subject: [PATCH] nvram: Drop the bkl from non-generic nvram_llseek()
Date: Fri,  9 Oct 2009 21:27:06 +0200
Message-Id: <1255116426-7270-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the bkl from nvram_llseek() as it obviously protects nothing.
The file offset is safe in essence.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: John Kacur <jkacur@redhat.com>
Cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Alessio Igor Bogani <abogani@texware.it>
Cc: Greg KH <gregkh@suse.de>
---
 drivers/char/nvram.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index b2a7eaf..d1e3987 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -214,7 +214,6 @@ void nvram_set_checksum(void)
 
 static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
 {
-	lock_kernel();
 	switch (origin) {
 	case 0:
 		/* nothing to do */
@@ -226,7 +225,7 @@ static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
 		offset += NVRAM_BYTES;
 		break;
 	}
-	unlock_kernel();
+
 	return (offset >= 0) ? (file->f_pos = offset) : -EINVAL;
 }
 
-- 
1.6.2.3

