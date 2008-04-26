Return-Path: <linux-kernel-owner+w=401wt.eu-S1763393AbYDZCdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763393AbYDZCdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 22:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759544AbYDZCcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 22:32:36 -0400
Received: from mail.queued.net ([207.210.101.209]:2253 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759490AbYDZCc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 22:32:28 -0400
Date: Fri, 25 Apr 2008 22:35:27 -0400
From: Andres Salomon <dilinger@queued.net>
To: sam@ravnborg.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: [PATCH 3/4] kconfig: conf -D just takes default config w/out
 assuming input_mode is set_default
Message-ID: <20080425223527.494da196@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Previously, both -d and -D specified that input_mode was set_default; the
only difference was that -D took an argument (setting defconfig_file).

With this change, -d specifies set_default, and -D merely sets defconfig_file.
This means that (for example) 'make i386_defconfig' becomes
'conf -d -D $def $(Kconfig)'.  The goal here is to enable future targets to
specify a default conf file without being forced to set input_mode to
set_default.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 scripts/kconfig/Makefile |    4 ++--
 scripts/kconfig/conf.c   |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 7df7ea6..ce7d754 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -66,11 +66,11 @@ ifeq ($(KBUILD_DEFCONFIG),)
 	$< -d $(Kconfig)
 else
 	@echo "*** Default configuration is based on '$(KBUILD_DEFCONFIG)'"
-	$(Q)$< -D arch/$(SRCARCH)/configs/$(KBUILD_DEFCONFIG) $(Kconfig)
+	$(Q)$< -d -D arch/$(SRCARCH)/configs/$(KBUILD_DEFCONFIG) $(Kconfig)
 endif
 
 %_defconfig: $(obj)/conf
-	$(Q)$< -D arch/$(SRCARCH)/configs/$@ $(Kconfig)
+	$(Q)$< -d -D arch/$(SRCARCH)/configs/$@ $(Kconfig)
 
 # Help text used by make help
 help:
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index e17767e..9a27638 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -515,7 +515,6 @@ int main(int ac, char **av)
 			input_mode = set_default;
 			break;
 		case 'D':
-			input_mode = set_default;
 			defconfig_file = optarg;
 			break;
 		case 'n':
-- 
1.5.5

