Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000Ab0AKK6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab0AKK6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 05:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132Ab0AKK6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 05:58:23 -0500
Received: from thoth.sbs.de ([192.35.17.2]:19689 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab0AKK6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 05:58:22 -0500
X-Greylist: delayed 1574 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jan 2010 05:58:22 EST
Message-ID: <4B4AFE10.8050109@siemens.com>
Date: Mon, 11 Jan 2010 11:31:44 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] recordmcount.pl: x86: Derive arch from bits argument
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the arch argument be overruled by bits. Otherwise, building of
external modules against a i386 target on a x86-64 host (and likely vice
versa as well) fails unless ARCH=i386 is explicitly passed to make.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
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
1.6.0.2
