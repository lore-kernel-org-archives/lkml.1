Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab0AOD7e (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 22:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755273Ab0AOD64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 22:58:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59952 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab0AOD6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 22:58:54 -0500
X-Authority-Analysis: v=1.0 c=1 a=ELsDqZKwKxMA:10 a=a_U1oVfrAAAA:8 a=meVymXHHAAAA:8 a=Wmjm2CIoZYx4uKuZ5hgA:9 a=DGvPhgYPRc1Q_z_Ka4-gsJC0_YAA:4 a=k4qQewaewV0A:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100115035852.217957247@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jan 2010 22:57:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 1/8] tracing/x86: Derive arch from bits argument in recordmcount.pl
References: <20100115035726.462940848@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-x86-Derive-arch-from-bits-argument-in-record.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Let the arch argument be overruled by bits. Otherwise, building of
external modules against a i386 target on a x86-64 host (and likely vice
versa as well) fails unless ARCH=i386 is explicitly passed to make.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
LKML-Reference: <4B4AFE10.8050109@siemens.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
-- 
1.6.5


