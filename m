Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbXGGENl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbXGGENl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 00:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbXGGENd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 00:13:33 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53246 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750962AbXGGENd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 00:13:33 -0400
Date: Sat, 7 Jul 2007 06:14:02 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Patrick Caulfield <pcaulfie@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>, teigland@redhat.com
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [2.6.22 regression fix] DLM must depend on SYSFS
Message-ID: <20070707041402.GE3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The dependency of DLM on SYSFS got lost in
commit 6ed7257b46709e87d79ac2b6b819b7e0c9184998 resulting in the 
following compile error with CONFIG_DLM=y, CONFIG_SYSFS=n:

<--  snip  -->

...
  LD      .tmp_vmlinux1
fs/built-in.o: In function `dlm_lockspace_init':
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/fs/dlm/lockspace.c:231: undefined reference to `kernel_subsys'
fs/built-in.o: In function `configfs_init':
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/fs/configfs/mount.c:143: undefined reference to `kernel_subsys'
make[1]: *** [.tmp_vmlinux1] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/fs/dlm/Kconfig.old	2007-07-07 06:07:10.000000000 +0200
+++ linux-2.6.22-rc6-mm1/fs/dlm/Kconfig	2007-07-07 06:07:26.000000000 +0200
@@ -3,7 +3,7 @@
 
 config DLM
 	tristate "Distributed Lock Manager (DLM)"
-	depends on IPV6 || IPV6=n
+	depends on SYSFS && (IPV6 || IPV6=n)
 	select CONFIGFS_FS
 	select IP_SCTP
 	help

