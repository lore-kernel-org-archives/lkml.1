Return-Path: <linux-kernel-owner+w=401wt.eu-S1761665AbXJRTzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761665AbXJRTzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 15:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbXJRTzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 15:55:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbXJRTzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 15:55:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Doug Chapman <dchapman@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: [PATCH] ia64: check-segrel.lds vs --build-id
X-Fcc: ~/Mail/linus
Emacs: if it payed rent for disk space, you'd be rich.
Message-Id: <20071018195453.A34D64D04E2@magilla.localdomain>
Date: Thu, 18 Oct 2007 12:54:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some versions of ld with --build-id support will crash when using the flag
with a linker script that discards notes.  This bites ia64's check-segrel.lds.
The bug is easy to avoid.

Signed-off-by: Roland McGrath <roland@redhat.com>

--- a/arch/ia64/scripts/check-segrel.lds
+++ b/arch/ia64/scripts/check-segrel.lds
@@ -1,6 +1,7 @@
 SECTIONS {
 	. = SIZEOF_HEADERS;
 	.rodata : { *(.rodata) } :ro
+	.note : { *(.note*) }
 	. = 0xa0000;
 	.data : { *(.data) } :dat
 	/DISCARD/ : { *(*) }

