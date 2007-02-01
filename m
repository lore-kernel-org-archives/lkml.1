Return-Path: <linux-kernel-owner+w=401wt.eu-S1422879AbXBANwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422879AbXBANwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422880AbXBANwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:52:30 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51200 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422879AbXBANw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:52:29 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] mca_nmi_hook() can be called at any point
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HCcMW-0007Os-VL@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 01 Feb 2007 13:52:28 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


... and having it __init is a bad idea.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/i386/mach-default/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/i386/mach-default/setup.c b/arch/i386/mach-default/setup.c
index c511705..cc2f519 100644
--- a/arch/i386/mach-default/setup.c
+++ b/arch/i386/mach-default/setup.c
@@ -102,7 +102,7 @@ void __init time_init_hook(void)
  *	along the MCA bus.  Use this to hook into that chain if you will need
  *	it.
  **/
-void __init mca_nmi_hook(void)
+void mca_nmi_hook(void)
 {
 	/* If I recall correctly, there's a whole bunch of other things that
 	 * we can do to check for NMI problems, but that's all I know about
-- 
1.5.0-rc2.GIT


