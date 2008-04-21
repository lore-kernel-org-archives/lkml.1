Return-Path: <linux-kernel-owner+w=401wt.eu-S1760257AbYDUTW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760257AbYDUTW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756202AbYDUTWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:22:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36006 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757912AbYDUTWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:22:13 -0400
Message-ID: <480CE960.4050000@garzik.org>
Date: Mon, 21 Apr 2008 15:22:08 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Subject: Re: ISDN testing
References: <20080420223959.GA17998@havoc.gtf.org> <200804210205.38891.elendil@planet.nl> <480BF15D.2090100@garzik.org> <200804211536.57655.elendil@planet.nl>
In-Reply-To: <200804211536.57655.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> On Monday 21 April 2008, Jeff Garzik wrote:
>> Frans Pop wrote:
>>> The cards I have are:
>>> - Teles 16.3 ISA -- worked way back when with Debian Woody
>>> - ITK ix1-micro 2.1 ISA
>>> - Eicon Diva 2.01 PCI
>> Honestly, a module-load test on real hardware can give us some useful
>> information, even if it's not connected to anything.
>>
>> My changes are primarily in the probe-the-hardware area, so successfully
>> making it past that new code would indeed be a useful data point.
>>
>> Check out the kernel found in 'isdn-pci' branch of
>> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git
> 
> Turns out all 3 cards are supported by the same basic driver: hisax, so
> I can only test for the one driver. The Eicon Diva uses an additional
> module though: hisaxdiva.
> 
> I've put the last 2 cards in one machine and (after some fiddling with
> jumpers and interrupts and IO ports :-) both are detected perfectly with
> 2.6.24 when hisax is modprobed.
> 
> Advantage of using the two cards is that it covers both PCI and ISA.
> The PCI card gets configured automagically, while the ISA card requires
> module parameters for io/irq.
> 
> I've compiled a kernel based on your 'isdn-pci' branch, and it boots fine.
> 
> But when I tried to modprobe hisax, I got:
> # modprobe hisax
> FATAL: Module hisax not found.
> 
> Cause seems to be:
> # depmod -a
> WARNING: Module /lib/modules/2.6.25-isdn/kernel/drivers/isdn/hisax/hisaxdiva.ko 
> ignored, due to loop
> WARNING: Module /lib/modules/2.6.25-isdn/kernel/drivers/isdn/hisax/libhisax.ko 
> ignored, due to loop
> WARNING: Loop 
> detected: /lib/modules/2.6.25-isdn/kernel/drivers/isdn/hisax/hisax.ko needs 
> libhisax.ko which needs hisax.ko again!
> WARNING: Module /lib/modules/2.6.25-isdn/kernel/drivers/isdn/hisax/hisax.ko 
> ignored, due to loop

Yeah, that's what my patchset does -- splits the "hisax" driver into 
multiple smaller drivers.  Thus, "modprobe hisax" produces the results 
that you are seeing.

You'll need to determine which newly-created kernel module applies to 
your hardware.  Let me know if you need help with that.  The new drivers 
should be in /lib/modules/2.6.25-isdn/kernel/drivers/isdn/hisax/ 
provided that you enabled them in the kernel configuration.

	Jeff



