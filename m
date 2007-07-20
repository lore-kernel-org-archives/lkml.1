Return-Path: <linux-kernel-owner+w=401wt.eu-S936577AbXGTQwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936577AbXGTQwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934657AbXGTQqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:46:21 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:43542 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429AbXGTQqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:46:18 -0400
Date: Fri, 20 Jul 2007 09:29:50 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix Lindent to not indent preprocessor comments so far
Message-ID: <20070720152950.GB14791@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I recently ran Lindent over the AdvanSys driver and it moved the
comments on #else and #endif lines way over to the right:

#else                          /* ADVANSYS_DEBUG */

This doesn't match what I expect from kernel style, but it is
documented.  We just need another flag to indent to make this look like:

#else /* ADVANSYS_DEBUG */

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/scripts/Lindent b/scripts/Lindent
index 7d8d889..9468ec7 100755
--- a/scripts/Lindent
+++ b/scripts/Lindent
@@ -1,2 +1,2 @@
 #!/bin/sh
-indent -npro -kr -i8 -ts8 -sob -l80 -ss -ncs "$@"
+indent -npro -kr -i8 -ts8 -sob -l80 -ss -ncs -cp1 "$@"

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
