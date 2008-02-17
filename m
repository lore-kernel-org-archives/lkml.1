Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbYBQCUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbYBQCUu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 21:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbYBQCUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 21:20:41 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:32788 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbYBQCUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 21:20:40 -0500
Date: Sat, 16 Feb 2008 18:19:18 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       pavel@suse.cz, Len Brown <lenb@kernel.org>, sam@ravnborg.org
Subject: Re: 2.6.25-rc2-mm1 (wakeup)
Message-Id: <20080216181918.3f2a1665.randy.dunlap@oracle.com>
In-Reply-To: <47B78C6C.6040905@zytor.com>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<20080216094844.3e5224f0.randy.dunlap@oracle.com>
	<200802170218.08770.rjw@sisk.pl>
	<47B78C6C.6040905@zytor.com>
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

On Sat, 16 Feb 2008 17:22:52 -0800 H. Peter Anvin wrote:

> Rafael J. Wysocki wrote:
> > On Saturday, 16 of February 2008, Randy Dunlap wrote:
> >> On Sat, 16 Feb 2008 00:25:22 -0800 Andrew Morton wrote:
> >>
> >>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/
> >> The ACPI wakeup in C patch (I think) won't build for me on x86_32
> >> (i.e., i386 build on x86_64 system):
> >>
> >> linux-2.6.25-rc2-mm1/arch/x86/kernel/acpi/realmode/wakeup.S:0: error: CPU you selected does not support x86-64 instruction set
> >> linux-2.6.25-rc2-mm1/arch/x86/kernel/acpi/realmode/wakeup.S:0: error: CPU you selected does not support x86-64 instruction set
> >> linux-2.6.25-rc2-mm1/arch/x86/kernel/acpi/realmode/wakeup.S:0: error: -mpreferred-stack-boundary=2 is not between 4 and 12
> >> make[4]: *** [arch/x86/kernel/acpi/realmode/wakeup.o] Error 1
> >> make[3]: *** [arch/x86/kernel/acpi/realmode/wakeup.bin] Error 2
> > 
> > It compiles for me on a native i386.
> > 
> > Can you please give me a hint what to do to reproduce the problem?
> 
> Sounds like you're not adding -m32 to the gcc command line.

Yes, adding -m32 to the X86_32 config ccflags (as is done for the
X86_64 case) makes it build for me.  (like patch below)

Thanks.
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
+cflags-$(CONFIG_X86_32) := -m32
 cflags-$(CONFIG_X86_64) := -m32
 KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os -D_SETUP -D_WAKEUP -D__KERNEL__ \
 		   -I$(srctree)/$(bootsrc) \
