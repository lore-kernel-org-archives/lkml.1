Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbZGPIpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbZGPIpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 04:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbZGPIpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 04:45:13 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:2480 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbZGPIpM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 04:45:12 -0400
Message-Id: <4A5F04B7020000780000AB59@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 16 Jul 2009 09:45:11 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix MCE's set_trigger() accessor
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix oops

Fix the condition checking the result of strchr() (which previously
could result in an oops), and make the function return the number of
bytes actively used.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/cpu/mcheck/mce.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- linux-2.6.31-rc3/arch/x86/kernel/cpu/mcheck/mce.c	2009-07-16 10:01:19.000000000 +0200
+++ 2.6.31-rc3-x86-mce-set-trigger/arch/x86/kernel/cpu/mcheck/mce.c	2009-07-16 00:00:00.000000000 +0200
@@ -1692,17 +1692,15 @@ static ssize_t set_trigger(struct sys_de
 				const char *buf, size_t siz)
 {
 	char *p;
-	int len;
 
 	strncpy(mce_helper, buf, sizeof(mce_helper));
 	mce_helper[sizeof(mce_helper)-1] = 0;
-	len = strlen(mce_helper);
 	p = strchr(mce_helper, '\n');
 
-	if (*p)
+	if (p)
 		*p = 0;
 
-	return len;
+	return strlen(mce_helper) + !!p;
 }
 
 static ssize_t set_ignore_ce(struct sys_device *s,



