Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbXJKGRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbXJKGRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 02:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbXJKGRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 02:17:10 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:26474 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbXJKGRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 02:17:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=awHvXj5MW+fo1c6PuttPIh+xcunM6qxwQO+d0MQpFt1bgIRYBE0/hg+5t/WK87CjjgeG2k7BTySE3Q5VtmuXYnnpSX1nByZhy7cK9aXt5JloW/hlevY6KuHPFjjv7/8pQygBbV1Mc9wrtKZYvuMrwI50L4xOfZPyNw8Iagb27BU=
Subject: [PATCH] init: Fix printk format strings
From: Vegard Nossum <vegard.nossum@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 11 Oct 2007 08:17:02 +0200
Message-Id: <1192083422.26648.19.camel@grianne>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This makes sure printk format strings are string literals containing no
more than a single line.


Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 init/calibrate.c        |    4 +++-
 init/do_mounts_initrd.c |    5 ++++-
 init/main.c             |    2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index 40ff3b4..2a35718 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -98,7 +98,9 @@ static unsigned long __devinit calibrate_delay_direct(void)
 		return (good_tsc_sum/good_tsc_count);
 
 	printk(KERN_WARNING "calibrate_delay_direct() failed to get a good "
-	       "estimate for loops_per_jiffy.\nProbably due to long platform interrupts. Consider using \"lpj=\" boot option.\n");
+	       "estimate for loops_per_jiffy.\n");
+	printk(KERN_WARNING "Probably due to long platform interrupts. "
+		"Consider using \"lpj=\" boot option.\n");
 	return 0;
 }
 #else
diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index fd4fc12..ad6174c 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -98,7 +98,10 @@ static void __init handle_initrd(void)
 			error = sys_ioctl(fd, BLKFLSBUF, 0);
 			sys_close(fd);
 		}
-		printk(!error ? "okay\n" : "failed\n");
+		if(error)
+			printk("failed\n");
+		else
+			printk("okay\n");
 	}
 }
 
diff --git a/init/main.c b/init/main.c
index 9def935..5491bba 100644
--- a/init/main.c
+++ b/init/main.c
@@ -537,7 +537,7 @@ asmlinkage void __init start_kernel(void)
 	boot_cpu_init();
 	page_address_init();
 	printk(KERN_NOTICE);
-	printk(linux_banner);
+	printk("%s", linux_banner);
 	setup_arch(&command_line);
 	setup_command_line(command_line);
 	unwind_setup();
-- 
1.5.2.4



