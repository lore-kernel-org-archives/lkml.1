Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbYCaVgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbYCaVgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 17:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756622AbYCaVgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 17:36:32 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:42464 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256AbYCaVgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 17:36:31 -0400
Message-ID: <47F159BE.7050201@keyaccess.nl>
Date: Mon, 31 Mar 2008 23:38:06 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 00/37] PNP resource_table cleanups
References: <20080326171058.099442579@ldl.fc.hp.com> <200803271150.30512.bjorn.helgaas@hp.com> <47F13E13.7090608@keyaccess.nl> <200803311451.54499.bjorn.helgaas@hp.com>
In-Reply-To: <200803311451.54499.bjorn.helgaas@hp.com>
Content-Type: multipart/mixed;
 boundary="------------010609060207060505030402"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010609060207060505030402
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 31-03-08 22:51, Bjorn Helgaas wrote:

> Ah, right.  Thanks for tracking that down.  I forgot to factor out
> isapnp_to_pnpid() and pnpid32_to_pnpid() (and acpi_ex_eisa_id_to_string()
> for that matter, though that's buried in the ACPI CA)-- they're really
> doing the same thing and we should only need one copy (plus the CA
> one).

I'll wait for another round then, before reviewing this further.

> Hmmm...  that sounds harder.  I'll read over it again and see if I
> can figure anything out.

Actually, other than looking right past it a few dozen times, it's fairly 
evident. If I apply the attached, my soundcard's functional again.

Rene.

--------------010609060207060505030402
Content-Type: text/plain;
 name="pnp_check_resource.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pnp_check_resource.diff"

diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index 454290b..9ff76dc 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -261,7 +261,7 @@ int pnp_check_port(struct pnp_dev *dev, int idx)
 		if (tdev == dev)
 			continue;
 		for (i = 0;
-		     (tres = pnp_get_resource(dev, IORESOURCE_IO, i));
+		     (tres = pnp_get_resource(tdev, IORESOURCE_IO, i));
 		     i++) {
 			if (tres->flags & IORESOURCE_IO) {
 				if (cannot_compare(tres->flags))
@@ -325,7 +325,7 @@ int pnp_check_mem(struct pnp_dev *dev, int idx)
 		if (tdev == dev)
 			continue;
 		for (i = 0;
-		     (tres = pnp_get_resource(dev, IORESOURCE_MEM, i));
+		     (tres = pnp_get_resource(tdev, IORESOURCE_MEM, i));
 		     i++) {
 			if (tres->flags & IORESOURCE_MEM) {
 				if (cannot_compare(tres->flags))
@@ -408,7 +408,7 @@ int pnp_check_irq(struct pnp_dev *dev, int idx)
 		if (tdev == dev)
 			continue;
 		for (i = 0;
-		     (tres = pnp_get_resource(dev, IORESOURCE_IRQ, i));
+		     (tres = pnp_get_resource(tdev, IORESOURCE_IRQ, i));
 		     i++) {
 			if (tres->flags & IORESOURCE_IRQ) {
 				if (cannot_compare(tres->flags))
@@ -471,7 +471,7 @@ int pnp_check_dma(struct pnp_dev *dev, int idx)
 		if (tdev == dev)
 			continue;
 		for (i = 0;
-		     (tres = pnp_get_resource(dev, IORESOURCE_DMA, i));
+		     (tres = pnp_get_resource(tdev, IORESOURCE_DMA, i));
 		     i++) {
 			if (tres->flags & IORESOURCE_DMA) {
 				if (cannot_compare(tres->flags))

--------------010609060207060505030402--
