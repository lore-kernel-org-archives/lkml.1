Return-Path: <linux-kernel-owner+w=401wt.eu-S1761325AbYASPIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761325AbYASPIN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 10:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757635AbYASPH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 10:07:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:62605 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757550AbYASPH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 10:07:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=QnZKITt0MfbKZ+vd67B6I0wgw3dTRA6isJ0n/bYlF72NYY1kBQWbJk2qCWCdG8MQ8rymij4ElkBgP1pTKIy2sXLs0AHHp78ijxaP237GjzPXewyuQnhJziTnlsl7ovhZ1I8aOYhTElpEUlPvEu5bk2WOzzjAHf/yNBBmi66Rqcs=
Date: Sat, 19 Jan 2008 18:07:37 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] driver: ip27-rtc - convert ioctl to unlocked_ioctl v2
Message-ID: <20080119150737.GB7231@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does convert ioctl call to unlocked_ioctl form.
It is possible (in that simple way) due to a spinlock protection.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Jiri Slaby <jirislaby@gmail.com>

---

 drivers/char/ip27-rtc.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/char/ip27-rtc.c b/drivers/char/ip27-rtc.c
index 932264a..86e6538 100644
--- a/drivers/char/ip27-rtc.c
+++ b/drivers/char/ip27-rtc.c
@@ -46,8 +46,8 @@
 #include <asm/sn/sn0/hub.h>
 #include <asm/sn/sn_private.h>
 
-static int rtc_ioctl(struct inode *inode, struct file *file,
-		     unsigned int cmd, unsigned long arg);
+static long rtc_ioctl(struct file *filp, unsigned int cmd,
+			unsigned long arg);
 
 static int rtc_read_proc(char *page, char **start, off_t off,
                          int count, int *eof, void *data);
@@ -75,8 +75,7 @@ static unsigned long epoch = 1970;	/* year corresponding to 0x00	*/
 static const unsigned char days_in_mo[] =
 {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
 
-static int rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		     unsigned long arg)
+static long rtc_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 
 	struct rtc_time wtime;
@@ -197,7 +196,7 @@ static int rtc_release(struct inode *inode, struct file *file)
 
 static const struct file_operations rtc_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= rtc_ioctl,
+	.unlocked_ioctl	= rtc_ioctl,
 	.open		= rtc_open,
 	.release	= rtc_release,
 };
