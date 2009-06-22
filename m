Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbZFVIEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbZFVIEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 04:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZFVIEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 04:04:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36432 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbZFVIEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 04:04:22 -0400
Date: Mon, 22 Jun 2009 18:04:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Simmons <jsimmons@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH] fbdev: work around old compiler bug
Message-Id: <20090622180420.2e0424e4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building with a 4.1.x compiler on powerpc64 (at least) we get
this error:

drivers/video/logo/logo_linux_mono.c:81: error: logo_linux_mono causes a section type conflict

This was introduced by commit ae52bb2384f721562f15f719de1acb8e934733cb
("fbdev: move logo externs to header file").  This is a partial revert
of that commit sufficient to not hit the compiler bug.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 scripts/pnmtologo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/pnmtologo.c b/scripts/pnmtologo.c
index 64f5ddb..d10c389 100644
--- a/scripts/pnmtologo.c
+++ b/scripts/pnmtologo.c
@@ -237,7 +237,7 @@ static void write_header(void)
     fprintf(out, " *  Linux logo %s\n", logoname);
     fputs(" */\n\n", out);
     fputs("#include <linux/linux_logo.h>\n\n", out);
-    fprintf(out, "static const unsigned char %s_data[] __initconst = {\n",
+    fprintf(out, "static unsigned char %s_data[] __initdata = {\n",
 	    logoname);
 }
 
-- 
1.6.3.1


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
