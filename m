Return-Path: <linux-kernel-owner+w=401wt.eu-S1752164AbZHSDAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbZHSDAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 23:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbZHSDAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 23:00:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56670 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbZHSDAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 23:00:45 -0400
Message-Id: <20090819030038.462300834@goodmis.org>
References: <20090819025634.987354707@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 18 Aug 2009 22:56:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       Greg KH <greg@kroah.com>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jonathan Corbet <corbet@lwn.net>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 09/14] kconfig: keep config.gz around even if CONFIG_IKCONFIG_PROC is not set
Content-Disposition: inline; filename=0009-kconfig-keep-config.gz-around-even-if-CONFIG_IKCONFI.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If CONFIG_IKCONFIG is set but CONFIG_IKCONFIG_PROC is not, then
gcc will optimize the config.gz out, because nobody uses it.

This patch adds "__used" to the config.gz data to keep it around so that
code like extract-ikconfig can still find it.

[ Impact: allow extract-ikconfig to find config.gz ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 2093a69..d0c84e6 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -119,7 +119,7 @@ $(obj)/config_data.gz: .config FORCE
 	$(call if_changed,gzip)
 
 quiet_cmd_ikconfiggz = IKCFG   $@
-      cmd_ikconfiggz = (echo "static const char kernel_config_data[] = MAGIC_START"; cat $< | scripts/bin2c; echo "MAGIC_END;") > $@
+      cmd_ikconfiggz = (echo "static const char kernel_config_data[] __used = MAGIC_START"; cat $< | scripts/bin2c; echo "MAGIC_END;") > $@
 targets += config_data.h
 $(obj)/config_data.h: $(obj)/config_data.gz FORCE
 	$(call if_changed,ikconfiggz)
-- 
1.6.3.3

-- 
