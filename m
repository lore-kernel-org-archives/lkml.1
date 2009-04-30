Return-Path: <linux-kernel-owner+w=401wt.eu-S1761514AbZEAAEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761514AbZEAAEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763955AbZD3X71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:59:27 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61117 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764895AbZD3X70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:59:26 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, David Howells <dhowells@redhat.com>,
       Tim Abbott <tabbott@MIT.EDU>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 2/6] mn10300: Drop unused .data.idt section.
Date: Thu, 30 Apr 2009 19:54:17 -0400
Message-Id: <1241135661-9147-3-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135661-9147-2-git-send-email-tabbott@mit.edu>
References: <1241135661-9147-1-git-send-email-tabbott@mit.edu>
 <1241135661-9147-2-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since nothing gets put into .data.idt on this architecture, eliminate
it from the linker script.

This change was apparently proposed previously:
<http://lkml.indiana.edu/hypermail/linux/kernel/0802.2/2538.html>

CCing the author and people who acked that patch in case there was a
reason it wasn't applied.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Acked-by: David Howells <dhowells@redhat.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 arch/mn10300/kernel/vmlinux.lds.S |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/mn10300/kernel/vmlinux.lds.S b/arch/mn10300/kernel/vmlinux.lds.S
index 6ad0fa8..364250f 100644
--- a/arch/mn10300/kernel/vmlinux.lds.S
+++ b/arch/mn10300/kernel/vmlinux.lds.S
@@ -59,9 +59,6 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   __nosave_end = .;
 
-  . = ALIGN(PAGE_SIZE);
-  .data.page_aligned : { *(.data.idt) }
-
   . = ALIGN(32);
   .data.cacheline_aligned : { *(.data.cacheline_aligned) }
 
-- 
1.6.2.1

