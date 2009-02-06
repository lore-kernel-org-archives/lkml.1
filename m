Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZBFMcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZBFMcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 07:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZBFMcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 07:32:10 -0500
Received: from edu.joroinen.fi ([194.89.68.130]:37970 "EHLO edu.joroinen.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbZBFMcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 07:32:09 -0500
Date: Fri, 6 Feb 2009 14:32:07 +0200
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Suggestions for debugging ata_piix and ahci driver failures on Xen pv_ops dom0 kernel (2.6.29-rcX)
Message-ID: <20090206123207.GP15052@edu.joroinen.fi>
References: <20090205082843.GD15052@edu.joroinen.fi> <498B880E.6070001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <498B880E.6070001@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 06:45:02PM -0600, Robert Hancock wrote:
> Pasi Kärkkäinen wrote:
> >Hello!
> >
> >I'm trying to figure out what's wrong with the pv_ops dom0 kernel/patches 
> >[1]
> >causing at least ata_piix and ahci drivers to fail to work.
> >
> >There was legacy IRQ enabling problem earlier with the pv_ops dom0 
> >patches, which pretty much prevented the disks from being detected.. but 
> >that got fixed. It could still be something related to Xen/dom0 irq 
> >handling.. 
> >I'd be glad if someone could take a look at this 2.6.29-rc3-tip pv_ops 
> >dom0 kernel boot log
> >and comment about _possible_ causes for such behaviour of ata_piix and 
> >ahci:
> >
> >http://pasik.reaktio.net/xen/pv_ops-dom0-debug/pv_ops-dom0-bootlog-11-xen331-linux-2.6.29-rc3-atadebug3.txt
> >
> >In that testing box I have just one IDE hdd attached to ata_piix 
> >controller, the AHCI controller doesn't
> >have any disks attached.
> >
> >The exact same kernel works OK without problems on baremetal without Xen
> >hypervisor. 
> 
> Seems like me like ata_piix is not receiving any interrupts.. the 
> polling-based IDENTIFY and SET FEATURES work, but the READ NATIVE MAX 
> ADDRESS times out and so does the READ DMA that gets tried next.
> 

OK. Thanks for pointing this out. 

> Note that the ata_piix controller is in legacy mode, not native mode, so 
> it's using IRQ 14 and 15, not whatever the hardware may otherwise 
> indicate. Could be the problem is related to that.
>

Yep. With earlier version of pv_ops dom0 patches devm_request_irq() call failed 
for IRQ 14 and 15 in ata_piix driver, but that has been fixed now.. 

Calling devm_request_irq() returns success now, but maybe it doesn't actually
work and do what it should? 

Thanks for your reply!

-- Pasi
