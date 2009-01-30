Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbZA3WzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbZA3WzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 17:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbZA3Wy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 17:54:57 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:54240 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbZA3Wy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:54:57 -0500
Date: Fri, 30 Jan 2009 23:56:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] kbuild: drop check for CONFIG_ in headers_check
Message-ID: <20090130225642.GA17950@uranus.ravnborg.org>
References: <1233342254.21493.8.camel@localhost.localdomain> <20090130192627.GA32705@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090130192627.GA32705@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check for references to CONFIG_ symbols in exported headers turned
out to be too agressive with the current state of affairs.
After the work of Jaswinder to clean up all relevant cases we are down
to almost pure noise.

So lets drop the check for now - we can always add it back later
should our headers be ready for that.

Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
Hi Ingo.
Please include this in the  tip/core/header-fixes brach
as this is the natural path towards mainline.

Jaswinder - thanks for your effort chasing all these warnings!

	Sam

diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index db30fac..56f90a4 100644
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -38,7 +38,7 @@ foreach my $file (@files) {
 		&check_asm_types();
 		&check_sizetypes();
 		&check_prototypes();
-		&check_config();
+		# Dropped for now. Too much noise &check_config();
 	}
 	close FH;
 }
