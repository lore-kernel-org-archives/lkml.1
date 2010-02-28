Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030352Ab0B1QUt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 11:20:49 -0500
Received: from www.tglx.de ([62.245.132.106]:37717 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964812Ab0B1QUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 11:20:48 -0500
Date: Sun, 28 Feb 2010 17:20:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] bkl removal for 2.6.34
Message-ID: <alpine.LFD.2.00.1002281719550.4245@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest bkl-drivers-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git bkl-drivers-for-linus

Thanks,

	tglx

------------------>
Ingo Molnar (1):
      nvram: Drop the BKL from nvram_open()


 drivers/char/nvram.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index 2100a8f..7cf4518 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -329,14 +329,12 @@ static int nvram_ioctl(struct inode *inode, struct file *file,
 
 static int nvram_open(struct inode *inode, struct file *file)
 {
-	lock_kernel();
 	spin_lock(&nvram_state_lock);
 
 	if ((nvram_open_cnt && (file->f_flags & O_EXCL)) ||
 	    (nvram_open_mode & NVRAM_EXCL) ||
 	    ((file->f_mode & FMODE_WRITE) && (nvram_open_mode & NVRAM_WRITE))) {
 		spin_unlock(&nvram_state_lock);
-		unlock_kernel();
 		return -EBUSY;
 	}
 
@@ -347,7 +345,6 @@ static int nvram_open(struct inode *inode, struct file *file)
 	nvram_open_cnt++;
 
 	spin_unlock(&nvram_state_lock);
-	unlock_kernel();
 
 	return 0;
 }
