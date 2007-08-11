Return-Path: <linux-kernel-owner+w=401wt.eu-S1760386AbXHKRyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760386AbXHKRyO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 13:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbXHKRyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 13:54:00 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:53172 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbXHKRx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 13:53:59 -0400
Date: Sat, 11 Aug 2007 13:53:56 -0400
Message-Id: <200708111753.l7BHruNV009717@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk
Subject: [PATCH] 2.6.23-rc2 error compiling fs/drop_caches.c (struct super_block errors)
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting a lot of warnings about struct super_block in 2.6.23-rc2.  Then,
a compile error when compiling fs/drop_caches.o:

  CC      fs/drop_caches.o
In file included from fs/drop_caches.c:7:
include/linux/mm.h:1210: warning: 'struct super_block' declared inside parameter list
include/linux/mm.h:1210: warning: its scope is only this definition or declaration, which is probably not what you want
fs/drop_caches.c:17: error: conflicting types for 'drop_pagecache_sb'
include/linux/mm.h:1210: error: previous declaration of 'drop_pagecache_sb' was here
fs/drop_caches.c:28: error: conflicting types for 'drop_pagecache_sb'
include/linux/mm.h:1210: error: previous declaration of 'drop_pagecache_sb' was here
make[1]: *** [fs/drop_caches.o] Error 1
make: *** [fs] Error 2

I'm using Linus's tree, which is 2.6.23-rc2 plus all patches up to this
commit:

  commit ac07860264bd2b18834d3fa3be47032115524cea
  Author: Jesper Juhl <jesper.juhl@gmail.com>
  Date:   Wed Aug 8 16:31:30 2007 -0700

I didn't check if this is fixed already in the latest -mm.  The following
small fix seems to get rid of all warnings and compile errors I've seen:


diff --git a/include/linux/mm.h b/include/linux/mm.h
index 324c151..ed90191 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -20,6 +20,7 @@ struct anon_vma;
 struct file_ra_state;
 struct user_struct;
 struct writeback_control;
+struct super_block;
 
 #ifndef CONFIG_DISCONTIGMEM          /* Don't use mapnrs, do it properly */
 extern unsigned long max_mapnr;


Cheers,
Erez.
