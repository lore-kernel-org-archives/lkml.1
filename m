Return-Path: <linux-kernel-owner+w=401wt.eu-S1754455AbYFAQCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbYFAQCl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 12:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbYFAQC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 12:02:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38627 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbYFAQC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 12:02:28 -0400
Date: Sun, 1 Jun 2008 18:05:15 +0200
From: Holger Macht <hmacht@suse.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] libata: Handle bay devices in dock stations
Message-ID: <20080601160515.GA4599@homac>
Mail-Followup-To: Tejun Heo <htejun@gmail.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
	linux-acpi@vger.kernel.org, akpm@linux-foundation.org
References: <20080528143857.GB5585@homac.suse.de> <20080529132253.GA22309@srcf.ucam.org> <483EB33D.6010101@gmail.com> <20080529140213.GA23373@srcf.ucam.org> <20080529141421.GC9268@homac.suse.de> <20080529143541.GA24013@srcf.ucam.org> <483EBFC5.7020406@gmail.com> <20080529144934.GA24382@srcf.ucam.org> <20080529163201.GA4520@homac> <483EDC73.8030602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483EDC73.8030602@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 30. May - 01:40:19, Tejun Heo wrote:
> Holger Macht wrote:
> > On Thu 29. May - 15:49:34, Matthew Garrett wrote:
> >> Got it. It works if I lose the ata_port_freeze() from 
> >> ata_acpi_detach_device. 
> > 
> > Tejun, any idea? This is in for quite some time now. Maybe there's some
> > involved...
> 
> Does changing it to ata_port_schedule_eh() make any difference?

Finally found a system to reproduce the freeze...

And yes, removing ata_port_freeze() and only doing ata_port_schedule_eh()
in the case where the device has already gone works and prevents the
freeze. Also the docking case works. If this change is not only for
finding out what's going wrong, I'm going resend the patch with your
documentation additions, ok?

Regards,
	Holger

