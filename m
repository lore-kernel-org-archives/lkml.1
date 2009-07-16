Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbZGPB0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbZGPB0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 21:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbZGPB0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 21:26:45 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39353 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885AbZGPB0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 21:26:44 -0400
Date: Thu, 16 Jul 2009 02:26:42 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/4] scsi: Allow hosts to be flagged as hotpluggable
Message-ID: <20090716012642.GA1269@srcf.ucam.org>
References: <1247701438-18266-1-git-send-email-mjg@redhat.com> <1247706748.8632.3.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247706748.8632.3.camel@mulgrave.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 01:12:28AM +0000, James Bottomley wrote:
> On Thu, 2009-07-16 at 00:43 +0100, Matthew Garrett wrote:
> > Userspace may wish to make policy decisions based on whether a host
> > supports device hotplug or not - for example, AHCI link power management
> > disables hotplug, so may only be desirable on hotplug ports. Add
> > support for marking hosts as hotpluggable in order to allow userspace to
> > treat them appropriately.
> 
> OK, so I don't really understand what the hotplug flag means.
> 
> You seem to be setting it unconditionally on most sata HBAs.  If it just
> means "bus is hotpluggable", it should be set to 1 at initialisation and
> the few non hot plug busses (like SPI) get to reset it.

It's a tossup. PATA's not hotpluggable (in the general case), so I just 
picked a default and went with it. Inverting it would be easy enough, I 
guess.

> However, by definition SATA (like SAS) is a hotplug bus ... why isn't it
> set for some SATA controllers ... is it because the HBA itself does
> something wrong when a hotplug event comes in?

Some older controllers don't provide direct access to the phy registers, 
so there's no way to interpret hotplug events correctly.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
