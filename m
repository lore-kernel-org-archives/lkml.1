Return-Path: <linux-kernel-owner+w=401wt.eu-S1765514AbZD3SzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765514AbZD3SzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 14:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764638AbZD3Sw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 14:52:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37545 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764560AbZD3SwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 14:52:25 -0400
Message-Id: <20090430185222.696995168@goodmis.org>
References: <20090430185022.122124349@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 30 Apr 2009 14:50:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 6/7] kconfig: keep config.gz around even if CONFIG_IKCONFIG_PROC is not set
Content-Disposition: inline; filename=0006-kconfig-keep-config.gz-around-even-if-CONFIG_IKCONF.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If CONFIG_IKCONFIG is set but CONFIG_IKCONFIG_PROC is not, then
gcc will optibize the config.gz out, because nobody uses it.

This patch adds "__used" to the config.gz data to keep it around so that
code like extract-ikconfig can still find it.

[ Impact: allow extract-ikconfig to find config.gz ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 4242366..f10c7c7 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -114,7 +114,7 @@ $(obj)/config_data.gz: .config FORCE
 	$(call if_changed,gzip)
 
 quiet_cmd_ikconfiggz = IKCFG   $@
-      cmd_ikconfiggz = (echo "static const char kernel_config_data[] = MAGIC_START"; cat $< | scripts/bin2c; echo "MAGIC_END;") > $@
+      cmd_ikconfiggz = (echo "static const char kernel_config_data[] __used = MAGIC_START"; cat $< | scripts/bin2c; echo "MAGIC_END;") > $@
 targets += config_data.h
 $(obj)/config_data.h: $(obj)/config_data.gz FORCE
 	$(call if_changed,ikconfiggz)
-- 
1.6.2.1

-- 
