Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbXLMJAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbXLMJAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 04:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbXLMI77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 03:59:59 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:30361
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114AbXLMI77 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 03:59:59 -0500
Message-Id: <476102D1.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 13 Dec 2007 09:00:49 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>,
       "Jeremy Fitzhardinge" <jeremy@xensource.com>
Subject: [PATCH] i386: XEN config option should not depend on
	X86_TSC/X86_CMPXCHG
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The way X86_TSC works and the fact that Xen itself won't work on
systems without TSC (really any systems pre-dating i686) makes it
unnecessary for XEN to depend on it.

Similarly, X86_CMPXCHG isn't needed here either as Xen for the above
reason guarantees its availability.

This allows the option to be available when selecting M386, M486, or
M586.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>

 arch/x86/xen/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc5/arch/x86/xen/Kconfig	2007-12-12 11:28:18.000000000 +0100
+++ 2.6.24-rc5-i386-xen-no-tsc/arch/x86/xen/Kconfig	2007-12-07 14:53:28.000000000 +0100
@@ -5,7 +5,7 @@
 config XEN
 	bool "Xen guest support"
 	select PARAVIRT
-	depends on X86_CMPXCHG && X86_TSC && !NEED_MULTIPLE_NODES && !(X86_VISWS || X86_VOYAGER)
+	depends on !NEED_MULTIPLE_NODES && !(X86_VISWS || X86_VOYAGER)
 	help
 	  This is the Linux Xen port.  Enabling this will allow the
 	  kernel to boot in a paravirtualized environment under the



