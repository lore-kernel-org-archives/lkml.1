Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015Ab0AaRdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab0AaRdN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 12:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673Ab0AaRdM
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 12:33:12 -0500
Received: from mail-pz0-f172.google.com ([209.85.222.172]:54147 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab0AaRdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 12:33:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=I2KdFCZmmxeKlC3Wy2e9VJJJE4YDuuDEEQfzXQqweWHwtvGwy6crzzwQ5tpOEjCe5u
         DNeK+hleQqg9fI2f6UPoMwcYL9CEpohjBvHU3QA2BAJNLRdBYGAWg1IOY8rXDNrdci82
         D3r889uyxXhVODYi7HqGooWHvOiaRTcHNKD50=
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 1/2] ftrace: pass KBUILD_CFLAGS along with CC to record_mcount.pl
Date: Sun, 31 Jan 2010 23:03:15 +0530
Message-Id: <1264959196-5175-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ARM we have two ABIs, and the ABI used is controlled via a config
option.  Object files built with one ABI can't be merged with object
files built with the other ABI.  So, record_mcount.pl needs to use the
same compiler flags as the kernel when generating the object file with
the mcount locations.  Ensure this by passing CFLAGS to the script.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 scripts/Makefile.build |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 0b94d2f..2535c11 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -209,7 +209,8 @@ ifdef CONFIG_FTRACE_MCOUNT_RECORD
 cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
 	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
 	"$(if $(CONFIG_64BIT),64,32)" \
-	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
+	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
+	"$(LD)" "$(NM)" "$(RM)" "$(MV)" \
 	"$(if $(part-of-module),1,0)" "$(@)";
 endif
 
-- 
1.6.6

