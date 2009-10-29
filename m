Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbZJ2Wem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbZJ2Wem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 18:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbZJ2Wel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 18:34:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52757 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712AbZJ2WdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 18:33:15 -0400
Message-Id: <20091029223319.640367244@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 29 Oct 2009 18:32:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Li Hong <lihong.hi@gmail.com>
Subject: [PATCH 3/8] [PATCH 3/8] tracing: Check absolute path of input file in recordmcount.pl
References: <20091029223254.504427063@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Check-absolute-path-of-input-file-in-recordm.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Hong <lihong.hi@gmail.com>

The ftrace.c file may reference the mcount function and this may interfere
with the recordmcount.pl processing. To avoid this, the code does not
process the kernel/trace/ftrace.o. But currently the check is against
a relative path. This patch modifies the check to succeed if the path
is an absolute path.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
LKML-Reference: <20091028050332.GC30758@uhli>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index a512af1..b80e5d0 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -123,7 +123,7 @@ my ($arch, $bits, $objdump, $objcopy, $cc,
     $ld, $nm, $rm, $mv, $is_module, $inputfile) = @ARGV;
 
 # This file refers to mcount and shouldn't be ftraced, so lets' ignore it
-if ($inputfile eq "kernel/trace/ftrace.o") {
+if ($inputfile =~ m,kernel/trace/ftrace\.o$,) {
     exit(0);
 }
 
-- 
1.6.3.3


