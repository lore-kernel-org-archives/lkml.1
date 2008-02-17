Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbYBQEjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbYBQEjz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 23:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756409AbYBQEjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 23:39:46 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:27298 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbYBQEjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 23:39:45 -0500
Date: Sat, 16 Feb 2008 20:38:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       pavel@suse.cz, Len Brown <lenb@kernel.org>, sam@ravnborg.org
Subject: [PATCH v2] Re: 2.6.25-rc2-mm1 (wakeup)
Message-Id: <20080216203832.dc34ce5f.randy.dunlap@oracle.com>
In-Reply-To: <47B7B0CE.7000701@zytor.com>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<20080216094844.3e5224f0.randy.dunlap@oracle.com>
	<200802170218.08770.rjw@sisk.pl>
	<47B78C6C.6040905@zytor.com>
	<20080216181918.3f2a1665.randy.dunlap@oracle.com>
	<47B7B0CE.7000701@zytor.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 19:58:06 -0800 H. Peter Anvin wrote:

> Randy Dunlap wrote:
> > 
> > Yes, adding -m32 to the X86_32 config ccflags (as is done for the
> > X86_64 case) makes it build for me.  (like patch below)
> > 
> 
> It's wrong, though, because you can't assume a 32-bit compiler knows 
> about -m32.
> 
> You need $(call cc-option,-m32).

Thanks, Peter.  Tested/works.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix wakeup code build errors on x86_64.

linux-2.6.25-rc2-mm1/arch/x86/kernel/acpi/realmode/wakeup.S:0: error: CPU you selected does not support x86-64 instruction set
linux-2.6.25-rc2-mm1/arch/x86/kernel/acpi/realmode/wakeup.S:0: error: CPU you selected does not support x86-64 instruction set
linux-2.6.25-rc2-mm1/arch/x86/kernel/acpi/realmode/wakeup.S:0: error: -mpreferred-stack-boundary=2 is not between 4 and 12

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/kernel/acpi/realmode/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.25-rc2-mm1.orig/arch/x86/kernel/acpi/realmode/Makefile
+++ linux-2.6.25-rc2-mm1/arch/x86/kernel/acpi/realmode/Makefile
@@ -27,7 +27,7 @@ bootsrc		:= $(src)/../../../boot
 # How to compile the 16-bit code.  Note we always compile for -march=i386,
 # that way we can complain to the user if the CPU is insufficient.
 # Compile with _SETUP since this is similar to the boot-time setup code.
-cflags-$(CONFIG_X86_32) :=
+cflags-$(CONFIG_X86_32) := $(call cc-option, -m32)
 cflags-$(CONFIG_X86_64) := -m32
 KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os -D_SETUP -D_WAKEUP -D__KERNEL__ \
 		   -I$(srctree)/$(bootsrc) \
