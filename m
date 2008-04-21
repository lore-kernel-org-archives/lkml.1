Return-Path: <linux-kernel-owner+w=401wt.eu-S933557AbYDUNiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557AbYDUNiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760137AbYDUNhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:37:07 -0400
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:36781 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758176AbYDUNhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:37:04 -0400
From: Frans Pop <elendil@planet.nl>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: ISDN testing
Date: Mon, 21 Apr 2008 15:36:56 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
References: <20080420223959.GA17998@havoc.gtf.org> <200804210205.38891.elendil@planet.nl> <480BF15D.2090100@garzik.org>
In-Reply-To: <480BF15D.2090100@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804211536.57655.elendil@planet.nl>
X-OriginalArrivalTime: 21 Apr 2008 13:36:58.0425 (UTC) FILETIME=[C5931290:01C8A3B4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 April 2008, Jeff Garzik wrote:
> Frans Pop wrote:
> > The cards I have are:
> > - Teles 16.3 ISA -- worked way back when with Debian Woody
> > - ITK ix1-micro 2.1 ISA
> > - Eicon Diva 2.01 PCI
>
> Honestly, a module-load test on real hardware can give us some useful
> information, even if it's not connected to anything.
>
> My changes are primarily in the probe-the-hardware area, so successfully
> making it past that new code would indeed be a useful data point.
>
> Check out the kernel found in 'isdn-pci' branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

Turns out all 3 cards are supported by the same basic driver: hisax, so
I can only test for the one driver. The Eicon Diva uses an additional
module though: hisaxdiva.

I've put the last 2 cards in one machine and (after some fiddling with
jumpers and interrupts and IO ports :-) both are detected perfectly with
2.6.24 when hisax is modprobed.

Advantage of using the two cards is that it covers both PCI and ISA.
The PCI card gets configured automagically, while the ISA card requires
module parameters for io/irq.

I've compiled a kernel based on your 'isdn-pci' branch, and it boots fine.

But when I tried to modprobe hisax, I got:
# modprobe hisax
FATAL: Module hisax not found.

Cause seems to be:
# depmod -a
WARNING: Module /lib/modules/2.6.25-isdn/kernel/drivers/isdn/hisax/hisaxdiva.ko 
ignored, due to loop
WARNING: Module /lib/modules/2.6.25-isdn/kernel/drivers/isdn/hisax/libhisax.ko 
ignored, due to loop
WARNING: Loop 
detected: /lib/modules/2.6.25-isdn/kernel/drivers/isdn/hisax/hisax.ko needs 
libhisax.ko which needs hisax.ko again!
WARNING: Module /lib/modules/2.6.25-isdn/kernel/drivers/isdn/hisax/hisax.ko 
ignored, due to loop

If needed I can also try with vanilla 2.6.25 to get a bit more current
baseline test than I now have with 2.6.24.

Cheers,
FJP
