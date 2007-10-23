Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbXJWL5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbXJWL5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 07:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbXJWL5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 07:57:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:48111 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbXJWL5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 07:57:01 -0400
Date: Tue, 23 Oct 2007 13:57:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: mark irqbalance not-recommended
Message-ID: <20071023115709.GA1734@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Mark CONFIG_IRQBALANCE as not recommended any more. It eats too much
power, and better solutions are available in userspace.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 2665f7971b5b97830b028308553a78a95c131988
tree e1782cceebfb5900373469c0043d113de88f861f
parent f5085f6ea1c5771708c44a4a42ee217e760ff4a0
author Pavel <pavel@amd.ucw.cz> Tue, 23 Oct 2007 13:56:15 +0200
committer Pavel <pavel@amd.ucw.cz> Tue, 23 Oct 2007 13:56:15 +0200

 arch/i386/Kconfig |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index eba2d88..10f3c38 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -779,10 +779,13 @@ config EFI
 config IRQBALANCE
  	bool "Enable kernel irq balancing"
 	depends on SMP && X86_IO_APIC
-	default y
+	default n
 	help
- 	  The default yes will allow the kernel to do irq load balancing.
-	  Saying no will keep the kernel from doing irq load balancing.
+ 	  Saying yes will allow the kernel to do irq load balancing;
+	  but it generates too many CPU wakeups, eating power, and
+	  is better done in userspace.
+
+	  Say N.
 
 # turning this on wastes a bunch of space.
 # Summit needs it only when NUMA is on

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
