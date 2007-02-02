Return-Path: <linux-kernel-owner+w=401wt.eu-S1422769AbXBBKXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422769AbXBBKXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 05:23:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422748AbXBBKXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 05:23:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932666AbXBBKXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 05:23:01 -0500
Date: Fri, 2 Feb 2007 11:07:51 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@osdl.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@novell.com>, Andreas Kleen <ak@suse.de>,
       Torsten Duwe <duwe@suse.de>
Subject: [PATCH] i386, x86_64: Change Boot Protocol to longer command lines
Message-ID: <20070202100751.GA29200@strauss.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After the kernel can handle command lines with 2048 characters, the
documentation should be updated. 

I think it would be better to increase the boot protocol version, just
to make it possible that kexec and bootloaders can determine the size
of the command line.  The problem is that if we just increase the
length in kexec, it's not possible to determine if the user wants to
load an old kernel and warn him that the kernel truncates the command
line after 256 characters.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Acked-by: Torsten Duwe <duwe@suse.de>

---
 Documentation/i386/boot.txt |   11 ++++++-----
 arch/i386/boot/setup.S      |    2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

Index: b/Documentation/i386/boot.txt
===================================================================
--- a/Documentation/i386/boot.txt
+++ b/Documentation/i386/boot.txt
@@ -2,7 +2,7 @@
 		     ----------------------------
 
 		    H. Peter Anvin <hpa@zytor.com>
-			Last update 2007-01-26
+			Last update 2007-02-01
 
 On the i386 platform, the Linux kernel uses a rather complicated boot
 convention.  This has evolved partially due to historical aspects, as
@@ -243,10 +243,11 @@ relevant to the boot loader itself, see 
 below.
 
 The kernel command line is a null-terminated string currently up to
-255 characters long, plus the final null.  A string that is too long
-will be automatically truncated by the kernel, a boot loader may allow
-a longer command line to be passed to permit future kernels to extend
-this limit.
+2047 characters long, plus the final null. With protocol version
+2.05 and earlier, the maximum length was 255 characters. A string
+that is too long will be automatically truncated by the kernel, a boot
+loader may allow a longer command line to be passed to permit future
+kernels to extend this limit.
 
 If the boot protocol version is 2.02 or later, the address of the
 kernel command line is given by the header field cmd_line_ptr (see
Index: b/arch/i386/boot/setup.S
===================================================================
--- a/arch/i386/boot/setup.S
+++ b/arch/i386/boot/setup.S
@@ -81,7 +81,7 @@ start:
 # This is the setup header, and it must start at %cs:2 (old 0x9020:2)
 
 		.ascii	"HdrS"		# header signature
-		.word	0x0205		# header version number (>= 0x0105)
+		.word	0x0206		# header version number (>= 0x0105)
 					# or else old loadlin-1.5 will fail)
 realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
 start_sys_seg:	.word	SYSSEG
