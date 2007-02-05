Return-Path: <linux-kernel-owner+w=401wt.eu-S932829AbXBEOVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829AbXBEOVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932815AbXBEOVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:21:48 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58982 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932659AbXBEOVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:21:46 -0500
Date: Mon, 5 Feb 2007 14:34:39 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Nvidia cable detection problems (was [PATCH] amd74xx: don't
 configure udma mode higher than BIOS did)
Message-ID: <20070205143439.6962c076@localhost.localdomain>
In-Reply-To: <45C73A3E.6080700@gmail.com>
References: <20070205075836.GG1625@htj.dyndns.org>
	<20070205112410.5a3c3182@localhost.localdomain>
	<45C72012.7050605@gmail.com>
	<20070205132247.6f611e3c@localhost.localdomain>
	<45C73A3E.6080700@gmail.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Also another case you broke is kexec.
> 
> 1. If kexec is done while either of amd74xx or pata_amd is loaded, the
> currently configured mode is what the kexeced kernel would use as
> reference.  If the port has been slowed down during operation, yeah, it
> would be sub-optimal but again the worst can happen is udma33.

So we now have an exciting "well kexec might work but here is a new
random weirdness to screw people who it hit".

> CK804 IDE, at least mine, reports 80c in a lot of cases where it
> shouldn't.  I dunno the reason but it also makes drives confused about
> cable type.  Maybe it has the wrong capacitor attached or something.
> This is A8N-E from ASUS, probably one of the popular ones using nf4.

I take it this was how you came to find every cable related bug while
trying to work out what was going on ?

> When that happens, libata EH does its job and slows the interface to
> udma33 after quite a few error messages.  On IDE, if this happens, the
> drive is put into PIO mode making the machine painful to use.

No the IDE layer does DMA changedown fine, well apart from all the
error/timer races in the old IDE code.

> Googling...  I'm listing a few which seem similar.

All of which are before you fixed the drive side stuff

>   http://search.luky.org/linux-kernel.2005/msg30919.html
>   http://www.centos.org/modules/newbb/viewtopic.php?topic_id=4662
>   http://blog.gmane.org/gmane.linux.bios/month=20060601/page=6

And the third is LinuxBIOS so you've actually not fixed anything for that
one.

> Please keep in mind that no one has reported driver side detection is
> wrong in all these years even when in some cases we just assume 80c on
> host side and depended on driver side detection (amd74xx UDMA66
> controllers), but I'm pretty sure it has caused some griefs out in the wild.

Yep.

> I agree with you that this is a hack and ugly as hell.  I don't like it
> either, but it solves an existing problem which could have and possibly
> will hit many users.  So, I think this problem should at least be
> verified.  If it's just my BIOS/motherboard that's crazy, I have no
> problem forgetting about this.

It certainly seems to be Nvidia specific, so perhaps Nvidia can provide
more details on the Nforce4 cable detection ? As with a lot of Nvidia
stuff there was much reverse engineering involved in the original code
base.

And if its a specific board or couple of boards then we should perhaps
use DMI to match them specifically.

> So, anyone with CK804 (a.k.a NF4) up for some testing?

If it still goes I've got a rather iffy NF3 but not an NF4 handy.

Alan
