Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbYBAIlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbYBAIlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 03:41:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbYBAIkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 03:40:55 -0500
Received: from hu-out-0506.google.com ([72.14.214.231]:3180 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbYBAIky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 03:40:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NLtT0Dmq509QyJBtO5s3TPWKU9iJVha0TLq/eyJrtc4PsiCrm1V6Ea+Tyl2aIsKb/wRKrJzkGL3nFPntoHHrrNhlRx1elamJGIRfRMw/AjqMEaxmPdYb1FKDEJb+atdyUfz+oG4eerNR843k4Ojl7RGa3tafVGp+M43co7+jwD4=
Subject: [PATCH] x86: make early_console static in early_printk.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 00:40:50 -0800
Message-Id: <1201855250.23523.97.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not necessary to expose it, also fixes sparse warning.

arch/x86/kernel/early_printk.c:196:16: warning: symbol 'early_console' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/early_printk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index b7d6c23..cff84cd 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -193,7 +193,7 @@ static struct console simnow_console = {
 };
 
 /* Direct interface for emergencies */
-struct console *early_console = &early_vga_console;
+static struct console *early_console = &early_vga_console;
 static int early_console_initialized = 0;
 
 void early_printk(const char *fmt, ...)
-- 
1.5.4.rc4.1142.gf5a97



