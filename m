Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbYE2OLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbYE2OLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 10:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbYE2OL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 10:11:27 -0400
Received: from ns.suse.de ([195.135.220.2]:34527 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbYE2OL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 10:11:26 -0400
Date: Thu, 29 May 2008 16:14:21 +0200
From: Holger Macht <hmacht@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] libata: Handle bay devices in dock stations
Message-ID: <20080529141421.GC9268@homac.suse.de>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
	linux-acpi@vger.kernel.org, akpm@linux-foundation.org
References: <20080528143857.GB5585@homac.suse.de> <20080529132253.GA22309@srcf.ucam.org> <483EB33D.6010101@gmail.com> <20080529140213.GA23373@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529140213.GA23373@srcf.ucam.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 29. May - 15:02:13, Matthew Garrett wrote:
> On Thu, May 29, 2008 at 10:44:29PM +0900, Tejun Heo wrote:
> > Does this fix the problem?
> 
> No, I'm seeing an identical hang. Mainline works fine.

Maybe you could also try this on top of Tejun's patch?

--- linux-2.6/drivers/ata/libata-acpi.c.orig	2008-05-29 16:13:00.000000000 +0200
+++ linux-2.6/drivers/ata/libata-acpi.c	2008-05-29 16:13:04.000000000 +0200
@@ -237,10 +237,8 @@
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
-	if (wait) {
+	if (wait)
 		ata_port_wait_eh(ap);
-		ata_acpi_eject_device(handle);
-	}
 
 	if (kobj && !is_dock_event) {
 		sprintf(event_string, "BAY_EVENT=%d", event);

