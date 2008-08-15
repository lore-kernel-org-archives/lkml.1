Return-Path: <linux-kernel-owner+w=401wt.eu-S1760304AbYHOPkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760304AbYHOPkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbYHOPka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:40:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40036 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbYHOPk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:40:26 -0400
Date: Fri, 15 Aug 2008 11:40:24 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] ftrace: update recordmount.pl arch changes
Message-ID: <alpine.DEB.1.10.0808151136310.2188@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I'm trying to keep all the arch changes in recordmcount.pl in one place.
I moved your code into that area, by adding the flags to the commands
that were passed in.

Does this change still work for you when compiling i386 on a x86_64 box?

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

Index: linux-tip.git/scripts/recordmcount.pl
===================================================================
--- linux-tip.git.orig/scripts/recordmcount.pl	2008-08-15 10:54:00.000000000 -0400
+++ linux-tip.git/scripts/recordmcount.pl	2008-08-15 10:59:10.000000000 -0400
@@ -108,20 +108,6 @@
 
 my ($arch, $objdump, $objcopy, $cc, $ld, $nm, $rm, $mv, $inputfile) = @ARGV;
 
-if ($arch eq "i386") {
-  $ld = "ld -m elf_i386";
-  $objdump = "objdump -M i386";
-  $objcopy = "objcopy -O elf32-i386";
-  $cc = "gcc -m32";
-}
-
-if ($arch eq "x86_64") {
-  $ld = "ld -m elf_x86_64";
-  $objdump = "objdump -M x86-64";
-  $objcopy = "objcopy -O elf64-x86-64";
-  $cc = "gcc -m64";
-}
-
 $objdump = "objdump" if ((length $objdump) == 0);
 $objcopy = "objcopy" if ((length $objcopy) == 0);
 $cc = "gcc" if ((length $cc) == 0);
@@ -146,11 +132,25 @@
     $function_regex = "<(.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount([+-]0x[0-9a-zA-Z]+)?\$";
     $type = ".quad";
+
+    # force flags for this arch
+    $ld .= " -m elf_x86_64";
+    $objdump .= " -M x86-64";
+    $objcopy .= " -O elf64-x86-64";
+    $cc .= " -m64";
+
 } elsif ($arch eq "i386") {
     $section_regex = "Disassembly of section";
     $function_regex = "<(.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
     $type = ".long";
+
+    # force flags for this arch
+    $ld .= " -m elf_i386";
+    $objdump .= " -M i386";
+    $objcopy .= " -O elf32-i386";
+    $cc .= " -m32";
+
 } else {
     die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
 }

