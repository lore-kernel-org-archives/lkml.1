Return-Path: <linux-kernel-owner+w=401wt.eu-S936536AbXGRBEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936536AbXGRBEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 21:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758049AbXGRBD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 21:03:57 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:60965 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757678AbXGRBD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 21:03:57 -0400
Date: Wed, 18 Jul 2007 11:03:55 +1000
To: Bret Towe <magnade@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Re: 2.6.22-git ppc build failure
Message-ID: <20070718010355.GV10345@bakeyournoodle.com>
References: <dda83e780707171104g10372341l7d2225f172153a6b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dda83e780707171104g10372341l7d2225f172153a6b@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 11:04:57AM -0700, Bret Towe wrote:
> this is off my g4 mac mini
> latest git as of when this email was sent
> config file attached

Hi Bret,
	the patch below will fix it.

From: Tony Breeds <tony@bakeyournoodle.com>

Fix compile failure in arch/powerpc/kernel/pci-common.c

 CC      arch/powerpc/kernel/pci-common.o
arch/powerpc/kernel/pci-common.c:160: error: conflicting types for 'pcibios_add_platform_entries'
include/linux/pci.h:889: error: previous declaration of 'pcibios_add_platform_entries' was here

Fallout from the powerpc merge (489de30259e667d7bc47da9da44a0270b050cd97).

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>

---
 arch/powerpc/kernel/pci-common.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: working/arch/powerpc/kernel/pci-common.c
===================================================================
--- working.orig/arch/powerpc/kernel/pci-common.c	2007-07-18 10:34:55.000000000 +1000
+++ working/arch/powerpc/kernel/pci-common.c	2007-07-18 10:39:19.000000000 +1000
@@ -156,11 +156,14 @@ static DEVICE_ATTR(devspec, S_IRUGO, pci
 #endif /* CONFIG_PPC_OF */
 
 /* Add sysfs properties */
-void pcibios_add_platform_entries(struct pci_dev *pdev)
+int pcibios_add_platform_entries(struct pci_dev *pdev)
 {
 #ifdef CONFIG_PPC_OF
-	device_create_file(&pdev->dev, &dev_attr_devspec);
+	return device_create_file(&pdev->dev, &dev_attr_devspec);
+#else
+	return 0;
 #endif /* CONFIG_PPC_OF */
+
 }
 
 char __init *pcibios_setup(char *str)

Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

