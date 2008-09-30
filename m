Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbYI3Tel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbYI3Tel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbYI3TeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:34:20 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:49459 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbYI3TeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:34:15 -0400
Message-ID: <48E27FFE.4040809@keyaccess.nl>
Date: Tue, 30 Sep 2008 21:37:34 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Adam Belay <abelay@mit.edu>, Avuton Olrich <avuton@gmail.com>,
       Karl Bellve <karl.bellve@umassmed.edu>, Willem Riede <wriede@riede.org>,
       Matthew Hall <mhall@mhcomputing.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 2/2] PNP: don't check disabled PCI BARs for conflicts
 in quirk_system_pci_resources()
References: <200809290953.56565.bjorn.helgaas@hp.com> <200809290957.59813.bjorn.helgaas@hp.com> <alpine.LFD.1.10.0809290912060.3265@nehalem.linux-foundation.org> <48E11EFA.8010402@keyaccess.nl> <alpine.LFD.2.00.0809291211330.3389@nehalem.linux-foundation.org> <48E1EF0E.8030006@keyaccess.nl> <alpine.LFD.2.00.0809300741320.3389@nehalem.linux-foundation.org> <48E24C6F.3030903@keyaccess.nl> <alpine.LFD.2.00.0809300904530.3389@nehalem.linux-foundation.org> <alpine.LFD.2.00.0809301001280.3389@nehalem.linux-foundation.org> <alpine.LFD.2.00.0809301015210.4651@nehalem.linux-foundation.org> <48E27E23.20400@keyaccess.nl>
In-Reply-To: <48E27E23.20400@keyaccess.nl>
Content-Type: multipart/mixed;
 boundary="------------010802030607090805020001"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010802030607090805020001
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 30-09-08 21:29, Rene Herman wrote:

> Yes, I also get that oops but other than that, both link order versions 
> you sent out work -- ie, booting with acpi=noirq gets me to a functional 
> system with the quirk having run for PNP0c02 (acpi=off disables all of 
> PNP0c02) and doing its job.
> 
> For some reason only some of your messages seem to be making it into my 
> inbox (in order, at least) but either of these that is:
> 
> http://lkml.org/lkml/2008/9/30/242
> http://lkml.org/lkml/2008/9/30/261
> 
> With the attached on top, all's working fine for me.

It does, but that said... placing the attached small debug printk's on 
top gets me:

> [    0.070170] pnp 00:01: parse allocated resources
> [    0.070397] pnp 00:01:   add io  0xde00-0xde03 flags 0x1
> [    0.070405] pnp 00:01: PNP0c02: calling quirk_system_pci_resources+0x0/0x199
> [    0.070428] pci 0000:00:00.0: skipping resource 3 4 5 6 7 8 9 10 11
> [    0.070832] pci 0000:00:01.0: skipping resource 0 1 2 3 4 5 6 10 11
> [    0.071241] pci 0000:00:07.0: skipping resource 0 1 2 3 4 5 6 7 8 9 10 11
> [    0.071734] pci 0000:00:07.1: skipping resource 5 6 7 8 9 10 11
> [    0.072077] pci 0000:00:07.3: skipping resource 0 1 2 3 4 5 6 7 8 9 10 11
> [    0.072570] pci 0000:00:07.4: skipping resource 1 2 3 4 5 6 7 8 9 10 11
> [    0.073033] pci 0000:00:08.0: skipping resource 2 3 4 5 6 7 8 9 10 11
> [    0.073458] pci 0000:00:09.0: skipping resource 1 2 3 4 5 6 7 8 9 10 11
> [    0.073918] pci 0000:00:09.1: skipping resource 1 2 3 4 5 6 7 8 9 10 11
> [    0.074406] pci 0000:00:09.2: skipping resource 1 2 3 4 5 6 7 8 9 10 11
> [    0.074865] pci 0000:00:0a.0: skipping resource<4>pnp 00:01: io resource (0xde00-0xde03) overlaps 0000:00:0a.0 BAR 0 (0xde00-0xdeff), disabling
> [    0.074991]  1 2 3 4 5 6 7 8 9 10 11
> [    0.075410] pci 0000:01:05.0: skipping resource 3 4 5 6 7 8 9 10 11
> [    0.075962] pnp 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)

which does still feel rather clunky (especially the missing "middle" 
resources 7, 8 and 9 for 01.0, my AGP bridge, look a little weird).

(0a.0 is ofcourse my soundcard that is the issue)

The resources array for pci_dev is static -- a pci_dev bitmask of 
enabled resources does sound somewhat nice-ish still perhaps.

Rene.

--------------010802030607090805020001
Content-Type: text/plain;
 name="debug-quirk_system_pci_resources.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="debug-quirk_system_pci_resources.diff"

diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 0cf4ccf..44bd869 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -245,14 +245,17 @@ static void quirk_system_pci_resources(struct pnp_dev *dev)
 	 * so they won't be claimed by the PNP system driver.
 	 */
 	for_each_pci_dev(pdev) {
+		dev_info(&pdev->dev, "skipping resource");
 		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
 			unsigned int type;
 
 			pci_res = &pdev->resource[i];
 
 			/* skip unregistered resources */
-			if (!pci_res->parent)
+			if (!pci_res->parent)  {
+				printk(KERN_CONT " %d", i);
 				continue;
+			}
 
 			type = pci_res->flags &
 				(IORESOURCE_IO | IORESOURCE_MEM);
@@ -305,6 +308,7 @@ static void quirk_system_pci_resources(struct pnp_dev *dev)
 				pnp_res->flags |= IORESOURCE_DISABLED;
 			}
 		}
+		printk(KERN_CONT "\n");
 	}
 }
 

--------------010802030607090805020001--

