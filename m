Return-Path: <linux-kernel-owner+w=401wt.eu-S1760255AbYFEUr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255AbYFEUr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 16:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbYFEUrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 16:47:48 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37636 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbYFEUrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 16:47:47 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 5 Jun 2008 22:47:13 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH regression fix] x86: fix CONFIG_NONPROMISC_DEVMEM prompt
 and help text
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.fcf3166d665fd601@s5r6.in-berlin.de>
Message-ID: <tkrat.aae224617c4e53a0@s5r6.in-berlin.de>
References: <481DC997.3070901@s5r6.in-berlin.de>
 <tkrat.fcf3166d665fd601@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
>  config NONPROMISC_DEVMEM
> -	bool "Disable promiscuous /dev/mem"
> +	bool "Restricted access to /dev/mem"

Hmm, now "N" could be mistaken for "no access at all".


From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Here is an attempt to translate the prompt and help text into something
which is legible and, as a bonus, correct.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 arch/x86/Kconfig.debug |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

Index: linux/arch/x86/Kconfig.debug
===================================================================
--- linux.orig/arch/x86/Kconfig.debug
+++ linux/arch/x86/Kconfig.debug
@@ -6,15 +6,19 @@ config TRACE_IRQFLAGS_SUPPORT
 source "lib/Kconfig.debug"
 
 config NONPROMISC_DEVMEM
-	bool "Disable promiscuous /dev/mem"
+	bool "Filter access to /dev/mem"
 	help
-	  The /dev/mem file by default only allows userspace access to PCI
-	  space and the BIOS code and data regions. This is sufficient for
-	  dosemu and X and all common users of /dev/mem. With this config
-	  option, you allow userspace access to all of memory, including
-	  kernel and userspace memory. Accidental access to this is
-	  obviously disasterous, but specific access can be used by people
-	  debugging the kernel.
+	  If this option is left off, you allow userspace access to all
+	  of memory, including kernel and userspace memory. Accidental
+	  access to this is obviously disastrous, but specific access can
+	  be used by people debugging the kernel.
+
+	  If this option is switched on, the /dev/mem file only allows
+	  userspace access to PCI space and the BIOS code and data regions.
+	  This is sufficient for dosemu and X and all common users of
+	  /dev/mem.
+
+	  If in doubt, say Y.
 
 config EARLY_PRINTK
 	bool "Early printk" if EMBEDDED

-- 
Stefan Richter
-=====-==--- -==- --=-=
http://arcgraph.de/sr/

