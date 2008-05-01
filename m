Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbYEABFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbYEABFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 21:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbYEABF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 21:05:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbYEABF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 21:05:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
X-Fcc: ~/Mail/linus
Cc: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: arch/x86/kernel/acpi/realmode/Makefile
X-Windows: even not doing anything would have been better than nothing.
Message-Id: <20080501010516.DD2FE26FA05@magilla.localdomain>
Date: Wed, 30 Apr 2008 18:05:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that arch/x86/kernel/acpi/realmode/wakeup.lds was being remade on
every make.  A run with V=2 nicely told me why.  I did what it told me:

--- a/arch/x86/kernel/acpi/realmode/Makefile
+++ b/arch/x86/kernel/acpi/realmode/Makefile
@@ -6,7 +6,7 @@
 # for more details.
 #
 
-targets		:= wakeup.bin wakeup.elf
+targets		:= wakeup.bin wakeup.elf wakeup.lds
 
 wakeup-y	+= wakeup.o wakemain.o video-mode.o copy.o
 

That made it no longer rebuild that stuff every time.
But now it says:

make[5]: `arch/x86/kernel/acpi/realmode/wakeup.bin' is up to date.
  LD      vmlinux.o - due to: init/built-in.o

and still relinks the kernel on every make run.  

Can you figure it out, please?  "make; make" should not relink.


Thanks,
Roland
