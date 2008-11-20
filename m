Return-Path: <linux-kernel-owner+w=401wt.eu-S1756252AbYKTUgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbYKTUgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087AbYKTUfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:35:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54293 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbYKTUfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:35:53 -0500
Message-Id: <20081120203551.633484431@goodmis.org>
References: <20081120203415.251344054@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 20 Nov 2008 15:34:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linuxppc-dev@ozlabs.org, Paul Mundt <lethal@linux-sh.org>,
       Matt Fleming <mjf@gentoo.org>, Jim Radford <radford@galvanix.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/3] sh: dynamic ftrace support.
Content-Disposition: inline; filename=0001-sh-dynamic-ftrace-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <mjf@gentoo.org>

First cut at dynamic ftrace support.

[
  Steven Rostedt - only updated the recordmcount.pl file.
    There are updates for PowerPC that will conflict with this,
    and we need to base off of these changes.
]

Signed-off-by: Matt Fleming <mjf@gentoo.org>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 scripts/recordmcount.pl |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index eeac71c..9f75438 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -170,6 +170,17 @@ if ($arch eq "x86_64") {
     $objcopy .= " -O elf32-i386";
     $cc .= " -m32";
 
+} elsif ($arch eq "sh") {
+    $section_regex = "Disassembly of section\\s+(\\S+):";
+    $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
+    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
+    $type = ".long";
+
+    # force flags for this arch
+    $ld .= " -m shlelf_linux";
+    $objcopy .= " -O elf32-sh-linux";
+    $cc .= " -m32";
+
 } else {
     die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
 }
-- 
1.5.6.5

-- 
