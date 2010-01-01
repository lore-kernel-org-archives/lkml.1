Return-Path: <linux-kernel-owner+w=401wt.eu-S1751531Ab0AAAfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab0AAAfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 19:35:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374Ab0AAAfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 19:35:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355Ab0AAAfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 19:35:02 -0500
Date: Thu, 31 Dec 2009 16:34:37 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: origin tree build warning
In-Reply-To: <20100101112914.41bc5f77.sfr@canb.auug.org.au>
Message-ID: <alpine.LFD.2.00.0912311634110.3630@localhost.localdomain>
References: <20100101112914.41bc5f77.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Jan 2010, Stephen Rothwell wrote:
> 
> Today's linux-next build (powerpc allnoconfig) produced this warning:
> 
> drivers/pci/quirks.c: In function 'pci_dev_specific_reset':
> drivers/pci/quirks.c:2699: warning: assignment discards qualifiers from pointer target type
> 
> Introduced by commit 5b889bf237fca383b5807ad69fde3ad1e2287e42 ("PCI: Fix
> build if quirks are not enabled").

Does this trivial patch get rid of it?

		Linus
---
 drivers/pci/quirks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 5c449fc..c746943 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2694,7 +2694,7 @@ static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
 
 int pci_dev_specific_reset(struct pci_dev *dev, int probe)
 {
-	struct pci_dev_reset_methods *i;
+	const struct pci_dev_reset_methods *i;
 
 	for (i = pci_dev_reset_methods; i->reset; i++) {
 		if ((i->vendor == dev->vendor ||
