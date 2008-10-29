Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbYJ2LAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbYJ2LAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 07:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbYJ2K76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 06:59:58 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56672 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbYJ2K75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 06:59:57 -0400
Date: Wed, 29 Oct 2008 11:59:56 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [PATCH] hibernation should work ok with memory hotplug
Message-ID: <20081029105956.GA16347@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hibernation + memory hotplug was disabled in kconfig because we could
not handle hibernation + sparse mem at some point. It seems to work
now, so I guess we can enable it.

Signed-off-by: Pavel Machek <pavel@suse.cz>


diff -ur linux/mm/Kconfig linux.tmp/mm/Kconfig
--- linux/mm/Kconfig	2008-10-27 10:10:59.000000000 +0100
+++ linux.tmp/mm/Kconfig	2008-10-29 10:02:41.000000000 +0100
@@ -128,12 +128,9 @@
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
 	depends on SPARSEMEM || X86_64_ACPI_NUMA
-	depends on HOTPLUG && !HIBERNATION && ARCH_ENABLE_MEMORY_HOTPLUG
+	depends on HOTPLUG && ARCH_ENABLE_MEMORY_HOTPLUG
 	depends on (IA64 || X86 || PPC64 || SUPERH || S390)
 
-comment "Memory hotplug is currently incompatible with Software Suspend"
-	depends on SPARSEMEM && HOTPLUG && HIBERNATION
-
 config MEMORY_HOTPLUG_SPARSE
 	def_bool y
 	depends on SPARSEMEM && MEMORY_HOTPLUG

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
