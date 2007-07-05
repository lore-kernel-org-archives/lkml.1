Return-Path: <linux-kernel-owner+w=401wt.eu-S1758486AbXGEAdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486AbXGEAdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 20:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbXGEAc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 20:32:59 -0400
Received: from gw.goop.org ([64.81.55.164]:59225 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815AbXGEAc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 20:32:59 -0400
Message-ID: <468C3C39.2030009@goop.org>
Date: Wed, 04 Jul 2007 17:32:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, jeremy@xensource.com,
       chrisw@sous-sol.org, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, Andi Kleen <ak@suse.de>
Subject: [PATCH] xen: can't support numa yet
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <20070704190046.GL3492@stusta.de>
In-Reply-To: <20070704190046.GL3492@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xen currently relies on contigious memory (ie, no numa, discontig or
sparse memory).  Specifically it uses mem_map, which is only available
if CONFIG_NEED_MULTIPLE_NODES is not defined.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: Andi Kleen <ak@suse.de>

---
 arch/i386/xen/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/arch/i386/xen/Kconfig
+++ b/arch/i386/xen/Kconfig
@@ -4,7 +4,7 @@
 
 config XEN
 	bool "Enable support for Xen hypervisor"
-	depends on PARAVIRT && X86_CMPXCHG && X86_TSC
+	depends on PARAVIRT && X86_CMPXCHG && X86_TSC && !NEED_MULTIPLE_NODES
 	help
 	  This is the Linux Xen port.  Enabling this will allow the
 	  kernel to boot in a paravirtualized environment under the



