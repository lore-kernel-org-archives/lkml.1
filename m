Return-Path: <linux-kernel-owner+w=401wt.eu-S1765463AbZEAAEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765463AbZEAAEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761419AbZD3X71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:59:27 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61111 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763955AbZD3X70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:59:26 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, David Howells <dhowells@redhat.com>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 6/6] mn10300: use new macro for .data.read_mostly section.
Date: Thu, 30 Apr 2009 19:54:21 -0400
Message-Id: <1241135661-9147-7-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135661-9147-6-git-send-email-tabbott@mit.edu>
References: <1241135661-9147-1-git-send-email-tabbott@mit.edu>
 <1241135661-9147-2-git-send-email-tabbott@mit.edu>
 <1241135661-9147-3-git-send-email-tabbott@mit.edu>
 <1241135661-9147-4-git-send-email-tabbott@mit.edu>
 <1241135661-9147-5-git-send-email-tabbott@mit.edu>
 <1241135661-9147-6-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.read_mostly should not need a separate output section; this
change moves it into the .data section.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: David Howells <dhowells@redhat.com>
---
 arch/mn10300/kernel/vmlinux.lds.S |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/mn10300/kernel/vmlinux.lds.S b/arch/mn10300/kernel/vmlinux.lds.S
index 4dc63e6..3da48d5 100644
--- a/arch/mn10300/kernel/vmlinux.lds.S
+++ b/arch/mn10300/kernel/vmlinux.lds.S
@@ -52,16 +52,11 @@ SECTIONS
 	INIT_TASK_DATA(THREAD_SIZE)
 	NOSAVE_DATA
 	CACHELINE_ALIGNED_DATA(32)
+	READ_MOSTLY_DATA(32)
 	DATA_DATA
 	CONSTRUCTORS
-	}
-
-  /* rarely changed data like cpu maps */
-  . = ALIGN(32);
-  .data.read_mostly : AT(ADDR(.data.read_mostly)) {
-	*(.data.read_mostly)
 	_edata = .;		/* End of data section */
-  }
+	}
 
   /* might get freed after init */
   . = ALIGN(PAGE_SIZE);
-- 
1.6.2.1

