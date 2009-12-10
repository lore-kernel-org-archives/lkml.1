Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbZLJCnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbZLJCnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 21:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbZLJCnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 21:43:18 -0500
Received: from lemon.ertos.nicta.com.au ([203.143.174.143]:57663 "EHLO
	lemon.ken.nicta.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbZLJCnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 21:43:18 -0500
X-Greylist: delayed 2307 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Dec 2009 21:43:18 EST
Message-ID: <4B205745.7060704@cse.unsw.edu.au>
Date: Thu, 10 Dec 2009 13:04:53 +1100
From: Etienne Le Sueur <elesueur@cse.unsw.edu.au>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 203.143.161.65
X-SA-Exim-Mail-From: elesueur@cse.unsw.edu.au
Subject: [PATCH] drivers/char/nvram.c: Undo removal of duplicated include
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:20:11 +0000)
X-SA-Exim-Scanned: Yes (on lemon.ken.nicta.com.au)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

elesueur@bitburger:/usr/src/linux-2.6-git$ make
   CHK     include/linux/version.h
   CHK     include/linux/utsrelease.h
   SYMLINK include/asm -> include/asm-x86
   CALL    scripts/checksyscalls.sh
   CHK     include/linux/compile.h
   CC      drivers/char/consolemap_deftbl.o
   CC      drivers/char/defkeymap.o
   LD      drivers/char/built-in.o
   CC [M]  drivers/char/nvram.o
drivers/char/nvram.c: In function 'nvram_open':
drivers/char/nvram.c:332: error: implicit declaration of function 
'lock_kernel'
drivers/char/nvram.c:339: error: implicit declaration of function 
'unlock_kernel'
make[2]: *** [drivers/char/nvram.o] Error 1
make[1]: *** [drivers/char] Error 2
make: *** [drivers] Error 2

a check shows commit id: 4d8f54d9e4323baae8c8ca753db91563f4b34ddb 
removed a 'duplicated include' which I believe is erroneous.




diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index 2100a8f..3cfa0f6 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -38,6 +38,7 @@
  #define NVRAM_VERSION  "1.3"

  #include <linux/module.h>
+#include <linux/smp_lock.h>
  #include <linux/nvram.h>

  #define PC             1


Regards,
Etienne Le Sueur
www.ertos.nicta.com.au
