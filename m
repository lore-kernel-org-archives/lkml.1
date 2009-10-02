Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbZJBLhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbZJBLhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 07:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbZJBLhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 07:37:46 -0400
Received: from asmtpout022.mac.com ([17.148.16.97]:41243 "EHLO
	asmtpout022.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbZJBLhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 07:37:45 -0400
X-Greylist: delayed 3626 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Oct 2009 07:37:45 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Message-id: <060E5EC8-93F4-4AF1-889F-04A13378CB8D@me.com>
From: lenrek@me.com
To: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/char/pcmcia/synclink_cs.c: BKL pushdown?
Date: Fri, 02 Oct 2009 19:37:21 +0900
Cc: lenrek@me.com
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found the counterpart of function mgslpc_wait_until_sent
in drivers/char/synclinkmp.c (wait_until_sent) is modified to
issue (un)lock_kernel.  This patch does the same modification.

However, I'm afraid similar modifications are necessary further on  
functions
mgslpc_ioctl and mgslpc_write_room.



--- linux-2.6.31.1/drivers/char/pcmcia/synclink_cs.c	2009-10-02  
17:01:23.000000000 +0900
+++ linux/drivers/char/pcmcia/synclink_cs.c	2009-10-02  
17:23:59.000000000 +0900
@@ -2442,6 +2442,8 @@
  	if (!info )
  		return;

+	lock_kernel();
+
  	if (debug_level >= DEBUG_LEVEL_INFO)
  		printk("%s(%d):mgslpc_wait_until_sent(%s) entry\n",
  			 __FILE__,__LINE__, info->device_name );
@@ -2490,6 +2492,7 @@
  	}

  exit:
+	unlock_kernel();
  	if (debug_level >= DEBUG_LEVEL_INFO)
  		printk("%s(%d):mgslpc_wait_until_sent(%s) exit\n",
  			 __FILE__,__LINE__, info->device_name );

