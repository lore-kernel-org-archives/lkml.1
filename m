Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbYEKSrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbYEKSrJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 14:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551AbYEKSqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 14:46:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:40595 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbYEKSqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 14:46:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=K1TAROpast4RfMzsObo/iMT7N1R70uDU7LuuyrLfV7R4zeeIVl8PH8a53m367XRWQ9fHmHDYcU55v5ULAcpeHPK06mA20E6GgMuSgXUE3dZgEXpuw8MaofuY2iqjcbZOA8Mz7IVI1H+B6eZBwg3yNJjAIW5Sm+MUIgL3ml/kL6Y=
Date: Sun, 11 May 2008 22:46:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pavel Machek <pavel@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: wakeup.lds.S - section ordering fix
Message-ID: <20080511184638.GE6942@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To allow linker to catch sections overlapping we have to declare
them in appropriate order.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Please test and review

Index: linux-2.6.git/arch/x86/kernel/acpi/realmode/wakeup.lds.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/acpi/realmode/wakeup.lds.S	2008-05-11 20:21:58.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/acpi/realmode/wakeup.lds.S	2008-05-11 22:34:42.000000000 +0400
@@ -12,11 +12,6 @@ ENTRY(_start)
 
 SECTIONS
 {
-	. = HEADER_OFFSET;
-	.header : {
-		 *(.header)
-	}
-
 	. = 0;
 	.text : {
 		 *(.text*)
@@ -50,6 +45,11 @@ SECTIONS
 		__bss_end = .;
 	}
 
+	. = HEADER_OFFSET;
+	.header : {
+		*(.header)
+	}
+
 	. = ALIGN(16);
 	_end = .;
 
