Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413Ab0ANCep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab0ANCep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582Ab0ANCen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:34:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60636 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab0ANCem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:34:42 -0500
X-Authority-Analysis: v=1.0 c=1 a=xXaQYpEdrzQA:10 a=7U3hwN5JcxgA:10 a=VwQbUJbxAAAA:8 a=a_U1oVfrAAAA:8 a=meVymXHHAAAA:8 a=6NxIIjQzh5j0TfXeUAgA:9 a=8Y2JkftJsh96DVxEa59ONvuMxzMA:4 a=k4qQewaewV0A:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH][GIT PULL][v2.6.33] tracing/x86: Derive arch from bits
 argument in recordmcount.pl
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Kiszka <jan.kiszka@siemens.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 13 Jan 2010 21:34:39 -0500
Message-ID: <1263436479.28171.3832.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Jan Kiszka (1):
      tracing/x86: Derive arch from bits argument in recordmcount.pl

----
 scripts/recordmcount.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
---------------------------
commit b82a4045f7962483a78a874343dc6e31b79c96c1
Author: Jan Kiszka <jan.kiszka@siemens.com>
Date:   Mon Jan 11 11:31:44 2010 +0100

    tracing/x86: Derive arch from bits argument in recordmcount.pl
    
    Let the arch argument be overruled by bits. Otherwise, building of
    external modules against a i386 target on a x86-64 host (and likely vice
    versa as well) fails unless ARCH=i386 is explicitly passed to make.
    
    Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
    LKML-Reference: <4B4AFE10.8050109@siemens.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 92f09fe..ea6f6e3 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -194,7 +194,7 @@ sub check_objcopy
     }
 }
 
-if ($arch eq "x86") {
+if ($arch =~ /(x86(_64)?)|(i386)/) {
     if ($bits == 64) {
 	$arch = "x86_64";
     } else {


