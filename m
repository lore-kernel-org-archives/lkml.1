Return-Path: <linux-kernel-owner+w=401wt.eu-S1752111AbZHSDAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbZHSDAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 23:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbZHSDAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 23:00:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34909 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbZHSDAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 23:00:41 -0400
Message-Id: <20090819030037.884039050@goodmis.org>
References: <20090819025634.987354707@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 18 Aug 2009 22:56:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       Greg KH <greg@kroah.com>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jonathan Corbet <corbet@lwn.net>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 07/14] kconfig: add check if end exists in extract-ikconfig
Content-Disposition: inline; filename=0007-kconfig-add-check-if-end-exists-in-extract-ikconfig.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Both start and end should be tested for existence before continuing
to parse the config.gz file.

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
1.6.3.3

-- 
