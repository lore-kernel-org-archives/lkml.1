Return-Path: <linux-kernel-owner+w=401wt.eu-S1764580AbZD3X67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764580AbZD3X67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764576AbZD3Xym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:54:42 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60626 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764615AbZD3Xyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:54:40 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, David Howells <dhowells@redhat.com>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 3/6] mn10300: use NOSAVE_DATA macro for .data.nosave section.
Date: Thu, 30 Apr 2009 19:54:18 -0400
Message-Id: <1241135661-9147-4-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135661-9147-3-git-send-email-tabbott@mit.edu>
References: <1241135661-9147-1-git-send-email-tabbott@mit.edu>
 <1241135661-9147-2-git-send-email-tabbott@mit.edu>
 <1241135661-9147-3-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.nosave should not need a separate output section; this change
moves it into the .data output section.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: David Howells <dhowells@redhat.com>
---
 arch/mn10300/kernel/vmlinux.lds.S |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/mn10300/kernel/vmlinux.lds.S b/arch/mn10300/kernel/vmlinux.lds.S
index 364250f..5e825e8 100644
--- a/arch/mn10300/kernel/vmlinux.lds.S
+++ b/arch/mn10300/kernel/vmlinux.lds.S
@@ -49,16 +49,11 @@ SECTIONS
 
   /* writeable */
   .data : {			/* Data */
+	NOSAVE_DATA
 	DATA_DATA
 	CONSTRUCTORS
 	}
 
-  . = ALIGN(PAGE_SIZE);
-  __nosave_begin = .;
-  .data_nosave : { *(.data.nosave) }
-  . = ALIGN(PAGE_SIZE);
-  __nosave_end = .;
-
   . = ALIGN(32);
   .data.cacheline_aligned : { *(.data.cacheline_aligned) }
 
-- 
1.6.2.1

