Return-Path: <linux-kernel-owner+w=401wt.eu-S1763295AbYFNA12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763295AbYFNA12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762294AbYFNAPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:15:32 -0400
Received: from mx1.suse.de ([195.135.220.2]:34641 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761325AbYFNAPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:15:30 -0400
Date: Fri, 13 Jun 2008 17:12:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 44/47] Kconfig: introduce ARCH_DEFCONFIG to DEFCONFIG_LIST
Message-ID: <20080614001216.GR24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kconfig-introduce-arch_defconfig-to-defconfig_list.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Sam Ravnborg <sam@ravnborg.org>

commit 73531905ed53576d9e8707659a761e7046a60497 in mainline.

init/Kconfig contains a list of configs that are searched
for if 'make *config' are used with no .config present.
Extend this list to look at the config identified by
ARCH_DEFCONFIG.

With this change we now try the defconfig targets last.

This fixes a regression reported
by: Linus Torvalds <torvalds@linux-foundation.org>

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/Kconfig |   13 +++----------
 init/Kconfig     |    1 +
 2 files changed, 4 insertions(+), 10 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -24,17 +24,10 @@ config X86
 	select HAVE_KRETPROBES
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 
-config DEFCONFIG_LIST
+config ARCH_DEFCONFIG
 	string
-	depends on X86_32
-	option defconfig_list
-	default "arch/x86/configs/i386_defconfig"
-
-config DEFCONFIG_LIST
-	string
-	depends on X86_64
-	option defconfig_list
-	default "arch/x86/configs/x86_64_defconfig"
+	default "arch/x86/configs/i386_defconfig" if X86_32
+	default "arch/x86/configs/x86_64_defconfig" if X86_64
 
 
 config GENERIC_LOCKBREAK
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -13,6 +13,7 @@ config DEFCONFIG_LIST
 	default "/lib/modules/$UNAME_RELEASE/.config"
 	default "/etc/kernel-config"
 	default "/boot/config-$UNAME_RELEASE"
+	default "$ARCH_DEFCONFIG"
 	default "arch/$ARCH/defconfig"
 
 menu "General setup"

-- 
