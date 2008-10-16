Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbYJPU3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbYJPU3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 16:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbYJPU3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 16:29:32 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:52957 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbYJPU3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 16:29:31 -0400
Date: Thu, 16 Oct 2008 23:29:21 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Cc: neilb@suse.de, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: [2.6 patch] init/do_mounts_md.c must #include <linux/delay.h>
Message-ID: <20081016202921.GD22554@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error caused by
commit 589f800bb12c5cd6c9167bbf9bf3cb70cd8e422c
(fastboot: make the raid autodetect code wait for all devices to init):

<--  snip  -->

...
  CC      init/do_mounts_md.o
init/do_mounts_md.c: In function 'autodetect_raid':
init/do_mounts_md.c:285: error: implicit declaration of function 'msleep'
make[2]: *** [init/do_mounts_md.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
index 48b3fad..4c87ee1 100644
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -1,5 +1,6 @@
 
 #include <linux/raid/md.h>
+#include <linux/delay.h>
 
 #include "do_mounts.h"
 

