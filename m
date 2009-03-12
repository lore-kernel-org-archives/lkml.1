Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbZCLKif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbZCLKif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbZCLKiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:38:18 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:32356 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbZCLKiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:38:17 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Mar 2009 06:38:17 EDT
Message-Id: <49B8F44F.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 12 Mar 2009 10:38:55 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: move save_paranoid into .kprobes.text
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This appears to be necessary as the function gets called from kprobes-
unsafe exception handling stubs (i.e. which themselves live in
.kprobes.text).

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/entry_64.S |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.29-rc7/arch/x86/kernel/entry_64.S	2009-03-11 17:52:10.000000000 +0100
+++ 2.6.29-rc7-x86_64-save_paranoid-kprobes/arch/x86/kernel/entry_64.S	2009-03-10 17:18:55.000000000 +0100
@@ -372,6 +372,7 @@ ENTRY(save_rest)
 END(save_rest)
 
 /* save complete stack frame */
+	.pushsection .kprobes.text, "ax"
 ENTRY(save_paranoid)
 	XCPT_FRAME 1 RDI+8
 	cld
@@ -400,6 +401,7 @@ ENTRY(save_paranoid)
 1:	ret
 	CFI_ENDPROC
 END(save_paranoid)
+	.popsection
 
 /*
  * A newly forked process directly context switches into this address.



