Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbZCKTYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbZCKTYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbZCKTYC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:24:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883AbZCKTYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:24:00 -0400
Date: Wed, 11 Mar 2009 12:22:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Matthew Wilcox <matthew@wil.cx>
cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] PCI fixes for 2.6.29
In-Reply-To: <20090311043659.GC25995@parisc-linux.org>
Message-ID: <alpine.LFD.2.00.0903111220200.32478@localhost.localdomain>
References: <20090311043659.GC25995@parisc-linux.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 10 Mar 2009, Matthew Wilcox wrote:
> 
> These are the PCI fixes that have been piling up for the last week while
> Jesse's been on vacation.  I don't think there's anything questionable
> here.  All the patches have been posted to linux-pci.

Grrr. It doesn't even compile cleanly:

drivers/pci/quirks.c: In function ¡ht_check_msi_mapping¢:
drivers/pci/quirks.c:2142: warning: ¡return¢ with no value, in function returning non-void

and yes, it's a real bug.

I'm not happy.

I assume the proper fix is this trivial one-liner, but people should 
double-check.

Not pulled.

		Linus

---
 drivers/pci/quirks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index a13f3d7..4ba55d0 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2139,7 +2139,7 @@ static int __devinit ht_check_msi_mapping(struct pci_dev *dev)
 
 	/* Enabling HT MSI mapping on this device breaks MCP51 */
 	if (dev->device == 0x270)
-		return;
+		return 0;
 
 	/* check if there is HT MSI cap or enabled on this device */
 	pos = pci_find_ht_capability(dev, HT_CAPTYPE_MSI_MAPPING);
