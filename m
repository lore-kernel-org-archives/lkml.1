Return-Path: <linux-kernel-owner+w=401wt.eu-S1762101AbZE0HZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762101AbZE0HZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762051AbZE0HYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:24:46 -0400
Received: from claw.goop.org ([74.207.240.146]:33524 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761734AbZE0HYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:24:45 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Alex Nixon <alex.nixon@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 01/10] xen: Don't disable the I/O space
Date: Wed, 27 May 2009 00:24:33 -0700
Message-Id: <1243409082-21349-2-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1243409082-21349-1-git-send-email-jeremy@goop.org>
References: <1243409082-21349-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Nixon <alex.nixon@citrix.com>

If a guest domain wants to access PCI devices through the frontend
driver (coming later in the patch series), it will need access to the
I/O space.

[ Impact: Allow for domU IO access, preparing for pci passthrough ]

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/setup.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 805ae53..2439456 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -230,8 +230,5 @@ void __init xen_arch_setup(void)
 
 	pm_idle = xen_idle;
 
-	if (!xen_initial_domain())
-		paravirt_disable_iospace();
-
 	fiddle_vdso();
 }
-- 
1.6.0.6

