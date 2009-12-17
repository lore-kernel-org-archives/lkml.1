Return-Path: <linux-kernel-owner+w=401wt.eu-S936667AbZLQElH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936667AbZLQElH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:41:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935752AbZLQEkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:40:43 -0500
Received: from kroah.org ([198.145.64.141]:55396 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763942AbZLQEEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:00 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:47 2009
Message-Id: <20091217035647.478189845@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [035/151] x86: Use -maccumulate-outgoing-args for sane mcount prologues
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit b8b7d791a8ff01d2380089279a69afa99115fb23 upstream.

commit 746357d (x86: Prevent GCC 4.4.x (pentium-mmx et al) function
prologue wreckage) uses -mtune=generic to work around the function
prologue problem with mcount on -march=pentium-mmx and others.

Jakub pointed out that we can use -maccumulate-outgoing-args instead
which is selected by -mtune=generic and prevents the problem without
losing the -march specific optimizations.

Pointed-out-by: Jakub Jelinek <jakub@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/Makefile_32.cpu |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/Makefile_32.cpu
+++ b/arch/x86/Makefile_32.cpu
@@ -49,8 +49,9 @@ cflags-$(CONFIG_X86_GENERIC) 	+= $(call 
 # Work around the pentium-mmx code generator madness of gcc4.4.x which
 # does stack alignment by generating horrible code _before_ the mcount
 # prologue (push %ebp, mov %esp, %ebp) which breaks the function graph
-# tracer assumptions
-cflags-$(CONFIG_FUNCTION_GRAPH_TRACER) += $(call cc-option,-mtune=generic)
+# tracer assumptions. For i686, generic, core2 this is set by the
+# compiler anyway
+cflags-$(CONFIG_FUNCTION_GRAPH_TRACER) += $(call cc-option,-maccumulate-outgoing-args)
 
 # Bug fix for binutils: this option is required in order to keep
 # binutils from generating NOPL instructions against our will.


