Return-Path: <linux-kernel-owner+w=401wt.eu-S1758414AbYEAJas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414AbYEAJas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 05:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757512AbYEAJaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 05:30:35 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59033 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757497AbYEAJae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 05:30:34 -0400
Date: Thu, 1 May 2008 11:31:07 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>
Subject: [PATCH] fix rebuild of wakeup.bin
Message-ID: <20080501093107.GA2392@uranus.ravnborg.org>
References: <20080501010516.DD2FE26FA05@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501010516.DD2FE26FA05@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel/acpi/realmode/Makefile use the 'always'
variable to say that wakeup.bin should always
be made.

In acpi/Makefile we then do not need to specify the
requested target and we avoid the message from make:

   `arch/x86/kernel/acpi/realmode/wakeup.bin' is up to date.

Add wakeup.lds to list af targets to avoid rebuilding
wakeup.bin - from Roland McGrath.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de> 
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
---
diff --git a/arch/x86/kernel/acpi/Makefile b/arch/x86/kernel/acpi/Makefile
index 7335959..fd5ca97 100644
--- a/arch/x86/kernel/acpi/Makefile
+++ b/arch/x86/kernel/acpi/Makefile
@@ -10,5 +10,5 @@ endif
 $(obj)/wakeup_rm.o:    $(obj)/realmode/wakeup.bin
 
 $(obj)/realmode/wakeup.bin: FORCE
-	$(Q)$(MAKE) $(build)=$(obj)/realmode $@
+	$(Q)$(MAKE) $(build)=$(obj)/realmode
 
diff --git a/arch/x86/kernel/acpi/realmode/Makefile b/arch/x86/kernel/acpi/realmode/Makefile
index 0929008..1c31cc0 100644
--- a/arch/x86/kernel/acpi/realmode/Makefile
+++ b/arch/x86/kernel/acpi/realmode/Makefile
@@ -6,7 +6,8 @@
 # for more details.
 #
 
-targets		:= wakeup.bin wakeup.elf
+always		:= wakeup.bin
+targets		:= wakeup.elf wakeup.lds
 
 wakeup-y	+= wakeup.o wakemain.o video-mode.o copy.o
 
@@ -48,7 +49,7 @@ LDFLAGS_wakeup.elf	:= -T
 
 CPPFLAGS_wakeup.lds += -P -C
 
-$(obj)/wakeup.elf: $(src)/wakeup.lds $(WAKEUP_OBJS) FORCE
+$(obj)/wakeup.elf: $(obj)/wakeup.lds $(WAKEUP_OBJS) FORCE
 	$(call if_changed,ld)
 
 OBJCOPYFLAGS_wakeup.bin	:= -O binary
