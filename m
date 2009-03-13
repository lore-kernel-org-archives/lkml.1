Return-Path: <linux-kernel-owner+w=401wt.eu-S1759474AbZCMRAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474AbZCMRAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbZCMRA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:00:29 -0400
Received: from gw.goop.org ([64.81.55.164]:57364 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752701AbZCMRA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:00:28 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       David Airlie <airlied@linux.ie>, Alex Nixon <alex.nixon@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 01/27] xen: Don't disable the I/O space
Date: Fri, 13 Mar 2009 09:59:46 -0700
Message-Id: <1236963612-14287-2-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236963612-14287-1-git-send-email-jeremy@goop.org>
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Nixon <alex.nixon@citrix.com>

If a guest domain wants to access PCI devices through the frontend
driver (coming later in the patch series), it will need access to the
I/O space.

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/setup.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 175396c..5f1b88c 100644
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

