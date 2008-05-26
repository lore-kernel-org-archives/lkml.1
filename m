Return-Path: <linux-kernel-owner+w=401wt.eu-S1755666AbYEZS22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbYEZS22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 14:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbYEZS2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 14:28:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33113 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453AbYEZS2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 14:28:20 -0400
Date: Mon, 26 May 2008 20:29:04 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: amd64-agp: resume but too late?
Message-ID: <20080526182904.GA13683@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I don't get it:

--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -549,6 +549,8 @@ static int agp_amd64_suspend(struct pci_
        return 0;
 }
 
+/* FIXME: this is strange; we enable iommu translation here, but that
+ * may be too late, no? */
 static int agp_amd64_resume(struct pci_dev *pdev)
 {
        pci_set_power_state(pdev, PCI_D0);

...but resume is normal pci device, so other devices may be resumed
before this one, and already depend on iommu running...

How is this supposed to work? Should agp_amd64_resume be called from
sysdev or something like that?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
