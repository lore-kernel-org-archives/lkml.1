Return-Path: <linux-kernel-owner+w=401wt.eu-S932755AbXBQS6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755AbXBQS6g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 13:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932756AbXBQS6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 13:58:36 -0500
Received: from www.osadl.org ([213.239.205.134]:36800 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932755AbXBQS6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 13:58:35 -0500
Subject: [PATCH] tick management: make broadcast dependent on local APIC
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <1171737758.30834.154.camel@localhost.localdomain>
References: <200702162108.01206.lenb@kernel.org>
	 <1171707924.30834.111.camel@localhost.localdomain>
	 <1171736745.3379.24.camel@mulgrave.il.steeleye.com>
	 <1171737758.30834.154.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 17 Feb 2007 20:03:21 +0100
Message-Id: <1171739001.30834.164.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The broadcast functionality is only necessary when a local APIC is
available. Make the config switch depend on X86_LOCAL_APIC. This
resolves the mach-voyager breakage introduced by the tick managament
code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index 1df4a1f..2f76725 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -29,6 +29,7 @@ config GENERIC_CLOCKEVENTS
 config GENERIC_CLOCKEVENTS_BROADCAST
 	bool
 	default y
+	depends on X86_LOCAL_APIC
 
 config LOCKDEP_SUPPORT
 	bool


