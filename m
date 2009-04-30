Return-Path: <linux-kernel-owner+w=401wt.eu-S1765104AbZD3SyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765104AbZD3SyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 14:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764555AbZD3SwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 14:52:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56315 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763901AbZD3SwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 14:52:22 -0400
Message-Id: <20090430185220.625711175@goodmis.org>
References: <20090430185022.122124349@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 30 Apr 2009 14:50:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 4/7] kconfig: add check if end exists in extract-ikconfig
Content-Disposition: inline; filename=0004-kconfig-add-check-if-end-exists-in-extract-ikconfig.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Both start and end should be tested for existence before continuing
to parse the config.gz file.

[ Impact: better integrity checks in finding config.gz

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/extract-ikconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/scripts/extract-ikconfig b/scripts/extract-ikconfig
index 72997c3..42d6bce 100755
--- a/scripts/extract-ikconfig
+++ b/scripts/extract-ikconfig
@@ -17,6 +17,10 @@ dump_config() {
 	return
     fi
     end=`$binoffset $file $IKCFG_ED 2>/dev/null`
+    [ "$?" != "0" ] && end="-1"
+    if [ "$end" -eq "-1" ]; then
+	return
+    fi
 
     start=`expr $start + 8`
     size=`expr $end - $start`
-- 
1.6.2.1

-- 
