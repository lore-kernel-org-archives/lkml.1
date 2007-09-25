Return-Path: <linux-kernel-owner+w=401wt.eu-S1751967AbXIYJlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbXIYJlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 05:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbXIYJlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 05:41:14 -0400
Received: from anchor-post-34.mail.demon.net ([194.217.242.92]:1756 "EHLO
	anchor-post-34.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014AbXIYJlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 05:41:13 -0400
Subject: jbd : config_jbd_debug cannot create /proc entry
From: richard kennedy <richard@rsk.demon.co.uk>
To: sct@redhat.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain
Date: Tue, 25 Sep 2007 10:40:40 +0100
Message-Id: <1190713240.3154.20.camel@castor.rsk.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I enabled config_jbd_debug in the hope that it may help track down the
lockup I'm seeing, but unfortunately the /proc entry does not get
created.

any ideas how to fix this ?

My machine is an Athlon 64X2 - fedora 7 x86_64 - 2.6.23-rc7

CONFIG_EXT3_FS=m
CONFIG_JBD=m
CONFIG_JBD_DEBUG=y

I added the following patch that shows create_proc_entry is failing

Richard

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 06ab3c1..40e7ea3 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -1983,7 +1983,8 @@ static void __init create_jbd_proc_entry(void)
 		/* Why is this so hard? */
 		proc_jbd_debug->read_proc = read_jbd_debug;
 		proc_jbd_debug->write_proc = write_jbd_debug;
-	}
+	} else 
+	  printk( KERN_WARNING "jbd:cannot create proc entry : " JBD_PROC_NAME "\n");
 }
 
 static void __exit remove_jbd_proc_entry(void)


