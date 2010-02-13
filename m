Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab0BMTsz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 14:48:55 -0500
Received: from mail-yx0-f196.google.com ([209.85.210.196]:44947 "EHLO
	mail-yx0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037Ab0BMTss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 14:48:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=mfaPa9Wr2rwJSaAz9xeJoKgekP3zcu3oUQJiUptVRG7IdTJpgrr+yIwG11O0fN90Dk
         QK7hgAsIgyU8ruTRtJUJBKdacfKwsJ3tg/Zwv3KZcbk2HaaZCu5TFc7GvHZw4w2yhI9g
         dHA980LTw0RLCMCkSo5QVS5O0Iy+wcleqRSu0=
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 07/10] ftrace: pass KBUILD_CFLAGS to record_mcount.pl
Date: Sun, 14 Feb 2010 01:18:35 +0530
Message-Id: <1266090518-31120-8-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266090518-31120-1-git-send-email-rabin@rab.in>
References: <1266090518-31120-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ARM, we have two ABIs, and the ABI used is controlled via a config
option.  Object files built with one ABI can't be merged with object
files built with the other ABI.  So, record_mcount.pl needs to use the
same compiler flags as the kernel when generating the object file with
the mcount locations.  Ensure this by passing CFLAGS to the script.

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

