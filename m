Return-Path: <linux-kernel-owner+w=401wt.eu-S1760666AbYBZQWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760666AbYBZQWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 11:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYBZQWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 11:22:40 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:39389 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbYBZQWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 11:22:39 -0500
Date: Tue, 26 Feb 2008 16:21:43 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Mark Lord <liml@rtr.ca>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       stern@rowland.harvard.edu, linux-ide@vger.kernel.org
Message-ID: <20080226162142.GA12020@srcf.ucam.org>
References: <20080225134558.GA1611@elf.ucw.cz> <47C34081.5090205@rtr.ca> <47C34472.3090706@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C34472.3090706@garzik.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [ugly patch] Save .15W-.5W by AHCI powersaving
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 05:42:58PM -0500, Jeff Garzik wrote:

> BTW we can also save power by allowing the user to choose to disable 
> hotplugging support.  Then we can power down PHYs that are not in use.
> 
> That requires the addition of some policy controls, because it is 
> user-specific whether or not to waste power waiting for a plug-in event.

For AHCI, if you've enabled link power management then you've already 
disabled hotplug. We might as well power down unused phys in that case. 
Note that laptop bays still seem to tend to use platform-specific 
hotplug notification, even when they're sata - we'll get the hotplug 
notify for them even if the phy's powered down, so that case also needs 
to be handled.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
