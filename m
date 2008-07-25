Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbYGYLuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbYGYLuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 07:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbYGYLup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 07:50:45 -0400
Received: from tomsawyer.pc.helsinki.fi ([128.214.151.203]:52345 "EHLO
	tomsawyer.pc.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbYGYLum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 07:50:42 -0400
X-Greylist: delayed 3195 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jul 2008 07:50:41 EDT
Message-Id: <200807251056.m6PAuvTW018244@tomsawyer.pc.helsinki.fi>
From: Vesa-Matti Kari <vmkari@cc.helsinki.fi>
To: viro@zeniv.linux.org.uk
Cc: eparis@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 25 Jul 2008 13:32:30 +0300
Subject: [PATCH] audit: control character detection was off-by-one
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0x7f, the DEL character, was not recognized as a control character.

Signed-off-by: Vesa-Matti Kari <vmkari@cc.helsinki.fi>
---
 kernel/audit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index e092f1c..6d90318 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1366,7 +1366,7 @@ int audit_string_contains_control(const char *string, size_t len)
 {
 	const unsigned char *p;
 	for (p = string; p < (const unsigned char *)string + len && *p; p++) {
-		if (*p == '"' || *p < 0x21 || *p > 0x7f)
+		if (*p == '"' || *p < 0x21 || *p > 0x7e)
 			return 1;
 	}
 	return 0;
-- 
1.5.4.1

