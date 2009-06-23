Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbZFWQFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbZFWQFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756219AbZFWQFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:05:36 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:45501 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbZFWQFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:05:35 -0400
Date: Wed, 24 Jun 2009 01:04:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] asm-generic/vmlinux.lds.h: Fix up RW_DATA_SECTION definition.
Message-ID: <20090623160435.GC26674@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RW_DATA_SECTION is defined to take 4 different alignment parameters,
while NOSAVE_DATA currently uses a fixed PAGE_SIZE alignment as noted
in the comments.

There are presently no in-tree users of this at present, and I just
stumbled across this while implementing the simplified script on a new
architecture port, which subsequently resulted in a syntax error.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 include/asm-generic/vmlinux.lds.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 92b73b6..f92e730 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -704,7 +704,7 @@
  * matches the requirment of PAGE_ALIGNED_DATA.
  *
  * use 0 as page_align if page_aligned data is not used */
-#define RW_DATA_SECTION(cacheline, nosave, pagealigned, inittask)	\
+#define RW_DATA_SECTION(cacheline, pagealigned, inittask)		\
 	. = ALIGN(PAGE_SIZE);						\
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {				\
 		INIT_TASK(inittask)					\
@@ -712,7 +712,7 @@
 		READ_MOSTLY_DATA(cacheline)				\
 		DATA_DATA						\
 		CONSTRUCTORS						\
-		NOSAVE_DATA(nosave)					\
+		NOSAVE_DATA						\
 		PAGE_ALIGNED_DATA(pagealigned)				\
 	}
 
