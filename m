Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbYKUUbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbYKUUbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 15:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbYKUUbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 15:31:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62601 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbYKUUbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 15:31:03 -0500
Message-Id: <20081121203100.253451754@goodmis.org>
References: <20081121202932.281682721@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Nov 2008 15:29:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Matt Fleming <mjf@gentoo.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Sam Ravnborg <sam@ravnborg.org>, Jim Radford <radford@galvanix.net>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/5] ftrace: Specify $alignment for sh architecture
Content-Disposition: inline; filename=0001-ftrace-Specify-alignment-for-sh-architecture.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <mjf@gentoo.org>

Set $alignment=2 for the sh architecture so that a ".align 2" directive
will be emitted for all __mcount_loc sections. Fix a whitspace error
while I'm here (converted spaces to tabs).

Signed-off-by: Matt Fleming <mjf@gentoo.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 scripts/recordmcount.pl |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index c5c58ac..03b6af1 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -135,7 +135,7 @@ my $section_regex;	# Find the start of a section
 my $function_regex;	# Find the name of a function
 			#    (return offset and func name)
 my $mcount_regex;	# Find the call site to mcount (return offset)
-my $alignment;         # The .align value to use for $mcount_section
+my $alignment;		# The .align value to use for $mcount_section
 
 if ($arch eq "x86") {
     if ($bits == 64) {
@@ -176,6 +176,7 @@ if ($arch eq "x86_64") {
     $cc .= " -m32";
 
 } elsif ($arch eq "sh") {
+    $alignment = 2;
 
     # force flags for this arch
     $ld .= " -m shlelf_linux";
-- 
1.5.6.5

-- 
