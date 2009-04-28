Return-Path: <linux-kernel-owner+w=401wt.eu-S932996AbZD1REp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996AbZD1REp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932670AbZD1RBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:01:33 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54286 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932581AbZD1RBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:01:32 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       David Howells <dhowells@redhat.com>, Tim Abbott <tabbott@MIT.EDU>,
       Richard Henderson <rth@twiddle.net>
Subject: [PATCH v2 06/15] alpha: Use macros for .data.page_aligned.
Date: Tue, 28 Apr 2009 13:00:53 -0400
Message-Id: <1240938062-3264-7-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240938062-3264-6-git-send-email-tabbott@mit.edu>
References: <1240938062-3264-1-git-send-email-tabbott@mit.edu>
 <1240938062-3264-2-git-send-email-tabbott@mit.edu>
 <1240938062-3264-3-git-send-email-tabbott@mit.edu>
 <1240938062-3264-4-git-send-email-tabbott@mit.edu>
 <1240938062-3264-5-git-send-email-tabbott@mit.edu>
 <1240938062-3264-6-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.page_aligned should not need a separate output section, so as
part of this cleanup I moved into the .data output section in the
linker scripts in order to eliminate unnecessary references to the
section name.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/kernel/vmlinux.lds.S |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
index b9d6568..2f33cf9 100644
--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -97,11 +97,6 @@ SECTIONS
 		*(.data.init_thread)
 	}
 
-	. = ALIGN(PAGE_SIZE);
-	.data.page_aligned : {
-		*(.data.page_aligned)
-	}
-
 	. = ALIGN(64);
 	.data.cacheline_aligned : {
 		*(.data.cacheline_aligned)
@@ -110,6 +105,7 @@ SECTIONS
 	_data = .;
 	/* Data */
 	.data : {
+		PAGE_ALIGNED_DATA
 		DATA_DATA
 		CONSTRUCTORS
 	}
-- 
1.6.2.1

