Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbZDZCMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbZDZCMq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 22:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbZDZCL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 22:11:59 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:53572 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755508AbZDZCL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 22:11:58 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, "Theodore Ts'o" <tytso@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       =?utf-8?q?Am=C3=A9rico=20Wang?= <xiyou.wangcong@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       David Howells <dhowells@redhat.com>, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 15/15] modpost: convert modpost to use HEAD_TEXT_SECTION macro.
Date: Sat, 25 Apr 2009 22:11:10 -0400
Message-Id: <1240711870-30505-15-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240711870-30505-14-git-send-email-tabbott@mit.edu>
References: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu>
 <1240711870-30505-1-git-send-email-tabbott@mit.edu>
 <1240711870-30505-2-git-send-email-tabbott@mit.edu>
 <1240711870-30505-3-git-send-email-tabbott@mit.edu>
 <1240711870-30505-4-git-send-email-tabbott@mit.edu>
 <1240711870-30505-5-git-send-email-tabbott@mit.edu>
 <1240711870-30505-6-git-send-email-tabbott@mit.edu>
 <1240711870-30505-7-git-send-email-tabbott@mit.edu>
 <1240711870-30505-8-git-send-email-tabbott@mit.edu>
 <1240711870-30505-9-git-send-email-tabbott@mit.edu>
 <1240711870-30505-10-git-send-email-tabbott@mit.edu>
 <1240711870-30505-11-git-send-email-tabbott@mit.edu>
 <1240711870-30505-12-git-send-email-tabbott@mit.edu>
 <1240711870-30505-13-git-send-email-tabbott@mit.edu>
 <1240711870-30505-14-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the HEAD_TEXT_SECTION macro in modpost requires including a few
more files from the linux headers.

The entry in head_sections[] ".head.text*" should be ".head.text",
since only that section name is actually used by any architectures.  I
corrected this since preserving this over-broad pattern would have
involved some string concatination nastiness.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 scripts/mod/modpost.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index df6e628..f93645f 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -16,6 +16,8 @@
 #include <ctype.h>
 #include "modpost.h"
 #include "../../include/linux/license.h"
+#include "../../include/linux/section-names.h"
+#include "../../include/linux/stringify.h"
 
 /* Are we using CONFIG_MODVERSIONS? */
 int modversions = 0;
@@ -818,7 +820,7 @@ static const char *symbol_white_list[] =
 	NULL
 };
 
-static const char *head_sections[] = { ".head.text*", NULL };
+static const char *head_sections[] = { __stringify(HEAD_TEXT_SECTION), NULL };
 static const char *linker_symbols[] =
 	{ "__init_begin", "_sinittext", "_einittext", NULL };
 
@@ -942,8 +944,8 @@ static int section_mismatch(const char *fromsec, const char *tosec)
  *           *probe_one, *_console, *_timer
  *
  * Pattern 3:
- *   Whitelist all refereces from .text.head to .init.data
- *   Whitelist all refereces from .text.head to .init.text
+ *   Whitelist all refereces from HEAD_TEXT_SECTION to .init.data
+ *   Whitelist all refereces from HEAD_TEXT_SECTION to .init.text
  *
  * Pattern 4:
  *   Some symbols belong to init section but still it is ok to reference
-- 
1.6.2.1

