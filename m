Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbYE0LWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbYE0LWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 07:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756355AbYE0LVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 07:21:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42319 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbYE0LVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 07:21:49 -0400
Date: Tue, 27 May 2008 13:22:37 +0200
From: Pavel Machek <pavel@suse.cz>
To: Patrick <ragamuffin@datacomm.ch>
Cc: linux-kernel@vger.kernel.org
Subject: Re: >3G => iommu => suspend problems -- was Re: SB600 AHCI: Hard
	Disk Corruption
Message-ID: <20080527112236.GA13957@elf.ucw.cz>
References: <1211717435.6038.53.camel@localhost.localdomain> <20080525173825.GA4132@ucw.cz> <1211746106.6188.57.camel@localhost.localdomain> <20080525203921.GB18781@elf.ucw.cz> <20080525211016.GA32478@elf.ucw.cz> <1211815881.6140.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211815881.6140.19.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Can you try this one? It should prevent suspend in the broken cases,
> > but allow it in mem=4G config.
> 
> Sure!
> 
> root@babar:/usr/src/linux-2.6.25# patch -p1 < /home/pat/patch-2.6.26-rc3.gart-suspend
> patching file arch/x86/kernel/pci-gart_64.c
> Hunk #4 succeeded at 629 with fuzz 2 (offset 11 lines).
> 
> .....make; cp bzImage /boot; reboot....

Thanks!

This goes on top of the second patch... it makes it work.

								Pavel

For iommu suspend/resume code to work, functions it calls may not be
__init.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 0ea376de01be797f9563c2c2464149f8f0af6329
tree 4b5179fe97fe045cc770091bce94f898f26e4499
parent 017834f8541b8ded8ef831e5fe2b5f9cead4f6b0
author Pavel <pavel@amd.ucw.cz> Tue, 27 May 2008 13:21:05 +0200
committer Pavel <pavel@amd.ucw.cz> Tue, 27 May 2008 13:21:05 +0200

 arch/x86/kernel/k8.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/k8.c b/arch/x86/kernel/k8.c
index 7377ccb..acf4770 100644
--- a/arch/x86/kernel/k8.c
+++ b/arch/x86/kernel/k8.c
@@ -76,7 +76,7 @@ EXPORT_SYMBOL_GPL(cache_k8_northbridges)
 
 /* Ignores subdevice/subvendor but as far as I can figure out
    they're useless anyways */
-int __init early_is_k8_nb(u32 device)
+int early_is_k8_nb(u32 device)
 {
 	struct pci_device_id *id;
 	u32 vendor = device & 0xffff;


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
